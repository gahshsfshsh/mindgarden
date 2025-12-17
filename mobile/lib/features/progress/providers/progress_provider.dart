import 'package:flutter/foundation.dart';
import '../../../core/services/api_service.dart';
import '../../../core/models/progress_model.dart';

class ProgressProvider with ChangeNotifier {
  ProgressModel _progress = ProgressModel(
    totalMinutes: 0,
    totalSessions: 0,
    currentStreak: 0,
    longestStreak: 0,
  );
  List<AchievementModel> _achievements = [];
  bool _isLoading = false;
  String? _error;

  ProgressModel get progress => _progress;
  List<AchievementModel> get achievements => _achievements;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadProgress() async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await ApiService.getProgress();
      _progress = ProgressModel.fromJson(data);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadAchievements() async {
    try {
      final data = await ApiService.getAchievements();
      _achievements = data.map((e) => AchievementModel.fromJson(e)).toList();
      notifyListeners();
    } catch (e) {
      // Achievements are optional
    }
  }

  Future<void> completeSession({
    required int contentId,
    required int durationMinutes,
  }) async {
    try {
      final result = await ApiService.completeSession(
        contentId: contentId,
        durationMinutes: durationMinutes,
      );
      
      if (result['progress'] != null) {
        _progress = ProgressModel.fromJson(result['progress']);
      }
      
      // Reload achievements to check for new unlocks
      await loadAchievements();
      
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    }
  }

  List<AchievementModel> get unlockedAchievements {
    return _achievements.where((a) => a.isUnlocked).toList();
  }

  List<AchievementModel> get lockedAchievements {
    return _achievements.where((a) => !a.isUnlocked).toList();
  }
}


