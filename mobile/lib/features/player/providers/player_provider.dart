import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
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
    _audioPlayer.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      notifyListeners();
    });

    _audioPlayer.durationStream.listen((newDuration) {
      _duration = newDuration ?? Duration.zero;
      notifyListeners();
    });

    _audioPlayer.positionStream.listen((newPosition) {
      _position = newPosition;
      notifyListeners();
    });

    _audioPlayer.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        _isPlaying = false;
        _position = Duration.zero;
        notifyListeners();
      }
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
      await _audioPlayer.setUrl(content.audioUrl!);
      await _audioPlayer.play();
      
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
    await _audioPlayer.play();
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
