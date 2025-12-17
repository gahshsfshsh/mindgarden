import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Animated gradient background like Calm/Headspace but better
class AnimatedGradientBackground extends StatefulWidget {
  final Widget child;
  final List<Color>? colors;
  final Duration duration;

  const AnimatedGradientBackground({
    super.key,
    required this.child,
    this.colors,
    this.duration = const Duration(seconds: 10),
  });

  @override
  State<AnimatedGradientBackground> createState() => _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final List<Color> _defaultColors = const [
    Color(0xFF1a1a2e),
    Color(0xFF16213e),
    Color(0xFF0f3460),
    Color(0xFF1a1a2e),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.colors ?? _defaultColors;
    
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(
                math.cos(_animation.value * 2 * math.pi),
                math.sin(_animation.value * 2 * math.pi),
              ),
              end: Alignment(
                -math.cos(_animation.value * 2 * math.pi),
                -math.sin(_animation.value * 2 * math.pi),
              ),
              colors: colors,
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}

/// Floating orb animation
class FloatingOrb extends StatefulWidget {
  final double size;
  final Color color;
  final Duration duration;

  const FloatingOrb({
    super.key,
    this.size = 200,
    this.color = const Color(0xFFa855f7),
    this.duration = const Duration(seconds: 8),
  });

  @override
  State<FloatingOrb> createState() => _FloatingOrbState();
}

class _FloatingOrbState extends State<FloatingOrb>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            math.sin(_controller.value * 2 * math.pi) * 30,
            math.cos(_controller.value * 2 * math.pi) * 20,
          ),
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  widget.color.withOpacity(0.4),
                  widget.color.withOpacity(0.0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Breathing circle animation - unique feature!
class BreathingCircle extends StatefulWidget {
  final double size;
  final Color color;
  final int breathsPerMinute;
  final bool showGuide;

  const BreathingCircle({
    super.key,
    this.size = 200,
    this.color = const Color(0xFFa855f7),
    this.breathsPerMinute = 6,
    this.showGuide = true,
  });

  @override
  State<BreathingCircle> createState() => _BreathingCircleState();
}

class _BreathingCircleState extends State<BreathingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  String _phase = 'Вдох';

  @override
  void initState() {
    super.initState();
    final breathDuration = Duration(
      milliseconds: (60000 / widget.breathsPerMinute).round(),
    );
    _controller = AnimationController(
      vsync: this,
      duration: breathDuration,
    )..repeat();

    _controller.addListener(() {
      final newPhase = _controller.value < 0.5 ? 'Вдох' : 'Выдох';
      if (newPhase != _phase) {
        setState(() => _phase = newPhase);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Smooth breathing curve
        final breathValue = _controller.value < 0.5
            ? Curves.easeInOut.transform(_controller.value * 2)
            : Curves.easeInOut.transform(2 - _controller.value * 2);
        
        final scale = 0.6 + (breathValue * 0.4);
        
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.showGuide)
              Text(
                _phase,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                  color: widget.color,
                  letterSpacing: 8,
                ),
              ),
            if (widget.showGuide) const SizedBox(height: 32),
            Container(
              width: widget.size,
              height: widget.size,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer glow
                  Transform.scale(
                    scale: scale * 1.2,
                    child: Container(
                      width: widget.size,
                      height: widget.size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            widget.color.withOpacity(0.1),
                            widget.color.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Main circle
                  Transform.scale(
                    scale: scale,
                    child: Container(
                      width: widget.size * 0.8,
                      height: widget.size * 0.8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            widget.color.withOpacity(0.6),
                            widget.color.withOpacity(0.3),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: widget.color.withOpacity(0.3),
                            blurRadius: 30,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Inner circle
                  Transform.scale(
                    scale: scale,
                    child: Container(
                      width: widget.size * 0.3,
                      height: widget.size * 0.3,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Pulse animation for buttons
class PulseAnimation extends StatefulWidget {
  final Widget child;
  final bool enabled;

  const PulseAnimation({
    super.key,
    required this.child,
    this.enabled = true,
  });

  @override
  State<PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    if (widget.enabled) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(PulseAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled && !oldWidget.enabled) {
      _controller.repeat(reverse: true);
    } else if (!widget.enabled && oldWidget.enabled) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (_controller.value * 0.05),
          child: widget.child,
        );
      },
    );
  }
}


