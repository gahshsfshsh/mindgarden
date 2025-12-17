import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

import '../theme/app_theme.dart';

/// Streak celebration dialog - shows when user hits milestone
class StreakCelebration extends StatefulWidget {
  final int streak;
  final VoidCallback onClose;

  const StreakCelebration({
    super.key,
    required this.streak,
    required this.onClose,
  });

  @override
  State<StreakCelebration> createState() => _StreakCelebrationState();
}

class _StreakCelebrationState extends State<StreakCelebration>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _confettiController;
  late Animation<double> _scaleAnimation;
  
  final List<_Confetti> _confetti = [];

  @override
  void initState() {
    super.initState();
    
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );
    
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    
    // Generate confetti
    final random = math.Random();
    for (int i = 0; i < 50; i++) {
      _confetti.add(_Confetti(
        x: random.nextDouble(),
        delay: random.nextDouble() * 0.5,
        speed: 0.3 + random.nextDouble() * 0.7,
        color: [
          AppColors.purple,
          AppColors.pink,
          AppColors.orange,
          Colors.yellow,
          Colors.green,
        ][random.nextInt(5)],
      ));
    }
    
    HapticFeedback.heavyImpact();
    _scaleController.forward();
    _confettiController.repeat();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  String _getStreakMessage() {
    if (widget.streak >= 30) return 'Вы настоящий мастер!';
    if (widget.streak >= 14) return 'Невероятно! Так держать!';
    if (widget.streak >= 7) return 'Целая неделя! Отлично!';
    if (widget.streak >= 3) return 'Хорошее начало!';
    return 'Продолжайте в том же духе!';
  }

  String _getStreakEmoji() {
    if (widget.streak >= 30) return '👑';
    if (widget.streak >= 14) return '🏆';
    if (widget.streak >= 7) return '🔥';
    if (widget.streak >= 3) return '⭐';
    return '✨';
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Backdrop
          GestureDetector(
            onTap: widget.onClose,
            child: Container(
              color: Colors.black.withOpacity(0.7),
            ),
          ),
          
          // Confetti
          AnimatedBuilder(
            animation: _confettiController,
            builder: (context, child) {
              return CustomPaint(
                painter: _ConfettiPainter(
                  confetti: _confetti,
                  progress: _confettiController.value,
                ),
              );
            },
          ),
          
          // Main content
          Center(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                margin: const EdgeInsets.all(32),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF667eea),
                      Color(0xFFf093fb),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.purple.withOpacity(0.5),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _getStreakEmoji(),
                      style: const TextStyle(fontSize: 72),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'СЕРИЯ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 8,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${widget.streak}',
                          style: const TextStyle(
                            fontSize: 80,
                            fontWeight: FontWeight.black,
                            color: Colors.white,
                            height: 1,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 12, left: 4),
                          child: Text(
                            'дней',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _getStreakMessage(),
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: widget.onClose,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.purple,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 48,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Продолжить',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Confetti {
  final double x;
  final double delay;
  final double speed;
  final Color color;

  _Confetti({
    required this.x,
    required this.delay,
    required this.speed,
    required this.color,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_Confetti> confetti;
  final double progress;

  _ConfettiPainter({
    required this.confetti,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final c in confetti) {
      final adjustedProgress = ((progress - c.delay) / (1 - c.delay)).clamp(0.0, 1.0);
      if (adjustedProgress <= 0) continue;

      final x = c.x * size.width;
      final y = adjustedProgress * size.height * c.speed;
      final opacity = (1 - adjustedProgress).clamp(0.0, 1.0);

      final paint = Paint()
        ..color = c.color.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(progress * math.pi * 4);
      canvas.drawRect(
        const Rect.fromLTWH(-4, -4, 8, 8),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) {
    return progress != oldDelegate.progress;
  }
}

/// Shows streak celebration dialog
void showStreakCelebration(BuildContext context, int streak) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Streak',
    pageBuilder: (context, anim1, anim2) {
      return StreakCelebration(
        streak: streak,
        onClose: () => Navigator.of(context).pop(),
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
    transitionBuilder: (context, anim1, anim2, child) {
      return FadeTransition(
        opacity: anim1,
        child: child,
      );
    },
  );
}


