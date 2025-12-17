"""
Модуль платежей - Stripe и ЮКасса
"""

import os
import uuid
from datetime import datetime, timedelta
from typing import Optional
import httpx

# ==================== YUKASSA ====================

YUKASSA_SHOP_ID = os.getenv("YUKASSA_SHOP_ID")
YUKASSA_SECRET_KEY = os.getenv("YUKASSA_SECRET_KEY")
YUKASSA_API_URL = "https://api.yookassa.ru/v3"

class YuKassaPayment:
    """ЮКасса платежи"""
    
    @staticmethod
    async def create_payment(
        amount: float,
        currency: str = "RUB",
        description: str = "ZenFlow Premium",
        return_url: str = None,
        metadata: dict = None
    ) -> dict:
        """Создать платёж в ЮКассе"""
        
        if not YUKASSA_SHOP_ID or not YUKASSA_SECRET_KEY:
            raise ValueError("YuKassa credentials not configured")
        
        idempotence_key = str(uuid.uuid4())
        
        payload = {
            "amount": {
                "value": f"{amount:.2f}",
                "currency": currency
            },
            "confirmation": {
                "type": "redirect",
                "return_url": return_url or os.getenv("FRONTEND_URL", "https://zenflow.vercel.app")
            },
            "capture": True,
            "description": description,
            "metadata": metadata or {}
        }
        
        async with httpx.AsyncClient() as client:
            response = await client.post(
                f"{YUKASSA_API_URL}/payments",
                json=payload,
                auth=(YUKASSA_SHOP_ID, YUKASSA_SECRET_KEY),
                headers={
                    "Idempotence-Key": idempotence_key,
                    "Content-Type": "application/json"
                }
            )
            
            if response.status_code == 200:
                return response.json()
            else:
                raise Exception(f"YuKassa error: {response.text}")
    
    @staticmethod
    async def get_payment(payment_id: str) -> dict:
        """Получить информацию о платеже"""
        
        async with httpx.AsyncClient() as client:
            response = await client.get(
                f"{YUKASSA_API_URL}/payments/{payment_id}",
                auth=(YUKASSA_SHOP_ID, YUKASSA_SECRET_KEY)
            )
            
            if response.status_code == 200:
                return response.json()
            else:
                raise Exception(f"YuKassa error: {response.text}")
    
    @staticmethod
    async def create_subscription(
        user_id: int,
        plan: str,  # "premium" or "lifetime"
        return_url: str = None
    ) -> dict:
        """Создать подписку через ЮКассу"""
        
        prices = {
            "premium": 490.0,
            "lifetime": 4990.0
        }
        
        if plan not in prices:
            raise ValueError(f"Invalid plan: {plan}")
        
        payment = await YuKassaPayment.create_payment(
            amount=prices[plan],
            description=f"ZenFlow {plan.title()} подписка",
            return_url=return_url,
            metadata={
                "user_id": str(user_id),
                "plan": plan,
                "type": "subscription"
            }
        )
        
        return {
            "payment_id": payment["id"],
            "confirmation_url": payment["confirmation"]["confirmation_url"],
            "status": payment["status"]
        }


# ==================== STRIPE ====================

class StripePayment:
    """Stripe платежи"""
    
    @staticmethod
    async def create_checkout_session(
        user_email: str,
        user_id: int,
        plan: str,
        success_url: str = None,
        cancel_url: str = None
    ) -> dict:
        """Создать Stripe Checkout Session"""
        
        import stripe
        stripe.api_key = os.getenv("STRIPE_SECRET_KEY")
        
        if not stripe.api_key:
            raise ValueError("Stripe not configured")
        
        prices = {
            "premium": os.getenv("STRIPE_PRICE_PREMIUM"),
            "lifetime": os.getenv("STRIPE_PRICE_LIFETIME")
        }
        
        if plan not in prices or not prices[plan]:
            raise ValueError(f"Invalid plan or price not configured: {plan}")
        
        frontend_url = os.getenv("FRONTEND_URL", "https://zenflow.vercel.app")
        
        session = stripe.checkout.Session.create(
            customer_email=user_email,
            payment_method_types=["card"],
            line_items=[{
                "price": prices[plan],
                "quantity": 1
            }],
            mode="subscription" if plan == "premium" else "payment",
            success_url=success_url or f"{frontend_url}/success?session_id={{CHECKOUT_SESSION_ID}}",
            cancel_url=cancel_url or f"{frontend_url}/pricing",
            metadata={
                "user_id": str(user_id),
                "plan": plan
            }
        )
        
        return {
            "session_id": session.id,
            "checkout_url": session.url
        }


# ==================== SUBSCRIPTION MANAGER ====================

class SubscriptionManager:
    """Управление подписками"""
    
    PLANS = {
        "free": {"name": "Бесплатный", "price": 0, "features": ["90+ практик", "Базовая статистика"]},
        "premium": {"name": "Premium", "price": 490, "features": ["340+ практик", "Без рекламы", "Офлайн"]},
        "lifetime": {"name": "Навсегда", "price": 4990, "features": ["Всё из Premium", "Навсегда"]}
    }
    
    @staticmethod
    def get_plan_features(plan: str) -> dict:
        return SubscriptionManager.PLANS.get(plan, SubscriptionManager.PLANS["free"])
    
    @staticmethod
    def calculate_subscription_end(plan: str) -> Optional[datetime]:
        if plan == "premium":
            return datetime.utcnow() + timedelta(days=30)
        elif plan == "lifetime":
            return datetime.utcnow() + timedelta(days=365 * 100)  # 100 years
        return None
    
    @staticmethod
    def is_premium_active(subscription_end: Optional[datetime]) -> bool:
        if subscription_end is None:
            return False
        return datetime.utcnow() < subscription_end


