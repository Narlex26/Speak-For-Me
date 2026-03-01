import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoader extends StatelessWidget {
  final String message;
  final Color baseColor;
  final double progress;

  const ShimmerLoader({
    super.key,
    required this.message,
    required this.baseColor,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Shimmer container
        Shimmer.fromColors(
          baseColor: baseColor.withOpacity(0.3),
          highlightColor: baseColor.withOpacity(0.8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: baseColor,
                ),
                const SizedBox(width: 12),
                Text(
                  message,
                  style: TextStyle(
                    color: baseColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Progress bar
        Container(
          width: 250,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 250 * progress,
                height: 8,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      baseColor,
                      baseColor.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              // Shimmer overlay on progress bar
              Shimmer.fromColors(
                baseColor: Colors.transparent,
                highlightColor: Colors.white.withValues(alpha: 0.3),
                child: Container(
                  width: 250 * progress,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '${(progress * 100).toInt()}%',
          style: TextStyle(
            color: baseColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

