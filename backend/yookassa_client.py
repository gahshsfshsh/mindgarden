"""
YooKassa клиент для MindGarden
Полная интеграция с SDK yookassa
"""

import asyncio
import functools
import json
import logging
import os
from uuid import uuid4
from typing import Optional

from yookassa import Payment as YKPayment, Configuration
from dotenv import load_dotenv

load_dotenv()

log = logging.getLogger("yookassa")

# Настройка конфигурации YooKassa
YK_SHOP_ID = os.getenv("YK_SHOP_ID", os.getenv("YUKASSA_SHOP_ID", ""))
YK_SECRET_KEY = os.getenv("YK_SECRET_KEY", os.getenv("YUKASSA_SECRET_KEY", ""))

if YK_SHOP_ID and YK_SECRET_KEY:
    Configuration.account_id = YK_SHOP_ID
    Configuration.secret_key = YK_SECRET_KEY


class YooKassaError(Exception):
    """Базовый класс для ошибок YooKassa."""
    def __init__(self, message: str, code: str | None = None, 
                 status_code: int | None = None, response = None):
        super().__init__(message)
        self.message = message
        self.code = code
        self.status_code = status_code
        self.response = response


def _safe_yk_create(payload: dict, idempotency_key: str) -> dict:
    """
    Синхронная обёртка над YKPayment.create с полным перехватом ошибок.
    """
    try:
        obj = YKPayment.create(payload, idempotency_key=idempotency_key)
        if hasattr(obj, 'json'):
            return json.loads(obj.json())
        elif hasattr(obj, 'dict'):
            return obj.dict()
        else:
            return obj.__dict__
    except Exception as e:
        error_type = type(e).__name__
        
        # Проверяем на HTTP ошибки
        response = getattr(e, 'response', None)
        status_code = getattr(response, 'status_code', None) if response else None
        
        if hasattr(e, 'code') and hasattr(e, 'description'):
            raise YooKassaError(
                message=getattr(e, 'description', None) or str(e),
                code=getattr(e, 'code', None),
                status_code=status_code,
                response=response
            ) from e
        
        log.error(f"Unexpected error in YooKassa SDK ({error_type}): {str(e)}", exc_info=True)
        raise YooKassaError(message=f"Ошибка платежной системы: {str(e)}", code="SDK_ERROR") from e


def _safe_yk_find_one(payment_id: str) -> dict:
    """
    Синхронная обёртка над YKPayment.find_one.
    """
    try:
        obj = YKPayment.find_one(payment_id)
        if hasattr(obj, 'json'):
            return json.loads(obj.json())
        elif hasattr(obj, 'dict'):
            return obj.dict()
        else:
            return obj.__dict__
    except Exception as e:
        error_type = type(e).__name__
        response = getattr(e, 'response', None)
        status_code = getattr(response, 'status_code', None) if response else None
        
        if hasattr(e, 'code') and hasattr(e, 'description'):
            raise YooKassaError(
                message=getattr(e, 'description', None) or str(e),
                code=getattr(e, 'code', None),
                status_code=status_code,
                response=response
            ) from e
        
        log.error(f"Unexpected error in YooKassa find_one ({error_type}): {str(e)}", exc_info=True)
        raise YooKassaError(message=f"Ошибка платежной системы: {str(e)}", code="SDK_ERROR") from e


async def yk_create_payment(
    *,
    amount: str,
    description: str,
    return_url: str,
    metadata: dict | None = None,
    capture: bool = True,
    customer_email: str | None = None,
    customer_phone: str | None = None,
) -> dict:
    """
    Создать платёж через redirect (веб-версия).
    Возвращает dict с payment_id, confirmation_url, status.
    """
    payload = {
        "amount": {"value": amount, "currency": "RUB"},
        "capture": capture,
        "description": description,
        "metadata": metadata or {},
        "confirmation": {
            "type": "redirect",
            "return_url": return_url
        }
    }
    
    # Добавляем чек для 54-ФЗ
    customer_data = {}
    if customer_phone:
        customer_data["phone"] = customer_phone
    if customer_email:
        customer_data["email"] = customer_email
    if not customer_data:
        customer_data["email"] = "customer@mindgarden.app"
    
    payload["receipt"] = {
        "customer": customer_data,
        "items": [
            {
                "description": description[:128] if description else "Подписка MindGarden",
                "quantity": "1.00",
                "amount": {"value": amount, "currency": "RUB"},
                "vat_code": 1,  # НДС не облагается
                "payment_subject": "service",
                "payment_mode": "full_payment",
            }
        ]
    }
    
    loop = asyncio.get_running_loop()
    result = await loop.run_in_executor(
        None,
        functools.partial(_safe_yk_create, payload, str(uuid4()))
    )
    
    return {
        "payment_id": result.get("id"),
        "confirmation_url": result.get("confirmation", {}).get("confirmation_url"),
        "status": result.get("status"),
        "raw": result
    }


