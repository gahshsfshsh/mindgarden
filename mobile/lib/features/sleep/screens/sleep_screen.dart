import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class SleepScreen extends StatelessWidget {
  const SleepScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFF1a1a2e), const Color(0xFF0a0a0f)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
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
                      Text('Сон 🌙', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      SizedBox(height: 8),
                      Text('Засыпай быстро и крепко', style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ),
              // Featured
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [const Color(0xFF3B82F6), const Color(0xFF8B5CF6)]),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('🌟 Рекомендуем', style: TextStyle(fontSize: 12, color: Colors.white70)),
                      const SizedBox(height: 8),
                      const Text('Глубокий сон', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
                      const SizedBox(height: 4),
                      const Text('30 мин • Медитация для качественного сна', style: TextStyle(fontSize: 13, color: Colors.white70)),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => context.push('/player/1'),
                        icon: const Icon(Icons.play_arrow_rounded),
                        label: const Text('Начать'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF3B82F6)),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              // Sounds
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Звуки природы', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      _SoundCard(icon: '🌧️', title: 'Дождь', onTap: () => context.push('/player/10')),
                      _SoundCard(icon: '🌊', title: 'Океан', onTap: () => context.push('/player/11')),
                      _SoundCard(icon: '🌲', title: 'Лес', onTap: () => context.push('/player/12')),
                      _SoundCard(icon: '⛈️', title: 'Гроза', onTap: () => context.push('/player/13')),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              // Stories
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Истории для сна', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _StoryCard(title: 'Путешествие в горы', duration: '35 мин', onTap: () => context.push('/player/20')),
                    _StoryCard(title: 'Тихая гавань', duration: '40 мин', onTap: () => context.push('/player/21')),
                    _StoryCard(title: 'Звёздная ночь', duration: '30 мин', onTap: () => context.push('/player/22')),
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

class _SoundCard extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onTap;
  const _SoundCard({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _StoryCard extends StatelessWidget {
  final String title;
  final String duration;
  final VoidCallback onTap;
  const _StoryCard({required this.title, required this.duration, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(color: const Color(0xFF3B82F6).withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
              child: const Center(child: Text('📖', style: TextStyle(fontSize: 24))),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  Text(duration, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                ],
              ),
            ),
            const Icon(Icons.play_circle_fill_rounded, color: Color(0xFF3B82F6), size: 40),
          ],
        ),
      ),
    );
  }
}
