import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/models/content_model.dart';

class ContentCard extends StatelessWidget {
  final ContentModel content;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final bool showCategory;

  const ContentCard({
    super.key,
    required this.content,
    this.onTap,
    this.width,
    this.height,
    this.showCategory = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.surface,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Image
            Positioned.fill(
              child: content.thumbnailUrl != null
                  ? CachedNetworkImage(
                      imageUrl: content.thumbnailUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppColors.surfaceLight,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.surfaceLight,
                        child: const Icon(Icons.image, color: AppColors.textMuted),
                      ),
                    )
                  : Container(
                      color: AppColors.surfaceLight,
                      child: const Icon(Icons.image, color: AppColors.textMuted),
                    ),
            ),

            // Gradient overlay
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                    stops: const [0.4, 1.0],
                  ),
                ),
              ),
            ),

            // Premium badge
            if (content.isPremium)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: AppColors.gradientPurplePink,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock, color: Colors.white, size: 12),
                      SizedBox(width: 4),
                      Text(
                        'PRO',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Category badge
            if (showCategory && content.category != null)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    content.category!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

            // Content info
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    content.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (content.duration != null) ...[
                        const Icon(
                          Icons.timer_outlined,
                          color: AppColors.textMuted,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          content.duration!,
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                      if (content.level != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          content.levelDisplay,
                          style: const TextStyle(fontSize: 10),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Play button overlay
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// List tile variant
class ContentListTile extends StatelessWidget {
  final ContentModel content;
  final VoidCallback? onTap;

  const ContentListTile({
    super.key,
    required this.content,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 60,
          height: 60,
          child: content.thumbnailUrl != null
              ? CachedNetworkImage(
                  imageUrl: content.thumbnailUrl!,
                  fit: BoxFit.cover,
                )
              : Container(
                  color: AppColors.surfaceLight,
                  child: const Icon(Icons.image),
                ),
        ),
      ),
      title: Text(
        content.title,
        style: const TextStyle(fontWeight: FontWeight.w600),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Row(
        children: [
          if (content.duration != null) ...[
            const Icon(Icons.timer_outlined, size: 12, color: AppColors.textMuted),
            const SizedBox(width: 4),
            Text(content.duration!, style: const TextStyle(fontSize: 12)),
          ],
          if (content.category != null) ...[
            const SizedBox(width: 8),
            Text(
              content.category!,
              style: const TextStyle(fontSize: 12, color: AppColors.purple),
            ),
          ],
        ],
      ),
      trailing: content.isPremium
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                gradient: AppColors.gradientPurplePink,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'PRO',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : const Icon(Icons.play_circle_outline),
    );
  }
}


