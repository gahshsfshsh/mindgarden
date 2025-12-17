import 'package:flutter/material.dart';
import 'dart:math';
import '../../../core/theme/app_theme.dart';

class DailyQuote extends StatelessWidget {
  const DailyQuote({super.key});

  @override
  Widget build(BuildContext context) {
    final quotes = [
      QuoteData(
        text: 'Забота о себе — это не эгоизм. Вы не можете наполнить из пустого стакана.',
        author: 'Элеонора Браун',
      ),
      QuoteData(
        text: 'Ваши мысли — это не факты. Это просто мысли.',
        author: 'Принцип CBT',
      ),
      QuoteData(
        text: 'Каждый день — это новая возможность позаботиться о своём внутреннем мире.',
        author: 'MindGarden',
      ),
      QuoteData(
        text: 'Дыхание — это мост между телом и разумом.',
        author: 'Тич Нат Хан',
      ),
      QuoteData(
        text: 'Самый важный разговор — это разговор с самим собой.',
        author: 'Народная мудрость',
      ),
      QuoteData(
        text: 'Осознанность — это когда вы полностью присутствуете в настоящем моменте.',
        author: 'Джон Кабат-Зинн',
      ),
    ];

    final random = Random(DateTime.now().day);
    final quote = quotes[random.nextInt(quotes.length)];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.format_quote_rounded,
                color: AppColors.primary.withOpacity(0.5),
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Мысль дня',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary.withOpacity(0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            quote.text,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: AppColors.textPrimary,
              height: 1.5,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '— ${quote.author}',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class QuoteData {
  final String text;
  final String author;

  QuoteData({required this.text, required this.author});
}
