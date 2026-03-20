import 'dart:convert';
import '../domain/entities/favorite.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesDatasource {
  static const String _prefsKey = 'speak_for_me_favorites';

  Future<List<FavoriteTranslation>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoritesJson = prefs.getString(_prefsKey);
    
    if (favoritesJson == null) return [];
    
    final List<dynamic> decoded = jsonDecode(favoritesJson);
    return decoded.map((json) => FavoriteTranslation.fromJson(json)).toList();
  }

  Future<void> saveFavorite(FavoriteTranslation favorite) async {
    final prefs = await SharedPreferences.getInstance();
    final List<FavoriteTranslation> currentFavorites = await getFavorites();
    
    // Avoid duplicates
    if (!currentFavorites.any((f) => f.phrase == favorite.phrase && f.profileType == favorite.profileType)) {
      currentFavorites.insert(0, favorite);
      
      final String encoded = jsonEncode(currentFavorites.map((f) => f.toJson()).toList());
      await prefs.setString(_prefsKey, encoded);
    }
  }

  Future<void> removeFavorite(FavoriteTranslation favorite) async {
    final prefs = await SharedPreferences.getInstance();
    final List<FavoriteTranslation> currentFavorites = await getFavorites();
    
    currentFavorites.removeWhere((f) => f.phrase == favorite.phrase && f.profileType == favorite.profileType);
    
    final String encoded = jsonEncode(currentFavorites.map((f) => f.toJson()).toList());
    await prefs.setString(_prefsKey, encoded);
  }
}