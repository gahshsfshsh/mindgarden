import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../core/models/content_model.dart';

class PlayerProvider with ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  ContentModel? _currentContent;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isLoading = false;
  String? _error;
  
  // Timer for sleep sounds
  Duration? _sleepTimer;
  DateTime? _timerEndTime;

  ContentModel? get currentContent => _currentContent;
  bool get isPlaying => _isPlaying;
  Duration get position => _position;
  Duration get duration => _duration;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Duration? get sleepTimer => _sleepTimer;
  Duration? get remainingTimer {
    if (_timerEndTime == null) return null;
    final remaining = _timerEndTime!.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  PlayerProvider() {
    _setupPlayer();
  }

  void _setupPlayer() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
      notifyListeners();
    });

    _audioPlayer.onDurationChanged.listen((newDuration) {
      _duration = newDuration;
      notifyListeners();
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      _position = newPosition;
      notifyListeners();
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      _isPlaying = false;
      _position = Duration.zero;
      notifyListeners();
    });
  }

  Future<void> play(ContentModel content) async {
    if (content.audioUrl == null) {
      _error = 'No audio available';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    _currentContent = content;
    notifyListeners();

    try {
      // Stop any currently playing audio
      await _audioPlayer.stop();
      
      // Play the new audio
      await _audioPlayer.setSourceUrl(content.audioUrl!);
      await _audioPlayer.resume();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to play audio';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> resume() async {
    await _audioPlayer.resume();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    _currentContent = null;
    _position = Duration.zero;
    _duration = Duration.zero;
    notifyListeners();
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  void skipForward({int seconds = 15}) {
    final newPosition = _position + Duration(seconds: seconds);
    if (newPosition < _duration) {
      seek(newPosition);
    }
  }

  void skipBackward({int seconds = 15}) {
    final newPosition = _position - Duration(seconds: seconds);
    if (newPosition > Duration.zero) {
      seek(newPosition);
    } else {
      seek(Duration.zero);
    }
  }

  void setSleepTimer(Duration duration) {
    _sleepTimer = duration;
    _timerEndTime = DateTime.now().add(duration);
    
    Future.delayed(duration, () {
      if (_timerEndTime != null && 
          DateTime.now().isAfter(_timerEndTime!.subtract(const Duration(seconds: 1)))) {
        stop();
        _sleepTimer = null;
        _timerEndTime = null;
        notifyListeners();
      }
    });
    
    notifyListeners();
  }

  void cancelSleepTimer() {
    _sleepTimer = null;
    _timerEndTime = null;
    notifyListeners();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}


