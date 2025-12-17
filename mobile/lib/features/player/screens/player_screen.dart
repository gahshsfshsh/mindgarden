import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class PlayerScreen extends StatefulWidget {
  final int contentId;
  const PlayerScreen({super.key, required this.contentId});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> with SingleTickerProviderStateMixin {
  bool isPlaying = false;
  double progress = 0.3;
  late AnimationController _breathController;

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _breathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary.withOpacity(0.3), AppColors.background],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.keyboard_arrow_down, color: AppColors.textPrimary),
                      ),
                    ),
                    const Text('Сейчас играет', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.more_horiz, color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Animated circle
              AnimatedBuilder(
                animation: _breathController,
                builder: (context, child) {
                  final scale = 1.0 + (_breathController.value * 0.15);
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 220, height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.primaryGradient,
                        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 40, spreadRadius: 10)],
                      ),
                      child: const Center(child: Text('🧘', style: TextStyle(fontSize: 80))),
                    ),
                  );
                },
              ),
              const Spacer(),
              // Info
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    const Text('Утреннее пробуждение', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary), textAlign: TextAlign.center),
                    const SizedBox(height: 8),
                    const Text('Анна Светлова', style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
                    const SizedBox(height: 32),
                    // Progress bar
                    Column(
                      children: [
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 4,
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                          ),
                          child: Slider(
                            value: progress,
                            onChanged: (v) => setState(() => progress = v),
                            activeColor: AppColors.primary,
                            inactiveColor: AppColors.surface,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text('3:24', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                              Text('10:00', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.replay_10, size: 32, color: AppColors.textSecondary),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => isPlaying = !isPlaying),
                          child: Container(
                            width: 72, height: 72,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 20)],
                            ),
                            child: Icon(isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded, size: 40, color: Colors.white),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.forward_10, size: 32, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
