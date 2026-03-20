import 'package:speak_for_me/core/database/database_helper.dart';
import '../models/history_model.dart';
import 'package:sqflite/sqflite.dart';

class HistoryLocalDataSource {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Limites spécifiées
  static const int _displayLimit = 100;
  static const int _rotationLimit = 500;

  Future<HistoryModel> createHistory(HistoryModel history) async {
    final db = await _dbHelper.database;
    final id = await db.insert('history', history.toJson());
    
    // Vérifier la limite de rotation après insertion
    await _checkRotationLimit(db);
    
    return history.copyWith(id: id);
  }

  Future<List<HistoryModel>> getRecentHistory() async {
    final db = await _dbHelper.database;
    final orderBy = 'timestamp DESC';
    final result = await db.query('history', orderBy: orderBy, limit: _displayLimit);

    return result.map((json) => HistoryModel.fromJson(json)).toList();
  }

  Future<int> deleteHistory(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'history',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearAllHistory() async {
    final db = await _dbHelper.database;
    await db.delete('history');
  }

  Future<void> _checkRotationLimit(Database db) async {
    final countSq = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM history'));
    int count = countSq ?? 0;

    if (count > _rotationLimit) {
      // Calculer combien d'éléments en trop
      int toDeleteCount = count - _displayLimit; // On garde les _displayLimit (100) plus récents

      // Obtenir les IDs des plus anciens
      final result = await db.query(
        'history',
        columns: ['id'],
        orderBy: 'timestamp ASC',
        limit: toDeleteCount,
      );

      if (result.isNotEmpty) {
        final idsToDelete = result.map((e) => e['id'] as int).toList();
        await db.delete(
          'history',
          where: 'id IN (${idsToDelete.map((_) => '?').join(', ')})',
          whereArgs: idsToDelete,
        );
      }
    }
  }
}