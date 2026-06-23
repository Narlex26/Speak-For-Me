import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../domain/entities/favorite_tts.dart';
import 'favorite_card.dart';

class FavoritesBody extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;
  final List<FavoriteTTS> favorites;
  final VoidCallback onRetry;
  final VoidCallback onGoBack;
  final void Function(String) onDelete;
  final void Function(String) onReListen;

  const FavoritesBody({
    super.key,
    required this.isLoading,
    required this.errorMessage,
    required this.favorites,
    required this.onRetry,
    required this.onGoBack,
    required this.onDelete,
    required this.onReListen,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FaIcon(FontAwesomeIcons.triangleExclamation, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    if (favorites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(FontAwesomeIcons.heart, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 24),
            Text(
              'Aucun favori',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ajoutez des textes à vos favoris\npour les retrouver ici',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: onGoBack,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Retour'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => onRetry(),
      color: Colors.deepPurple,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final favorite = favorites[index];
          return FavoriteCard(
            favorite: favorite,
            onReListen: () => onReListen(favorite.text),
            onDelete: () => onDelete(favorite.id),
          );
        },
      ),
    );
  }
}
