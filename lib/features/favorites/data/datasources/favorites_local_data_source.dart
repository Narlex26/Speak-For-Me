import 'package:shared_preferences/shared_preferences.dart';
import '../models/favorite_tts_model.dart';

class FavoritesLocalDataSource {
  static const String _favoritesKey = 'favorites_tts_list';
  final SharedPreferences _prefs;

  FavoritesLocalDataSource(this._prefs);

  /// Get all favorites
  Future<List<FavoriteTTSModel>> getFavorites() async {
    final jsonList = _prefs.getStringList(_favoritesKey) ?? [];
    return jsonList
        .map((jsonString) => FavoriteTTSModel.fromJsonString(jsonString))
        .toList();
  }

  /// Add a favorite
  Future<void> addFavorite(FavoriteTTSModel favorite) async {
    final favorites = await getFavorites();

    // Check if already exists
    final exists = favorites.any((f) => f.id == favorite.id);
    if (exists) {
      throw Exception('Favorite already exists');
    }

    favorites.add(favorite);
    await _saveFavorites(favorites);
  }

  /// Remove a favorite by ID
  Future<void> removeFavorite(String id) async {
    final favorites = await getFavorites();
    favorites.removeWhere((f) => f.id == id);
    await _saveFavorites(favorites);
  }

  /// Check if a text is favorited
  Future<bool> isFavorite(String id) async {
    final favorites = await getFavorites();
    return favorites.any((f) => f.id == id);
  }

  /// Clear all favorites
  Future<void> clearAll() async {
    await _prefs.remove(_favoritesKey);
  }

  /// Get favorites by profile type
  Future<List<FavoriteTTSModel>> getFavoritesByProfile(
    String profileType,
  ) async {
    final favorites = await getFavorites();
    return favorites.where((f) => f.profileType == profileType).toList();
  }

  /// Save favorites list
  Future<void> _saveFavorites(List<FavoriteTTSModel> favorites) async {
    final jsonList = favorites.map((f) => f.toJsonString()).toList();
    await _prefs.setStringList(_favoritesKey, jsonList);
  }
}
