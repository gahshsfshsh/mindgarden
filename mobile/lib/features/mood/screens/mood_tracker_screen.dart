import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_theme.dart';

/// Mood tracker - unique premium feature
class MoodTrackerScreen extends StatefulWidget {
  const MoodTrackerScreen({super.key});

  @override
  State<MoodTrackerScreen> createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen>
    with TickerProviderStateMixin {
  int? _selectedMood;
  final Set<String> _selectedFactors = {};
  final TextEditingController _noteController = TextEditingController();
  late AnimationController _scaleController;

  final List<MoodOption> _moods = [
    MoodOption(emoji: '😢', label: 'Грустно', color: const Color(0xFF6366f1), value: 1),
    MoodOption(emoji: '😔', label: 'Плохо', color: const Color(0xFF8b5cf6), value: 2),
    MoodOption(emoji: '😐', label: 'Нормально', color: const Color(0xFFa855f7), value: 3),
    MoodOption(emoji: '🙂', label: 'Хорошо', color: const Color(0xFFec4899), value: 4),
    MoodOption(emoji: '😊', label: 'Отлично', color: const Color(0xFFf97316), value: 5),
  ];

  final List<String> _factors = [
    '😴 Сон',
    '🏃 Спорт',
    '🧘 Медитация',
    '💼 Работа',
    '👨‍👩‍👧 Семья',
    '🎉 Отдых',
    '🍎 Питание',
    '☀️ Погода',
    '📱 Соцсети',
    '📚 Учёба',
  ];

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _selectMood(int value) {
    HapticFeedback.mediumImpact();
    setState(() => _selectedMood = value);
    _scaleController.forward().then((_) => _scaleController.reverse());
  }

  void _toggleFactor(String factor) {
    HapticFeedback.selectionClick();
    setState(() {
      if (_selectedFactors.contains(factor)) {
        _selectedFactors.remove(factor);
      } else {
        _selectedFactors.add(factor);
      }
    });
  }

  void _saveMood() {
    if (_selectedMood == null) return;

    // Save mood to storage/API
    // ...

    // Show success animation
    showDialog(
      context: context,
      builder: (context) => _SuccessDialog(
        mood: _moods[_selectedMood! - 1],
      ),
    ).then((_) => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    final selectedMoodOption = _selectedMood != null 
        ? _moods[_selectedMood! - 1] 
        : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background gradient based on selected mood
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  (selectedMoodOption?.color ?? AppColors.purple).withOpacity(0.2),
                  AppColors.background,
                ],
              ),
            ),
          ),

          SafeArea(
            child: CustomScrollView(
              slivers: [
                // App bar
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: const Text('Как вы себя чувствуете?'),
                  centerTitle: true,
                ),

                // Mood selector
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Date
                        Text(
                          _formatDate(DateTime.now()),
                          style: const TextStyle(
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Mood emojis
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: _moods.map((mood) {
                            final isSelected = _selectedMood == mood.value;
                            return GestureDetector(
                              onTap: () => _selectMood(mood.value),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? mood.color.withOpacity(0.2)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected
                                        ? mood.color
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    AnimatedScale(
                                      scale: isSelected ? 1.3 : 1.0,
                                      duration: const Duration(milliseconds: 200),
                                      child: Text(
                                        mood.emoji,
                                        style: const TextStyle(fontSize: 36),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      mood.label,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: isSelected
                                            ? mood.color
                                            : AppColors.textMuted,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        // Selected mood indicator
                        if (selectedMoodOption != null) ...[
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  selectedMoodOption.color,
                                  selectedMoodOption.color.withOpacity(0.7),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Вы чувствуете себя ${selectedMoodOption.label.toLowerCase()}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                // Factors section
                if (_selectedMood != null) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Что повлияло на настроение?',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Выберите один или несколько факторов',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _factors.map((factor) {
                              final isSelected = _selectedFactors.contains(factor);
                              return GestureDetector(
                                onTap: () => _toggleFactor(factor),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? selectedMoodOption!.color.withOpacity(0.2)
                                        : AppColors.surface,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isSelected
                                          ? selectedMoodOption!.color
                                          : AppColors.surfaceLight,
                                    ),
                                  ),
                                  child: Text(
                                    factor,
                                    style: TextStyle(
                                      color: isSelected
                                          ? selectedMoodOption!.color
                                          : AppColors.textSecondary,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Notes section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Заметка',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Опишите свои мысли (необязательно)',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _noteController,
                            maxLines: 4,
                            decoration: InputDecoration(
                              hintText: 'О чём вы думаете сегодня?',
                              hintStyle: const TextStyle(color: AppColors.textMuted),
                              filled: true,
                              fillColor: AppColors.surface,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Save button
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                      child: ElevatedButton(
                        onPressed: _saveMood,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedMoodOption?.color ?? AppColors.purple,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Сохранить',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
      'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

class MoodOption {
  final String emoji;
  final String label;
  final Color color;
  final int value;

  const MoodOption({
    required this.emoji,
    required this.label,
    required this.color,
    required this.value,
  });
}

class _SuccessDialog extends StatefulWidget {
  final MoodOption mood;

  const _SuccessDialog({required this.mood});

  @override
  State<_SuccessDialog> createState() => _SuccessDialogState();
}

class _SuccessDialogState extends State<_SuccessDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _controller.forward();

    // Auto close after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.mood.emoji,
                style: const TextStyle(fontSize: 64),
              ),
              const SizedBox(height: 16),
              const Text(
                'Записано!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Отслеживание настроения помогает\nлучше понять себя',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


