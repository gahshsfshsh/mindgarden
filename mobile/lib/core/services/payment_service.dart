import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'api_service.dart';

/// Планы подписки
enum SubscriptionPlan {
  free,
  premium,
  lifetime,
}

/// Информация о плане
class PlanInfo {
  final String id;
  final String name;
  final String description;
  final double price;
  final String currency;
  final List<String> features;
  final bool isPopular;

  const PlanInfo({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.currency,
    required this.features,
    this.isPopular = false,
  });
}

/// Результат создания платежа
class PaymentResult {
  final bool success;
  final String? paymentId;
  final String? confirmationUrl;
  final String? errorMessage;

  PaymentResult({
    required this.success,
    this.paymentId,
    this.confirmationUrl,
    this.errorMessage,
  });
}

/// Сервис оплаты
class PaymentService {
  final ApiService _apiService;

  PaymentService(this._apiService);

  /// Доступные планы
  static const List<PlanInfo> plans = [
    PlanInfo(
      id: 'free',
      name: 'Бесплатный',
      description: 'Начните свой путь к гармонии',
      price: 0,
      currency: 'RUB',
      features: [
        '90+ бесплатных практик',
        'Базовая статистика',
        'Ежедневные рекомендации',
        'Трекер настроения',
      ],
    ),
    PlanInfo(
      id: 'premium',
      name: 'Premium',
      description: 'Полный доступ ко всему контенту',
      price: 490,
      currency: 'RUB',
      features: [
        'Всё из бесплатного',
        '340+ premium практик',
        'Без рекламы',
        'Офлайн-режим',
        'Приоритетная поддержка',
      ],
      isPopular: true,
    ),
    PlanInfo(
      id: 'lifetime',
      name: 'Навсегда',
      description: 'Один раз и навсегда',
      price: 4990,
      currency: 'RUB',
      features: [
        'Всё из Premium',
        'Пожизненный доступ',
        'Все будущие обновления',
        'Эксклюзивный контент',
      ],
    ),
  ];

  /// Создать платёж через ЮКассу
  Future<PaymentResult> createYuKassaPayment({
    required String plan,
    String? returnUrl,
  }) async {
    try {
      final response = await _apiService.post(
        '/api/payments/create',
        body: {
          'plan': plan,
          'provider': 'yukassa',
          'return_url': returnUrl ?? 'zenflow://payment-success',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PaymentResult(
          success: true,
          paymentId: data['payment_id'],
          confirmationUrl: data['confirmation_url'],
        );
      } else {
        return PaymentResult(
          success: false,
          errorMessage: 'Ошибка создания платежа: ${response.statusCode}',
        );
      }
    } catch (e) {
      return PaymentResult(
        success: false,
        errorMessage: 'Ошибка: $e',
      );
    }
  }

  /// Создать платёж через Stripe
  Future<PaymentResult> createStripePayment({
    required String plan,
    String? returnUrl,
  }) async {
    try {
      final response = await _apiService.post(
        '/api/payments/create',
        body: {
          'plan': plan,
          'provider': 'stripe',
          'return_url': returnUrl,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PaymentResult(
          success: true,
          paymentId: data['session_id'],
          confirmationUrl: data['checkout_url'],
        );
      } else {
        return PaymentResult(
          success: false,
          errorMessage: 'Ошибка создания платежа: ${response.statusCode}',
        );
      }
    } catch (e) {
      return PaymentResult(
        success: false,
        errorMessage: 'Ошибка: $e',
      );
    }
  }

  /// Открыть страницу оплаты
  Future<bool> openPaymentUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error opening payment URL: $e');
      return false;
    }
  }

  /// Начать процесс оплаты
  Future<PaymentResult> startPayment({
    required String plan,
    String provider = 'yukassa',
  }) async {
    PaymentResult result;
    
    if (provider == 'stripe') {
      result = await createStripePayment(plan: plan);
    } else {
      result = await createYuKassaPayment(plan: plan);
    }

    if (result.success && result.confirmationUrl != null) {
      await openPaymentUrl(result.confirmationUrl!);
    }

    return result;
  }

  /// Получить информацию о плане
  static PlanInfo? getPlanInfo(String planId) {
    try {
      return plans.firstWhere((p) => p.id == planId);
    } catch (e) {
      return null;
    }
  }

  /// Форматировать цену
  static String formatPrice(double price, String currency) {
    if (price == 0) return 'Бесплатно';
    
    switch (currency) {
      case 'RUB':
        return '${price.toStringAsFixed(0)} ₽';
      case 'USD':
        return '\$${price.toStringAsFixed(2)}';
      case 'EUR':
        return '€${price.toStringAsFixed(2)}';
      default:
        return '${price.toStringAsFixed(2)} $currency';
    }
  }
}


