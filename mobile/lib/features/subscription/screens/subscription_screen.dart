import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';

class SubscriptionScreen extends ConsumerStatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  ConsumerState<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  int _selectedPlan = 1; // Default to Premium

  final List<SubscriptionPlan> _plans = [
    SubscriptionPlan(
      id: 0,
      name: 'Базовый',
      price: '249 ₽',
      period: 'месяц',
      description: 'Для знакомства',
      features: [
        '50+ медитаций',
        'Базовые дыхательные техники',
        'Трекер настроения',
        '5 сообщений AI в день',
      ],
      isPopular: false,
    ),
    SubscriptionPlan(
      id: 1,
      name: 'Премиум',
      price: '449 ₽',
      period: 'месяц',
      description: 'Полный доступ',
      features: [
        'Всё из Базового',
        '200+ практик и курсов',
        'Безлимитный AI-собеседник',
        'CBT-упражнения',
        'Офлайн-доступ',
        'Приоритетная поддержка',
      ],
      isPopular: true,
    ),
    SubscriptionPlan(
      id: 2,
      name: 'Годовой',
      price: '2 990 ₽',
      period: 'год',
      description: 'Экономия 60%',
      features: [
        'Всё из Премиум',
        '12 месяцев по цене 6',
        'Эксклюзивные курсы',
        'Ранний доступ к новинкам',
      ],
      isPopular: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // App Bar
          SliverAppBar(
            backgroundColor: Colors.transparent,
            expandedHeight: 200,
            floating: false,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded, color: AppColors.textPrimary),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                        decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.3),
                      AppColors.background,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          width: 60,
                          height: 60,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                          child: const Icon(Icons.eco_rounded, color: Colors.white, size: 32),
                        ),
                        const SizedBox(height: 16),
                      const Text(
                          'Раскройте весь потенциал',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                          '7 дней бесплатно, затем подписка',
                        style: TextStyle(
                            fontSize: 14,
                          color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Plans
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Disclaimer
                      Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 20),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Это инструмент самопомощи, а не замена профессиональной помощи',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                            ),
                          ],
                        ),
                      ),

                // Plan cards
                ...List.generate(_plans.length, (index) {
                  return _buildPlanCard(_plans[index], index);
                }),

                      const SizedBox(height: 24),

                // CTA Button
                GestureDetector(
                  onTap: () => _handleSubscribe(),
                  child: Container(
                        width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Начать бесплатный период',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                ),

                      const SizedBox(height: 16),

                // Terms
                const Center(
                  child: Text(
                    'Отмена в любой момент • Возврат в течение 14 дней',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 32),

                // Features comparison
                _buildFeaturesSection(),

                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(SubscriptionPlan plan, int index) {
    final isSelected = _selectedPlan == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPlan = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.2),
                    AppColors.secondary.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.primary.withOpacity(0.1),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          plan.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (plan.isPopular) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Популярный',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      plan.description,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                    Text(
                      plan.price,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? AppColors.primary : AppColors.textPrimary,
                      ),
                    ),
                      Text(
                      '/ ${plan.period}',
                      style: const TextStyle(
                        fontSize: 12,
                          color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (isSelected) ...[
                      const SizedBox(height: 16),
              const Divider(color: Color(0xFF1A3324)),
              const SizedBox(height: 12),
              ...plan.features.map((feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: AppColors.primary,
                            size: 14,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          feature,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
          'Что вы получите',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
        const SizedBox(height: 16),
        _buildFeatureItem(
          icon: Icons.self_improvement_rounded,
          title: '200+ практик осознанности',
          description: 'Медитации, визуализации и техники расслабления',
        ),
        _buildFeatureItem(
          icon: Icons.chat_bubble_rounded,
          title: 'AI-собеседник 24/7',
          description: 'Безопасное пространство для рефлексии',
        ),
        _buildFeatureItem(
          icon: Icons.psychology_rounded,
          title: 'CBT-упражнения',
          description: 'Когнитивно-поведенческие техники самопомощи',
        ),
        _buildFeatureItem(
          icon: Icons.analytics_rounded,
          title: 'Трекер настроения',
          description: 'Отслеживайте эмоции и находите паттерны',
        ),
        _buildFeatureItem(
          icon: Icons.cloud_off_rounded,
          title: 'Офлайн-доступ',
          description: 'Практикуйте где угодно без интернета',
        ),
      ],
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleSubscribe() {
    final selectedPlan = _plans[_selectedPlan];
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Выбран план: ${selectedPlan.name}'),
        backgroundColor: AppColors.surface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class SubscriptionPlan {
  final int id;
  final String name;
  final String price;
  final String period;
  final String description;
  final List<String> features;
  final bool isPopular;

  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.period,
    required this.description,
    required this.features,
    required this.isPopular,
  });
}
