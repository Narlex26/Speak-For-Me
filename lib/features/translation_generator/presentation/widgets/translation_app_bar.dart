import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speak_for_me/features/specimen_selection/domain/entities/specimen.dart';

class TranslationAppBar extends StatelessWidget {
  final Profile profile;
  final bool isExpertMode;
  final VoidCallback onBack;
  final VoidCallback onAddPhrase;
  final VoidCallback onOpenFavorites;
  final VoidCallback onToggleExpertMode;

  const TranslationAppBar({
    super.key,
    required this.profile,
    required this.isExpertMode,
    required this.onBack,
    required this.onAddPhrase,
    required this.onOpenFavorites,
    required this.onToggleExpertMode,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: cs.shadow.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(Icons.arrow_back_ios_new_rounded, color: profile.primaryColor, size: 20),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Traducteur ${profile.name}',
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: cs.onSurface),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _AppBarButton(icon: Icons.add_rounded, color: profile.primaryColor, onTap: onAddPhrase),
          const SizedBox(width: 8),
          _AppBarButton(icon: Icons.favorite_border, color: Colors.redAccent, onTap: onOpenFavorites),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onToggleExpertMode,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isExpertMode ? cs.inverseSurface : cs.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: cs.outline.withValues(alpha: 0.3)),
              ),
              child: Icon(Icons.science, color: isExpertMode ? Colors.greenAccent : Colors.grey, size: 24),
            ),
          ),
        ],
      ),
    );
  }
}

class _AppBarButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _AppBarButton({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: cs.outline.withValues(alpha: 0.3)),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }
}
