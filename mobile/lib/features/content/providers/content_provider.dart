import 'package:flutter/foundation.dart';
import '../../../core/services/api_service.dart';
import '../../../core/models/content_model.dart';

class ContentProvider with ChangeNotifier {
  List<ContentModel> _meditations = [];
  List<ContentModel> _yoga = [];
  List<ContentModel> _sleep = [];
  List<ContentModel> _recommendations = [];
  
  List<String> _meditationCategories = [];
  List<String> _yogaCategories = [];
  List<String> _sleepCategories = [];
  
  bool _isLoading = false;
  String? _error;

  List<ContentModel> get meditations => _meditations;
  List<ContentModel> get yoga => _yoga;
  List<ContentModel> get sleep => _sleep;
  List<ContentModel> get recommendations => _recommendations;
  
  List<String> get meditationCategories => _meditationCategories;
  List<String> get yogaCategories => _yogaCategories;
  List<String> get sleepCategories => _sleepCategories;
  
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadAllContent() async {
    if (_meditations.isNotEmpty) return; // Already loaded
    
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.wait([
        loadMeditations(),
        loadYoga(),
        loadSleep(),
        loadCategories(),
      ]);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMeditations({String? category}) async {
    try {
      final data = await ApiService.getContent(
        type: 'meditation',
        category: category,
        limit: 200,
      );
      _meditations = data.map((e) => ContentModel.fromJson(e)).toList();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    }
  }

  Future<void> loadYoga({String? category}) async {
    try {
      final data = await ApiService.getContent(
        type: 'yoga',
        category: category,
        limit: 200,
      );
      _yoga = data.map((e) => ContentModel.fromJson(e)).toList();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    }
  }

  Future<void> loadSleep({String? category}) async {
    try {
      final data = await ApiService.getContent(
        type: 'sleep',
        category: category,
        limit: 200,
      );
      _sleep = data.map((e) => ContentModel.fromJson(e)).toList();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    }
  }

  Future<void> loadCategories() async {
    try {
      final results = await Future.wait([
        ApiService.getCategories('meditation'),
        ApiService.getCategories('yoga'),
        ApiService.getCategories('sleep'),
      ]);
      _meditationCategories = results[0];
      _yogaCategories = results[1];
      _sleepCategories = results[2];
      notifyListeners();
    } catch (e) {
      // Categories are optional
    }
  }

  Future<void> loadRecommendations() async {
    try {
      final data = await ApiService.getRecommendations();
      _recommendations = data.map((e) => ContentModel.fromJson(e)).toList();
      notifyListeners();
    } catch (e) {
      // Recommendations are optional
    }
  }

  List<ContentModel> filterByCategory(List<ContentModel> items, String? category) {
    if (category == null || category == 'Все') return items;
    return items.where((item) => item.category == category).toList();
  }

  List<ContentModel> filterFree(List<ContentModel> items) {
    return items.where((item) => !item.isPremium).toList();
  }

  ContentModel? getById(int id) {
    final all = [..._meditations, ..._yoga, ..._sleep];
    try {
      return all.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }
}


