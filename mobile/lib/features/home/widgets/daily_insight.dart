import 'package:flutter/material.dart';
import 'dart:math';

import '../../../core/theme/app_theme.dart';

/// Daily insight widget - shows personalized wisdom/quotes
class DailyInsightCard extends StatefulWidget {
  const DailyInsightCard({super.key});

  @override
  State<DailyInsightCard> createState() => _DailyInsightCardState();
}

class _DailyInsightCardState extends State<DailyInsightCard> {
  late Insight _todayInsight;

  final List<Insight> _insights = [
    Insight(
      quote: 'Дыхание — это мост, который соединяет жизнь с сознанием',
      author: 'Тхить Нят Хань',
      emoji: '🌬️',
      gradient: [Color(0xFF667eea), Color(0xFF764ba2)],
    ),
    Insight(
      quote: 'Тишина — не пустота. Это наполненность покоем',
      author: 'Аджан Чах',
      emoji: '🧘',
      gradient: [Color(0xFFf093fb), Color(0xFFf5576c)],
    ),
    Insight(
      quote: 'Каждое утро мы рождаемся заново. То, что мы делаем сегодня — важнее всего',
      author: 'Будда',
      emoji: '🌅',
      gradient: [Color(0xFF4facfe), Color(0xFF00f2fe)],
    ),
    Insight(
      quote: 'Истинное путешествие — это путешествие внутрь',
      author: 'Рильке',
      emoji: '✨',
      gradient: [Color(0xFFfa709a), Color(0xFFfee140)],
    ),
    Insight(
      quote: 'Медитация — это не побег от жизни, а погружение в неё',
      author: 'Джон Кабат-Зинн',
      emoji: '🪷',
      gradient: [Color(0xFFa8edea), Color(0xFFfed6e3)],
    ),
    Insight(
      quote: 'Ум, освобождённый от беспокойства, подобен озеру без ряби',
      author: 'Лао Цзы',
      emoji: '🌊',
      gradient: [Color(0xFF5ee7df), Color(0xFFb490ca)],
    ),
    Insight(
      quote: 'Счастье — это навык. Его можно развить через практику',
      author: 'Далай-лама',
      emoji: '😊',
      gradient: [Color(0xFFffecd2), Color(0xFFfcb69f)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Select insight based on day of year for consistency
    final dayOfYear = DateTime.now().difference(
      DateTime(DateTime.now().year, 1, 1)
    ).inDays;
    _todayInsight = _insights[dayOfYear % _insights.length];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _todayInsight.gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _todayInsight.gradient.first.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -20,
            left: -20,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      _todayInsight.emoji,
                      style: const TextStyle(fontSize: 28),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Мысль дня',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  '"${_todayInsight.quote}"',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '— ${_todayInsight.author}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Insight {
  final String quote;
  final String author;
  final String emoji;
  final List<Color> gradient;

  const Insight({
    required this.quote,
    required this.author,
    required this.emoji,
    required this.gradient,
  });
}


