import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';
import '../../features/player/providers/player_provider.dart';

/// Mini player widget that appears when audio is playing
/// Shows at the bottom of the screen, above the bottom navigation
class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerProvider>(
      builder: (context, player, _) {
        final content = player.currentContent;
        if (content == null) return const SizedBox.shrink();

        return GestureDetector(
          onTap: () => context.push('/player/${content.id}'),
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity != null && details.primaryVelocity! < -300) {
              context.push('/player/${content.id}');
            }
          },
          child: Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.surface,
                  AppColors.surface.withOpacity(0.95),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.purple.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 5),
                ),
              ],
              border: Border.all(color: AppColors.surfaceLight),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Progress bar
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: LinearProgressIndicator(
                    value: player.duration.inSeconds > 0
                        ? player.position.inSeconds / player.duration.inSeconds
                        : 0,
                    backgroundColor: AppColors.surfaceLight,
                    valueColor: const AlwaysStoppedAnimation(AppColors.purple),
                    minHeight: 3,
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      // Thumbnail
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: AppColors.gradientPurplePink,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: content.thumbnailUrl != null
                              ? Image.network(
                                  content.thumbnailUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.music_note,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(
                                  Icons.music_note,
                                  color: Colors.white,
                                ),
                        ),
                      ),
                      
                      const SizedBox(width: 12),
                      
                      // Title & Category
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              content.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              content.category ?? content.typeDisplay,
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Controls
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Play/Pause
                          _MiniPlayerButton(
                            icon: player.isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            onTap: () {
                              if (player.isPlaying) {
                                player.pause();
                              } else {
                                player.resume();
                              }
                            },
                            isPrimary: true,
                          ),
                          
                          const SizedBox(width: 8),
                          
                          // Close
                          _MiniPlayerButton(
                            icon: Icons.close_rounded,
                            onTap: () => player.stop(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MiniPlayerButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;

  const _MiniPlayerButton({
    required this.icon,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          gradient: isPrimary ? AppColors.gradientPurplePink : null,
          color: isPrimary ? null : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: isPrimary ? Colors.white : AppColors.textSecondary,
          size: 24,
        ),
      ),
    );
  }
}


