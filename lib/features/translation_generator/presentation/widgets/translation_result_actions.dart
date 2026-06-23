import 'package:flutter/material.dart';

class TranslationResultActions extends StatelessWidget {
  final Color primaryColor;
  final bool isFavorited;
  final VoidCallback onReset;
  final VoidCallback onToggleFavorite;
  final VoidCallback onSpeak;
  final VoidCallback onShare;

  const TranslationResultActions({
    super.key,
    required this.primaryColor,
    required this.isFavorited,
    required this.onReset,
    required this.onToggleFavorite,
    required this.onSpeak,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _IconActionButton(
                icon: isFavorited ? Icons.favorite : Icons.favorite_border,
                iconColor: isFavorited ? Colors.white : Colors.redAccent,
                backgroundColor: isFavorited ? Colors.redAccent : Colors.white,
                onPressed: onToggleFavorite,
              ),
              const SizedBox(width: 12),
              _IconActionButton(
                icon: Icons.volume_up_rounded,
                iconColor: primaryColor,
                backgroundColor: Colors.white,
                onPressed: onSpeak,
              ),
              const SizedBox(width: 12),
              _IconActionButton(
                icon: Icons.share_rounded,
                iconColor: primaryColor,
                backgroundColor: Colors.white,
                onPressed: onShare,
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 220,
            child: ElevatedButton.icon(
              onPressed: onReset,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Nouvelle traduction', overflow: TextOverflow.ellipsis),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                shadowColor: primaryColor.withValues(alpha: 0.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconActionButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final VoidCallback onPressed;

  const _IconActionButton({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: iconColor),
        padding: const EdgeInsets.all(16),
      ),
    );
  }
}
