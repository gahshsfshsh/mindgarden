import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  // Измените на URL вашего API после деплоя
  static const String baseUrl = kDebugMode 
      ? 'http://10.0.2.2:8000'  // Android Emulator
      : 'https://zenflow-api.vercel.app';
  
  String? _token;
  
  // Singleton
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  /// Получить токен из хранилища
  Future<String?> getToken() async {
    if (_token != null) return _token;
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    return _token;
  }

  /// Сохранить токен
  Future<void> setToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  /// Удалить токен (выход)
  Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  /// Заголовки
  Future<Map<String, String>> _getHeaders({bool auth = true}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (auth) {
      final token = await getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    
    return headers;
  }

  /// GET запрос
  Future<http.Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    bool auth = true,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint').replace(
      queryParameters: queryParams?.map((k, v) => MapEntry(k, v.toString())),
    );
    
    final headers = await _getHeaders(auth: auth);
    
    debugPrint('GET: $uri');
    
    return http.get(uri, headers: headers);
  }

  /// POST запрос
  Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool auth = true,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final headers = await _getHeaders(auth: auth);
    
    debugPrint('POST: $uri');
    debugPrint('Body: $body');
    
    return http.post(
      uri,
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
  }

  /// PUT запрос
  Future<http.Response> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool auth = true,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final headers = await _getHeaders(auth: auth);
    
    return http.put(
      uri,
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
  }

  /// DELETE запрос
  Future<http.Response> delete(
    String endpoint, {
    bool auth = true,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final headers = await _getHeaders(auth: auth);
    
    return http.delete(uri, headers: headers);
  }

  // ==================== AUTH ====================

  /// Регистрация
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final response = await post(
      '/api/auth/register',
      body: {
        'email': email,
        'password': password,
        'name': name,
      },
      auth: false,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await setToken(data['access_token']);
      return data;
    } else {
      throw ApiException(
        response.statusCode,
        jsonDecode(response.body)['detail'] ?? 'Ошибка регистрации',
      );
    }
  }

  /// Вход
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('$baseUrl/api/auth/login');
    
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'username': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await setToken(data['access_token']);
      return data;
    } else {
      throw ApiException(
        response.statusCode,
        jsonDecode(response.body)['detail'] ?? 'Неверный email или пароль',
      );
    }
  }

  /// Текущий пользователь
  Future<Map<String, dynamic>> getCurrentUser() async {
    final response = await get('/api/auth/me');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw ApiException(response.statusCode, 'Ошибка получения пользователя');
    }
  }

  // ==================== CONTENT ====================

  /// Получить контент
  Future<List<dynamic>> getContent({
    String? type,
    String? category,
    String? level,
    bool? isPremium,
    String? search,
    String sort = 'newest',
    int limit = 50,
    int offset = 0,
  }) async {
    final queryParams = <String, dynamic>{
      'sort': sort,
      'limit': limit.toString(),
      'offset': offset.toString(),
    };
    
    if (type != null) queryParams['type'] = type;
    if (category != null) queryParams['category'] = category;
    if (level != null) queryParams['level'] = level;
    if (isPremium != null) queryParams['is_premium'] = isPremium.toString();
    if (search != null) queryParams['search'] = search;

    final response = await get('/api/content', queryParams: queryParams);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw ApiException(response.statusCode, 'Ошибка загрузки контента');
    }
  }

  /// Получить рекомендации
  Future<List<dynamic>> getRecommendations({int limit = 10}) async {
    final response = await get(
      '/api/recommendations',
      queryParams: {'limit': limit.toString()},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw ApiException(response.statusCode, 'Ошибка загрузки рекомендаций');
    }
  }

  // ==================== PROGRESS ====================

  /// Получить прогресс
  Future<Map<String, dynamic>> getProgress() async {
    final response = await get('/api/progress');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw ApiException(response.statusCode, 'Ошибка загрузки прогресса');
    }
  }

  /// Записать сессию
  Future<Map<String, dynamic>> recordSession({
    required int contentId,
    required int durationMinutes,
    int? rating,
  }) async {
    final response = await post(
      '/api/progress/session',
      body: {
        'content_id': contentId,
        'duration_minutes': durationMinutes,
        if (rating != null) 'rating': rating,
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw ApiException(response.statusCode, 'Ошибка записи сессии');
    }
  }

  /// Получить достижения
  Future<List<dynamic>> getAchievements() async {
    final response = await get('/api/progress/achievements');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw ApiException(response.statusCode, 'Ошибка загрузки достижений');
    }
  }

  // ==================== MOOD ====================

  /// Записать настроение
  Future<Map<String, dynamic>> recordMood({
    required int moodValue,
    List<String> factors = const [],
    String? note,
  }) async {
    final response = await post(
      '/api/mood',
      body: {
        'mood_value': moodValue,
        'factors': factors,
        if (note != null) 'note': note,
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw ApiException(response.statusCode, 'Ошибка записи настроения');
    }
  }

  /// История настроения
  Future<List<dynamic>> getMoodHistory({int days = 30}) async {
    final response = await get(
      '/api/mood/history',
      queryParams: {'days': days.toString()},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw ApiException(response.statusCode, 'Ошибка загрузки истории');
    }
  }
}

/// Исключение API
class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException(this.statusCode, this.message);

  @override
  String toString() => 'ApiException($statusCode): $message';
}
