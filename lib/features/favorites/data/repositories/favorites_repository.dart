import 'package:shared_preferences/shared_preferences.dart';
import '../datasources/favorites_local_data_source.dart';
import '../models/favorite_tts_model.dart';

class FavoritesRepository {
  final SharedPreferences prefs;
  late FavoritesLocalDataSource _localDataSource;

  FavoritesRepository(this.prefs) {
    _localDataSource = FavoritesLocalDataSource(prefs);
  }

  /// Get all favorites
  Future<List<FavoriteTTSModel>> getFavorites() {
    return _localDataSource.getFavorites();
  }

  /// Add a favorite
  Future<void> addFavorite({
    required String id,
    required String text,
    required String profileType,
  }) {
    final favorite = FavoriteTTSModel(
      id: id,
      text: text,
      profileType: profileType,
      createdAt: DateTime.now(),
    );
    return _localDataSource.addFavorite(favorite);
  }

  /// Remove a favorite
  Future<void> removeFavorite(String id) {
    return _localDataSource.removeFavorite(id);
  }

  /// Check if favorited
  Future<bool> isFavorite(String id) {
    return _localDataSource.isFavorite(id);
  }

  /// Get favorites by profile
  Future<List<FavoriteTTSModel>> getFavoritesByProfile(String profileType) {
    return _localDataSource.getFavoritesByProfile(profileType);
  }

  /// Clear all favorites
  Future<void> clearAll() {
    return _localDataSource.clearAll();
  }
}
