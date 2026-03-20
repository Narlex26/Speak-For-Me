import 'package:shared_preferences/shared_preferences.dart';

class StatisticsLocalDataSource {
  static const String _streakKey = 'stat_streak';
  static const String _lastUsageDateKey = 'stat_last_usage_date';
  static const String _specimenPrefix = 'stat_specimen_';

  /// Met à jour la série quotidienne (streak)
  Future<void> updateDailyStreak() async {
    final prefs = await SharedPreferences.getInstance();
    
    final today = DateTime.now();
    final todayStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    
    final lastUsageDateStr = prefs.getString(_lastUsageDateKey);
    final currentStreak = prefs.getInt(_streakKey) ?? 0;

    if (lastUsageDateStr == null) {
      // Première utilisation ou aucune donnée existante
      await prefs.setString(_lastUsageDateKey, todayStr);
      await prefs.setInt(_streakKey, 1);
    } else {
      final lastUsageDate = DateTime.parse(lastUsageDateStr);
      final difference = DateTime(today.year, today.month, today.day)
          .difference(DateTime(lastUsageDate.year, lastUsageDate.month, lastUsageDate.day))
          .inDays;

      if (difference == 1) {
        // Enregistré hier : incrémente le streak
        await prefs.setString(_lastUsageDateKey, todayStr);
        await prefs.setInt(_streakKey, currentStreak + 1);
      } else if (difference > 1) {
        // Streak brisé
        await prefs.setString(_lastUsageDateKey, todayStr);
        await prefs.setInt(_streakKey, 1);
      }
      // Si difference == 0, l'utilisateur a déjà ouvert l'app aujourd'hui (le streak reste tel quel).
    }
  }

  /// Incrémente le compteur de traductions pour un spécimen donné
  Future<void> incrementSpecimenTranslation(String specimenId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_specimenPrefix$specimenId';
    final currentCount = prefs.getInt(key) ?? 0;
    
    await prefs.setInt(key, currentCount + 1);
    
    // On profite de l'occasion pour mettre à jour le streak quotidien s'il fait une traduction
    await updateDailyStreak();
  }

  /// Récupère toutes les statistiques (Streak + compteurs par spécimen)
  Future<Map<String, dynamic>> getStatistics() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Récupérer le streak
    int streak = prefs.getInt(_streakKey) ?? 0;
    
    // Récupérer la date de dernière utilisation pour ajuster le streak si perdu depuis hier
    final lastUsageDateStr = prefs.getString(_lastUsageDateKey);
    if (lastUsageDateStr != null) {
      final today = DateTime.now();
      final lastUsageDate = DateTime.parse(lastUsageDateStr);
      final difference = DateTime(today.year, today.month, today.day)
          .difference(DateTime(lastUsageDate.year, lastUsageDate.month, lastUsageDate.day))
          .inDays;
      if (difference > 1) {
        streak = 0; // Le streak est perdu
      }
    }

    // Récupérer les compteurs par spécimen
    final keys = prefs.getKeys();
    Map<String, int> specimenCounts = {};
    for (String key in keys) {
      if (key.startsWith(_specimenPrefix)) {
        final specimenName = key.replaceFirst(_specimenPrefix, '');
        specimenCounts[specimenName] = prefs.getInt(key) ?? 0;
      }
    }

    // Récupérer le nombre de favoris
    final favoritesList = prefs.getStringList('favorites_tts_list') ?? [];
    final favoritesCount = favoritesList.length;

    return {
      'streak': streak,
      'specimens': specimenCounts,
      'favoritesCount': favoritesCount,
    };
  }
}
