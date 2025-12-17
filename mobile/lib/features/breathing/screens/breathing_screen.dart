import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isRunning = false;
  String _phase = 'Начать';
  int _cycles = 0;

  final _technique = {'inhale': 4, 'hold1': 7, 'exhale': 8, 'hold2': 0}; // 4-7-8

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 4));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startBreathing() async {
    setState(() => _isRunning = true);
    
    while (_isRunning && _cycles < 4) {
      // Inhale
      setState(() => _phase = 'Вдох');
      _controller.duration = Duration(seconds: _technique['inhale']!);
      await _controller.forward(from: 0);
      if (!_isRunning) break;

      // Hold
      if (_technique['hold1']! > 0) {
        setState(() => _phase = 'Задержка');
        await Future.delayed(Duration(seconds: _technique['hold1']!));
        if (!_isRunning) break;
      }

      // Exhale
      setState(() => _phase = 'Выдох');
      _controller.duration = Duration(seconds: _technique['exhale']!);
      await _controller.reverse(from: 1);
      if (!_isRunning) break;

      setState(() => _cycles++);
    }

    if (_isRunning) {
      setState(() {
        _isRunning = false;
        _phase = 'Готово! 🎉';
      });
    }
  }

  void _stop() {
    setState(() {
      _isRunning = false;
      _phase = 'Начать';
      _cycles = 0;
    });
    _controller.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [const Color(0xFFF59E0B).withOpacity(0.2), AppColors.background], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary)),
                    ),
                    const Spacer(),
                    const Text('Дыхание 4-7-8', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    const Spacer(),
                    const SizedBox(width: 40),
                  ],
                ),
              ),
              const Spacer(),
              // Animated circle
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final scale = 0.6 + (_controller.value * 0.4);
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 200, height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(colors: [const Color(0xFFF59E0B), const Color(0xFFEF4444)]),
                        boxShadow: [BoxShadow(color: const Color(0xFFF59E0B).withOpacity(0.4), blurRadius: 40, spreadRadius: 10)],
                      ),
                      child: Center(child: Text('🌬️', style: const TextStyle(fontSize: 60))),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
              Text(_phase, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              Text('Цикл ${_cycles + 1}/4', style: const TextStyle(fontSize: 16, color: AppColors.textSecondary)),
              const Spacer(),
              // Controls
              Padding(
                padding: const EdgeInsets.all(32),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isRunning ? _stop : _startBreathing,
                    style: ElevatedButton.styleFrom(backgroundColor: _isRunning ? AppColors.error : const Color(0xFFF59E0B)),
                    child: Text(_isRunning ? 'Остановить' : 'Начать'),
                  ),
                ),
              ),
              // Info
              Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _InfoItem(value: '4', label: 'Вдох'),
                    _InfoItem(value: '7', label: 'Задержка'),
                    _InfoItem(value: '8', label: 'Выдох'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String value;
  final String label;
  const _InfoItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFFF59E0B))),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
      ],
    );
  }
}
