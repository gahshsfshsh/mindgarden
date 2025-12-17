import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Backend URL - порт 7000 для MindGarden
  static const String baseUrl = 'http://158.255.6.22:7000';
  
  static String? _token;
  
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
  }
  
  static Future<void> setToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }
  
  static Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
  
  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };
  
  // ==================== AUTH ====================
  
  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/register'),
      headers: _headers,
      body: jsonEncode({
        'email': email,
        'password': password,
        'name': name,
      }),
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await setToken(data['access_token']);
      return data;
    } else {
      throw Exception(jsonDecode(response.body)['detail'] ?? 'Registration failed');
    }
  }
  
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: 'username=$email&password=$password',
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await setToken(data['access_token']);
      return data;
    } else {
      throw Exception(jsonDecode(response.body)['detail'] ?? 'Login failed');
    }
  }
  
  static Future<Map<String, dynamic>> getCurrentUser() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/auth/me'),
      headers: _headers,
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user');
    }
  }
  
  // ==================== AI CHAT ====================
  
  static Future<Map<String, dynamic>> sendChatMessage(String message) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/chat'),
      headers: _headers,
      body: jsonEncode({'message': message}),
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 429) {
      throw Exception('Лимит сообщений исчерпан. Оформите подписку для безлимитного доступа.');
    } else {
      throw Exception('Failed to send message');
    }
  }
  
  static Future<List<Map<String, dynamic>>> getChatHistory({int limit = 50}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/chat/history?limit=$limit'),
      headers: _headers,
    );
    
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get chat history');
    }
  }
  
  static Future<void> clearChatHistory() async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/chat/history'),
      headers: _headers,
    );
    
    if (response.statusCode != 200) {
      throw Exception('Failed to clear chat history');
    }
  }
  
  // ==================== CONTENT ====================
  
  static Future<List<Map<String, dynamic>>> getContent({
    String? type,
    String? category,
    String? level,
    bool? isPremium,
    String? search,
    String sort = 'newest',
    int limit = 50,
    int offset = 0,
  }) async {
    final queryParams = <String, String>{
      'sort': sort,
      'limit': limit.toString(),
      'offset': offset.toString(),
    };
    
    if (type != null) queryParams['type'] = type;
    if (category != null) queryParams['category'] = category;
    if (level != null) queryParams['level'] = level;
    if (isPremium != null) queryParams['is_premium'] = isPremium.toString();
    if (search != null) queryParams['search'] = search;
    
    final uri = Uri.parse('$baseUrl/api/content').replace(queryParameters: queryParams);
    final response = await http.get(uri, headers: _headers);
    
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get content');
    }
  }
  
  static Future<Map<String, dynamic>> getContentById(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/content/$id'),
      headers: _headers,
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Content not found');
    }
  }
  
  static Future<void> recordPlay(int contentId) async {
    await http.post(
      Uri.parse('$baseUrl/api/content/$contentId/play'),
      headers: _headers,
    );
  }
  
  // ==================== PROGRESS ====================
  
  static Future<Map<String, dynamic>> getProgress() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/progress'),
      headers: _headers,
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get progress');
    }
  }
  
  static Future<Map<String, dynamic>> completeSession({
    required int contentId,
    required int durationMinutes,
    int? rating,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/progress/session'),
      headers: _headers,
      body: jsonEncode({
        'content_id': contentId,
        'duration_minutes': durationMinutes,
        if (rating != null) 'rating': rating,
      }),
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to complete session');
    }
  }
  
  static Future<List<Map<String, dynamic>>> getAchievements() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/progress/achievements'),
      headers: _headers,
    );
    
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get achievements');
    }
  }
  
  // ==================== MOOD ====================
  
  static Future<Map<String, dynamic>> recordMood({
    required int moodValue,
    List<String> factors = const [],
    String? note,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/mood'),
      headers: _headers,
      body: jsonEncode({
        'mood_value': moodValue,
        'factors': factors,
        if (note != null) 'note': note,
      }),
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to record mood');
    }
  }
  
  static Future<List<Map<String, dynamic>>> getMoodHistory({int days = 30}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/mood/history?days=$days'),
      headers: _headers,
    );
    
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get mood history');
    }
  }
  
  // ==================== RECOMMENDATIONS ====================
  
  static Future<List<Map<String, dynamic>>> getRecommendations({int limit = 10}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/recommendations?limit=$limit'),
      headers: _headers,
    );
    
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get recommendations');
    }
  }
  
  // ==================== PAYMENTS ====================
  
  static Future<Map<String, dynamic>> createPayment({
    required String plan,
    String provider = 'yukassa',
    String? returnUrl,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/payments/create'),
      headers: _headers,
      body: jsonEncode({
        'plan': plan,
        'provider': provider,
        if (returnUrl != null) 'return_url': returnUrl,
      }),
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create payment');
    }
  }
  
  // ==================== GENERIC HTTP METHODS ====================
  
  /// POST request (for PaymentService)
  Future<http.Response> post(String path, {Map<String, dynamic>? body}) async {
    return await http.post(
      Uri.parse('$baseUrl$path'),
      headers: _headers,
      body: body != null ? jsonEncode(body) : null,
    );
  }
  
  /// GET request (for PaymentService)
  Future<http.Response> get(String path) async {
    return await http.get(
      Uri.parse('$baseUrl$path'),
      headers: _headers,
    );
  }
}
