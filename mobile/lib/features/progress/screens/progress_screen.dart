import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.darkGradient),
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('Твой прогресс 📊', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                ),
              ),
              // Stats cards
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(child: _StatCard(icon: '🔥', value: '7', label: 'Дней подряд', color: const Color(0xFFF59E0B))),
                      const SizedBox(width: 12),
                      Expanded(child: _StatCard(icon: '⏱️', value: '124', label: 'Минут', color: AppColors.primary)),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(child: _StatCard(icon: '🎯', value: '18', label: 'Сессий', color: const Color(0xFF10B981))),
                      const SizedBox(width: 12),
                      Expanded(child: _StatCard(icon: '⭐', value: '4', label: 'Достижения', color: const Color(0xFF3B82F6))),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              // Weekly goal
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Цель на неделю', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                          Text('5/7 дней', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primary)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(value: 5/7, minHeight: 12, backgroundColor: AppColors.card, valueColor: const AlwaysStoppedAnimation(AppColors.primary)),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(7, (i) {
                          final isCompleted = i < 5;
                          final isToday = i == 5;
                          return Container(
                            width: 36, height: 36,
                            decoration: BoxDecoration(
                              color: isCompleted ? AppColors.primary : (isToday ? AppColors.primary.withOpacity(0.3) : AppColors.card),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: isCompleted 
                                ? const Icon(Icons.check, color: Colors.white, size: 18)
                                : Text(['Пн','Вт','Ср','Чт','Пт','Сб','Вс'][i], style: TextStyle(fontSize: 10, color: isToday ? AppColors.primary : AppColors.textMuted)),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              // Achievements
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Достижения', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 12, crossAxisSpacing: 12),
                  delegate: SliverChildListDelegate([
                    _AchievementBadge(icon: '🎯', title: 'Первый шаг', unlocked: true),
                    _AchievementBadge(icon: '🔥', title: '7 дней', unlocked: true),
                    _AchievementBadge(icon: '⭐', title: '10 сессий', unlocked: true),
                    _AchievementBadge(icon: '⏰', title: '1 час', unlocked: true),
                    _AchievementBadge(icon: '🏆', title: '30 дней', unlocked: false),
                    _AchievementBadge(icon: '💎', title: '50 сессий', unlocked: false),
                    _AchievementBadge(icon: '💯', title: '100 сессий', unlocked: false),
                    _AchievementBadge(icon: '🧘', title: '5 часов', unlocked: false),
                  ]),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String icon;
  final String value;
  final String label;
  final Color color;
  const _StatCard({required this.icon, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withOpacity(0.2))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: color)),
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}

class _AchievementBadge extends StatelessWidget {
  final String icon;
  final String title;
  final bool unlocked;
  const _AchievementBadge({required this.icon, required this.title, required this.unlocked});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: unlocked ? 1 : 0.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: unlocked ? AppColors.primary.withOpacity(0.2) : AppColors.surface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(child: Text(icon, style: const TextStyle(fontSize: 24))),
          ),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 9, color: AppColors.textMuted), textAlign: TextAlign.center, maxLines: 1),
        ],
      ),
    );
  }
}
