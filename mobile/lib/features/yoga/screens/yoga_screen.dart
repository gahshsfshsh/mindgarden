import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class YogaScreen extends StatelessWidget {
  const YogaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final practices = [
      {'title': 'Утренняя виньяса', 'duration': '25 мин', 'level': 'Средний', 'icon': '🌅'},
      {'title': 'Хатха для начинающих', 'duration': '30 мин', 'level': 'Начинающий', 'icon': '🧘‍♀️'},
      {'title': 'Power Yoga', 'duration': '40 мин', 'level': 'Продвинутый', 'icon': '💪'},
      {'title': 'Йога для спины', 'duration': '25 мин', 'level': 'Начинающий', 'icon': '🦴'},
      {'title': 'Инь йога', 'duration': '45 мин', 'level': 'Любой', 'icon': '🌙'},
      {'title': 'Вечерняя растяжка', 'duration': '20 мин', 'level': 'Начинающий', 'icon': '🌸'},
    ];

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Йога 🧘‍♀️', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      SizedBox(height: 8),
                      Text('Гибкость тела и ума', style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = practices[index];
                      return _YogaCard(
                        title: item['title'] as String,
                        duration: item['duration'] as String,
                        level: item['level'] as String,
                        icon: item['icon'] as String,
                        onTap: () => context.push('/player/$index'),
                      );
                    },
                    childCount: practices.length,
                  ),
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

class _YogaCard extends StatelessWidget {
  final String title;
  final String duration;
  final String level;
  final String icon;
  final VoidCallback onTap;

  const _YogaCard({required this.title, required this.duration, required this.level, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [const Color(0xFF10B981).withOpacity(0.2), const Color(0xFF10B981).withOpacity(0.1)]),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF10B981).withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(icon, style: const TextStyle(fontSize: 32)),
            const Spacer(),
            Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary), maxLines: 2),
            const SizedBox(height: 4),
            Text('$duration • $level', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}
