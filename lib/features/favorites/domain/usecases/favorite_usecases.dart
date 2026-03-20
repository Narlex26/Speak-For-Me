import 'package:shared_preferences/shared_preferences.dart';
import '../../data/repositories/favorites_repository.dart';
import '../entities/favorite_tts.dart';

class GetFavoritesUseCase {
  final FavoritesRepository repository;

  GetFavoritesUseCase(SharedPreferences prefs)
    : repository = FavoritesRepository(prefs);

  Future<List<FavoriteTTS>> call() async {
    final models = await repository.getFavorites();
    return models
        .map(
          (m) => FavoriteTTS(
            id: m.id,
            text: m.text,
            profileType: m.profileType,
            createdAt: m.createdAt,
          ),
        )
        .toList();
  }
}

class AddFavoriteUseCase {
  final FavoritesRepository repository;

  AddFavoriteUseCase(SharedPreferences prefs)
    : repository = FavoritesRepository(prefs);

  Future<void> call({
    required String id,
    required String text,
    required String profileType,
  }) {
    return repository.addFavorite(id: id, text: text, profileType: profileType);
  }
}

class RemoveFavoriteUseCase {
  final FavoritesRepository repository;

  RemoveFavoriteUseCase(SharedPreferences prefs)
    : repository = FavoritesRepository(prefs);

  Future<void> call(String id) {
    return repository.removeFavorite(id);
  }
}

class IsFavoriteUseCase {
  final FavoritesRepository repository;

  IsFavoriteUseCase(SharedPreferences prefs)
    : repository = FavoritesRepository(prefs);

  Future<bool> call(String id) {
    return repository.isFavorite(id);
  }
}

class GetFavoritesByProfileUseCase {
  final FavoritesRepository repository;

  GetFavoritesByProfileUseCase(SharedPreferences prefs)
    : repository = FavoritesRepository(prefs);

  Future<List<FavoriteTTS>> call(String profileType) async {
    final models = await repository.getFavoritesByProfile(profileType);
    return models
        .map(
          (m) => FavoriteTTS(
            id: m.id,
            text: m.text,
            profileType: m.profileType,
            createdAt: m.createdAt,
          ),
        )
        .toList();
  }
}
