import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      icon: Icons.eco_rounded,
      title: 'Добро пожаловать\nв MindGarden',
      subtitle: 'Ваш личный сад для души',
      description: 'Практики осознанности, дыхательные техники и поддержка для вашего ментального благополучия',
      color: AppColors.primary,
    ),
    OnboardingPage(
      icon: Icons.self_improvement_rounded,
      title: 'Медитации\nи практики',
      subtitle: '200+ аудио-сессий',
      description: 'От 3 до 30 минут. Для расслабления, концентрации и эмоционального баланса',
      color: AppColors.secondary,
    ),
    OnboardingPage(
      icon: Icons.psychology_rounded,
      title: 'CBT-упражнения',
      subtitle: 'Научно обоснованные техники',
      description: 'Когнитивно-поведенческие практики для работы с мыслями и эмоциями',
      color: const Color(0xFF14B8A6),
    ),
    OnboardingPage(
      icon: Icons.chat_bubble_rounded,
      title: 'AI-собеседник',
      subtitle: '24/7 поддержка',
      description: 'Безопасное пространство для разгрузки мыслей и рефлексии в любое время',
      color: const Color(0xFF8B5CF6),
    ),
    OnboardingPage(
      icon: Icons.track_changes_rounded,
      title: 'Трекер настроения',
      subtitle: 'Понимайте себя лучше',
      description: 'Отслеживайте эмоции, находите паттерны и наблюдайте за прогрессом',
      color: const Color(0xFFF59E0B),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
          child: Column(
            children: [
            // Skip button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => context.go('/'),
                    child: const Text(
                      'Пропустить',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Page content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                  itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),
            
            // Indicators and button
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Page indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                  decoration: BoxDecoration(
                          color: _currentPage == index
                              ? _pages[_currentPage].color
                              : AppColors.surface,
                    borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
              ),
              const SizedBox(height: 32),
                  
                  // Next button
                  GestureDetector(
                    onTap: _nextPage,
                    child: Container(
                  width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _pages[_currentPage].color,
                            _pages[_currentPage].color.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: _pages[_currentPage].color.withOpacity(0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _currentPage == _pages.length - 1 ? 'Начать' : 'Далее',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Disclaimer
                  if (_currentPage == 0) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'Это инструмент самопомощи, а не замена профессиональной помощи',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated icon container
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.8, end: 1.0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        page.color.withOpacity(0.2),
                        page.color.withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: page.color.withOpacity(0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: page.color.withOpacity(0.3),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Icon(
                    page.icon,
                    color: page.color,
                    size: 56,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 48),
          
          // Title
          Text(
            page.title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          
          // Subtitle
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: page.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              page.subtitle,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: page.color,
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          // Description
          Text(
            page.description,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class OnboardingPage {
  final IconData icon;
  final String title;
  final String subtitle;
  final String description;
  final Color color;

  OnboardingPage({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.color,
  });
}
