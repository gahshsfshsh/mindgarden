import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class QuickActions extends StatelessWidget {
  final VoidCallback? onMeditationTap;
  final VoidCallback? onYogaTap;
  final VoidCallback? onSleepTap;
  final VoidCallback? onBreathingTap;

  const QuickActions({
    super.key,
    this.onMeditationTap,
    this.onYogaTap,
    this.onSleepTap,
    this.onBreathingTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _QuickActionCard(
            icon: Icons.self_improvement_rounded,
            label: 'Медитация',
            color: AppColors.primary,
            onTap: onMeditationTap,
          ),
          _QuickActionCard(
            icon: Icons.psychology_rounded,
            label: 'CBT',
            color: AppColors.secondary,
            onTap: onYogaTap,
          ),
          _QuickActionCard(
            icon: Icons.bedtime_rounded,
            label: 'Сон',
            color: const Color(0xFF6366F1),
            onTap: onSleepTap,
          ),
          _QuickActionCard(
            icon: Icons.air_rounded,
            label: 'Дыхание',
            color: const Color(0xFF14B8A6),
            onTap: onBreathingTap,
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.2),
              color.withOpacity(0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: color,
                size: 26,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
