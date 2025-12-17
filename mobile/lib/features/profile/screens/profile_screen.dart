import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.darkGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary)),
                    ),
                    const Spacer(),
                    const Text('Профиль', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    const Spacer(),
                    const SizedBox(width: 40),
                  ],
                ),
                const SizedBox(height: 32),
                Container(
                  width: 100, height: 100,
                  decoration: BoxDecoration(gradient: AppColors.primaryGradient, shape: BoxShape.circle),
                  child: const Center(child: Text('🧘', style: TextStyle(fontSize: 50))),
                ),
                const SizedBox(height: 16),
                const Text('Практикующий', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                const Text('user@email.com', style: TextStyle(fontSize: 14, color: AppColors.textMuted)),
                const SizedBox(height: 24),
                // Premium card
                GestureDetector(
                  onTap: () => context.push('/subscription'),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        const Text('👑', style: TextStyle(fontSize: 32)),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Стать Premium', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                              Text('Доступ ко всему контенту', style: TextStyle(fontSize: 12, color: Colors.white70)),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Settings
                Container(
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      _SettingsTile(icon: Icons.notifications_outlined, title: 'Уведомления', onTap: () {}),
                      _SettingsTile(icon: Icons.download_outlined, title: 'Загрузки', onTap: () {}),
                      _SettingsTile(icon: Icons.language, title: 'Язык', trailing: 'Русский', onTap: () {}),
                      _SettingsTile(icon: Icons.help_outline, title: 'Помощь', onTap: () {}),
                      _SettingsTile(icon: Icons.info_outline, title: 'О приложении', onTap: () {}, isLast: true),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20)),
                  child: _SettingsTile(icon: Icons.logout, title: 'Выйти', color: AppColors.error, onTap: () => context.go('/login'), isLast: true),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailing;
  final Color? color;
  final VoidCallback onTap;
  final bool isLast;

  const _SettingsTile({required this.icon, required this.title, this.trailing, this.color, required this.onTap, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(border: isLast ? null : Border(bottom: BorderSide(color: AppColors.card))),
        child: Row(
          children: [
            Icon(icon, color: color ?? AppColors.textSecondary, size: 22),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: TextStyle(fontSize: 15, color: color ?? AppColors.textPrimary))),
            if (trailing != null) Text(trailing!, style: const TextStyle(fontSize: 13, color: AppColors.textMuted)),
            if (trailing == null) Icon(Icons.arrow_forward_ios, color: AppColors.textMuted, size: 14),
          ],
        ),
      ),
    );
  }
}