async def yk_create_by_token(
    *,
    amount: str,
    description: str,
    payment_token: str,
    metadata: dict | None = None,
    capture: bool = True,
    customer_email: str | None = None,
    customer_phone: str | None = None,
    return_url: str | None = None
) -> dict:
    """
    Создать платёж по payment_token (мобильные SDK YooKassa).
    Используется для интеграции с yookassa_payments_flutter.
    """
    payload = {
        "payment_token": payment_token,
        "amount": {"value": amount, "currency": "RUB"},
        "capture": capture,
        "description": description,
        "metadata": metadata or {},
    }
    
    # Добавляем confirmation для redirect (нужен для СБП)
    if return_url:
        payload["confirmation"] = {
            "type": "redirect",
            "return_url": return_url
        }
    
    # Добавляем чек для 54-ФЗ
    customer_data = {}
    if customer_phone:
        customer_data["phone"] = customer_phone
    if customer_email:
        customer_data["email"] = customer_email
    if not customer_data:
        customer_data["email"] = "customer@mindgarden.app"
    
    payload["receipt"] = {
        "customer": customer_data,
        "items": [
            {
                "description": description[:128] if description else "Подписка MindGarden",
                "quantity": "1.00",
                "amount": {"value": amount, "currency": "RUB"},
                "vat_code": 1,
                "payment_subject": "service",
                "payment_mode": "full_payment",
            }
        ]
    }
    
    loop = asyncio.get_running_loop()
    result = await loop.run_in_executor(
        None,
        functools.partial(_safe_yk_create, payload, str(uuid4()))
    )
    
    return result


async def yk_get_payment(yk_payment_id: str) -> dict:
    """Получить информацию о платеже из YooKassa."""
    loop = asyncio.get_running_loop()
    return await loop.run_in_executor(
        None,
        functools.partial(_safe_yk_find_one, yk_payment_id)
    )


async def yk_check_payment_status(yk_payment_id: str) -> str:
    """Проверить статус платежа. Возвращает: pending, succeeded, canceled."""
    try:
        payment = await yk_get_payment(yk_payment_id)
        return payment.get("status", "unknown")
    except Exception as e:
        log.error(f"Error checking payment status: {e}")
        return "error"


# Цены подписок
SUBSCRIPTION_PRICES = {
    "monthly": "449.00",
    "yearly": "2990.00",
    "lifetime": "4990.00",
}


async def create_subscription_payment(
    user_id: int,
    user_email: str,
    plan: str,
    return_url: str = "mindgarden://payment-success"
) -> dict:
    """
    Создать платёж для подписки.
    plan: monthly, yearly, lifetime
    """
    if plan not in SUBSCRIPTION_PRICES:
        raise ValueError(f"Invalid plan: {plan}. Valid: {list(SUBSCRIPTION_PRICES.keys())}")
    
    amount = SUBSCRIPTION_PRICES[plan]
    
    plan_names = {
        "monthly": "MindGarden Premium (месяц)",
        "yearly": "MindGarden Premium (год)",
        "lifetime": "MindGarden Premium (навсегда)",
    }
    
    return await yk_create_payment(
        amount=amount,
        description=plan_names[plan],
        return_url=return_url,
        customer_email=user_email,
        metadata={
            "user_id": str(user_id),
            "plan": plan,
            "type": "subscription"
        }
    )

