import 'dart:io';
import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  late Database _database;

  Future<void> open() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'favorites_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE favorites(id INTEGER PRIMARY KEY AUTOINCREMENT, product_id TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertFavorite(String productId) async {
    await _database.insert(
      'favorites',
      {'product_id': productId},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    return await _database.query('favorites');
  }

   Future<void> deleteFavorite(int favoriteId) async {
    await _database.delete(
      'favorites',
      where: 'id = ?',
      whereArgs: [favoriteId],
    );
  }

  Future<void> deleteFavoriteByProductId(String productId) async {
    await _database.delete(
      'favorites',
      where: 'product_id = ?',
      whereArgs: [productId],
    );
  }

Future<void> deleteAllFavorites() async {
    await _database.delete('favorites');
  }
}

