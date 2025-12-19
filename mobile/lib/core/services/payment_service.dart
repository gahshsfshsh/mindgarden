import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'api_service.dart';

/// Планы подписки
enum SubscriptionPlan {
  free,
  monthly,
  yearly,
  lifetime,
}

/// Информация о плане
class PlanInfo {
  final String id;
  final String name;
  final String description;
  final double price;
  final String currency;
  final String period;
  final List<String> features;
  final bool isPopular;
  final int? savings;

  const PlanInfo({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.currency,
    required this.period,
    required this.features,
    this.isPopular = false,
    this.savings,
  });
}

/// Результат создания платежа
class PaymentResult {
  final bool success;
  final String? paymentId;
  final String? confirmationUrl;
  final String? status;
  final String? errorMessage;
  final bool isPremium;

  PaymentResult({
    required this.success,
    this.paymentId,
    this.confirmationUrl,
    this.status,
    this.errorMessage,
    this.isPremium = false,
  });
}

/// Сервис оплаты с интеграцией YooKassa
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
      period: 'free',
      features: [
        '90+ бесплатных практик',
        'Базовая статистика',
        'Ежедневные рекомендации',
        'Трекер настроения',
        '10 AI-сообщений в день',
      ],
    ),
    PlanInfo(
      id: 'monthly',
      name: 'Месячная',
      description: 'Premium доступ на месяц',
      price: 449,
      currency: 'RUB',
      period: 'month',
      features: [
        'Всё из бесплатного',
        '340+ premium практик',
        'Без рекламы',
        'AI-советы без лимитов',
        'Офлайн-режим',
      ],
    ),
    PlanInfo(
      id: 'yearly',
      name: 'Годовая',
      description: 'Premium доступ на год',
      price: 2990,
      currency: 'RUB',
      period: 'year',
      features: [
        'Всё из месячной',
        'Экономия 2398 ₽',
        'Приоритетная поддержка',
      ],
      isPopular: true,
      savings: 2398,
    ),
    PlanInfo(
      id: 'lifetime',
      name: 'Навсегда',
      description: 'Один раз и навсегда',
      price: 4990,
      currency: 'RUB',
      period: 'lifetime',
      features: [
        'Всё из Premium',
        'Пожизненный доступ',
        'Все будущие обновления',
        'Эксклюзивный контент',
      ],
    ),
  ];

  /// Создать платёж через мобильный API (redirect)
  Future<PaymentResult> createMobilePayment({
    required String plan,
    String? returnUrl,
  }) async {
    try {
      final response = await _apiService.post(
        '/api/payments/mobile/create',
        body: {
          'plan': plan,
          'return_url': returnUrl ?? 'mindgarden://payment-success',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PaymentResult(
          success: data['success'] ?? false,
          paymentId: data['payment_id'],
          confirmationUrl: data['confirmation_url'],
          status: data['status'],
        );
      } else {
        final error = jsonDecode(response.body);
        return PaymentResult(
          success: false,
          errorMessage: error['detail']?['message'] ?? 'Ошибка создания платежа',
        );
      }
    } catch (e) {
      return PaymentResult(
        success: false,
        errorMessage: 'Ошибка сети: $e',
      );
    }
  }

  /// Создать платёж по токену (для YooKassa SDK)
  Future<PaymentResult> createPaymentByToken({
    required String paymentToken,
    required String plan,
    required double amount,
    String? returnUrl,
  }) async {
    try {
      final response = await _apiService.post(
        '/api/payments/mobile/create-by-token',
        body: {
          'payment_token': paymentToken,
          'amount': amount.toStringAsFixed(2),
          'description': 'MindGarden ${plan == 'monthly' ? 'Месяц' : plan == 'yearly' ? 'Год' : 'Навсегда'}',
          'plan': plan,
          'return_url': returnUrl,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PaymentResult(
          success: data['success'] ?? false,
          paymentId: data['payment_id'],
          confirmationUrl: data['confirmation_url'],
          status: data['status'],
          isPremium: data['is_premium'] ?? false,
        );
      } else {
        final error = jsonDecode(response.body);
        return PaymentResult(
          success: false,
          errorMessage: error['detail']?['message'] ?? 'Ошибка создания платежа',
        );
      }
    } catch (e) {
      return PaymentResult(
        success: false,
        errorMessage: 'Ошибка сети: $e',
      );
    }
  }

  /// Проверить статус платежа
  Future<PaymentResult> checkPaymentStatus(String paymentId) async {
    try {
      final response = await _apiService.get(
        '/api/payments/mobile/status/$paymentId',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PaymentResult(
          success: true,
          paymentId: data['payment_id'],
          status: data['status'],
          isPremium: data['is_premium'] ?? false,
        );
      } else {
        return PaymentResult(
          success: false,
          errorMessage: 'Ошибка проверки статуса',
        );
      }
    } catch (e) {
      return PaymentResult(
        success: false,
        errorMessage: 'Ошибка сети: $e',
      );
    }
  }

  /// Получить список планов с сервера
  Future<List<PlanInfo>> fetchPlans() async {
    try {
      final response = await _apiService.get('/api/payments/plans');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> plansData = data['plans'] ?? [];
        
        return plansData.map((p) => PlanInfo(
          id: p['id'],
          name: p['name'],
          description: p['description'] ?? '',
          price: (p['price'] as num).toDouble(),
          currency: p['currency'] ?? 'RUB',
          period: p['period'] ?? 'month',
          features: List<String>.from(p['features'] ?? []),
          isPopular: p['popular'] ?? false,
        )).toList();
      }
    } catch (e) {
      debugPrint('Error fetching plans: $e');
    }
    
    // Fallback to static plans
    return plans.where((p) => p.id != 'free').toList();
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
  }) async {
    final result = await createMobilePayment(plan: plan);

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

  /// Форматировать период
  static String formatPeriod(String period) {
    switch (period) {
      case 'month':
        return '/мес';
      case 'year':
        return '/год';
      case 'lifetime':
        return '';
      default:
        return '';
    }
  }
}
