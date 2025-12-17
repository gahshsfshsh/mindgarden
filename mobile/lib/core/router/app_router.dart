import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/meditation/screens/meditation_screen.dart';
import '../../features/yoga/screens/yoga_screen.dart';
import '../../features/sleep/screens/sleep_screen.dart';
import '../../features/progress/screens/progress_screen.dart';
import '../../features/player/screens/player_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/subscription/screens/subscription_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/breathing/screens/breathing_screen.dart';
import '../../features/mood/screens/mood_tracker_screen.dart';
import '../../features/ai_chat/screens/ai_chat_screen.dart';
import '../../features/cbt/screens/cbt_screen.dart';
import '../widgets/main_scaffold.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    // Onboarding
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    
    // Auth routes
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    
    // Main app with bottom navigation
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => MainScaffold(child: child),
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomeScreen(),
          ),
        ),
        GoRoute(
          path: '/meditation',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: MeditationScreen(),
          ),
        ),
        GoRoute(
          path: '/yoga',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: YogaScreen(),
          ),
        ),
        GoRoute(
          path: '/sleep',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SleepScreen(),
          ),
        ),
        GoRoute(
          path: '/progress',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ProgressScreen(),
          ),
        ),
      ],
    ),
    
    // Full screen routes
    GoRoute(
      path: '/player/:id',
      builder: (context, state) => PlayerScreen(
        contentId: int.tryParse(state.pathParameters['id'] ?? '0') ?? 0,
      ),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/subscription',
      builder: (context, state) => const SubscriptionScreen(),
    ),
    GoRoute(
      path: '/breathing',
      builder: (context, state) => const BreathingScreen(),
    ),
    GoRoute(
      path: '/mood',
      builder: (context, state) => const MoodTrackerScreen(),
    ),
    // New Mental Health Routes
    GoRoute(
      path: '/ai-chat',
      builder: (context, state) => const AIChatScreen(),
    ),
    GoRoute(
      path: '/cbt',
      builder: (context, state) => const CBTScreen(),
    ),
  ],
);
