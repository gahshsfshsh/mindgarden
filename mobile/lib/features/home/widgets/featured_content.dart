import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class FeaturedContent extends StatelessWidget {
  const FeaturedContent({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      _FeaturedItem(
        title: 'Утреннее пробуждение',
        subtitle: '10 мин • Анна С.',
        type: 'meditation',
        icon: '🧘',
        gradient: const [Color(0xFF8B5CF6), Color(0xFFA855F7)],
      ),
      _FeaturedItem(
        title: 'Виньяса для энергии',
        subtitle: '25 мин • Катерина Л.',
        type: 'yoga',
        icon: '🧘‍♀️',
        gradient: const [Color(0xFF10B981), Color(0xFF34D399)],
      ),
      _FeaturedItem(
        title: 'Глубокий сон',
        subtitle: '30 мин • Мария П.',
        type: 'sleep',
        icon: '🌙',
        gradient: const [Color(0xFF3B82F6), Color(0xFF60A5FA)],
      ),
    ];

    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        physics: const BouncingScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            // Navigate to content detail or player
            context.push('/player/1');
          },
          child: items[index],
        ),
      ),
    );
  }
}

class _FeaturedItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String type;
  final String icon;
  final List<Color> gradient;

  const _FeaturedItem({
    required this.title,
    required this.subtitle,
    required this.type,
    required this.icon,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                icon,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: gradient[0],
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Начать',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


