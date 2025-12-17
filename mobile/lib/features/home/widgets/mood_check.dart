import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class MoodCheck extends StatefulWidget {
  const MoodCheck({super.key});

  @override
  State<MoodCheck> createState() => _MoodCheckState();
}

class _MoodCheckState extends State<MoodCheck> {
  int? _selectedMood;

  final List<MoodOption> _moods = [
    MoodOption(emoji: '😔', label: 'Плохо', color: AppColors.moodTerrible),
    MoodOption(emoji: '😕', label: 'Так себе', color: AppColors.moodBad),
    MoodOption(emoji: '😐', label: 'Нормально', color: AppColors.moodNeutral),
    MoodOption(emoji: '🙂', label: 'Хорошо', color: AppColors.moodGood),
    MoodOption(emoji: '😊', label: 'Отлично', color: AppColors.moodGreat),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.15),
            AppColors.secondary.withOpacity(0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.emoji_emotions_outlined,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Как вы себя чувствуете?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Отслеживайте своё настроение',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_moods.length, (index) {
              final mood = _moods[index];
              final isSelected = _selectedMood == index;
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedMood = index;
                  });
                  _showMoodResponse(mood);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: isSelected ? 60 : 52,
                  height: isSelected ? 60 : 52,
                  decoration: BoxDecoration(
                    color: isSelected 
                      ? mood.color.withOpacity(0.3)
                      : AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected 
                        ? mood.color 
                        : AppColors.primary.withOpacity(0.1),
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected ? [
                      BoxShadow(
                        color: mood.color.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ] : null,
                  ),
                  child: Center(
                    child: Text(
                      mood.emoji,
                      style: TextStyle(
                        fontSize: isSelected ? 28 : 24,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          if (_selectedMood != null) ...[
            const SizedBox(height: 16),
            Center(
              child: Text(
                _moods[_selectedMood!].label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: _moods[_selectedMood!].color,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showMoodResponse(MoodOption mood) {
    String message;
    switch (mood.label) {
      case 'Плохо':
        message = 'Сожалею, что вы так себя чувствуете. Может, попробуем технику дыхания или поговорим с AI-собеседником?';
        break;
      case 'Так себе':
        message = 'Бывают такие дни. Короткая медитация может помочь улучшить настроение.';
        break;
      case 'Нормально':
        message = 'Стабильность — это тоже хорошо! Может, попробуем что-то новое сегодня?';
        break;
      case 'Хорошо':
        message = 'Отлично! Хорошее настроение — отличная основа для практики.';
        break;
      case 'Отлично':
        message = 'Замечательно! Запишите, что способствует такому настроению.';
        break;
      default:
        message = 'Спасибо, что поделились!';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.surface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

class MoodOption {
  final String emoji;
  final String label;
  final Color color;

  MoodOption({
    required this.emoji,
    required this.label,
    required this.color,
  });
}
