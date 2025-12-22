/// Конфигурация приложения MindGarden
/// Переключение между dev/staging/production серверами
class AppConfig {
  // ============ ОКРУЖЕНИЯ ============
  
  /// DEV сервер (для разработки и тестирования)
  static const String devApiUrl = 'http://188.68.223.230:3000';
  
  /// STAGING сервер (текущий production)
  static const String stagingApiUrl = 'http://158.255.6.22:7000';
  
  /// PRODUCTION сервер (когда будет готов)
  static const String productionApiUrl = 'https://api.mindgarden.app';
  
  // ============ ТЕКУЩЕЕ ОКРУЖЕНИЕ ============
  
  /// Активный URL API
  /// Измените на нужное окружение перед сборкой
  static const String apiUrl = devApiUrl;  // <-- Меняй здесь!
  
  // ============ APP INFO ============
  
  static const String appName = 'MindGarden';
  static const String appVersion = '2.1.0';
  static const int buildNumber = 2;
  
  // ============ DEEP LINKS ============
  
  static const String deepLinkScheme = 'mindgarden';
  static const String deepLinkHost = 'app';
  
  // ============ FEATURE FLAGS ============
  
  static const bool enableAnalytics = false;
  static const bool enableCrashlytics = false;
  static const bool showDebugBanner = true;
  
  // ============ TIMEOUTS ============
  
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration connectionTimeout = Duration(seconds: 10);
  
  // ============ CACHE ============
  
  static const Duration cacheDuration = Duration(hours: 24);
  static const int maxCacheItems = 100;
}



