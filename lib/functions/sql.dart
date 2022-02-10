import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:star_wars/class/favorites.dart';

class Sql{

  //VÁRIAVEIS UNIVERSAIS
  static String databasePath = 'favorites.db';
  static String tableFavorite = 'favorite';

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB(databasePath);
    return _database!;
  }

  //CRIA O DATABASE
  Future<Database> _initDB(String filePath) async{
    //Determina o caminho do database
    final databasesPath = await getDatabasesPath();
    String path = join(databasesPath, databasePath);

    return await openDatabase(path,version: 1,onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE IF NOT EXISTS $tableFavorite(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)',
      );
    },);
  }

  Future<void> insertFavorite(Favorite favorites) async {
    final db = await database;

    await db.insert(
      tableFavorite,
      favorites.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Favorite>> funcFavorites() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(tableFavorite);

    // Convert the List<Map<String, dynamic> into a List<Favorite>.
    return List.generate(maps.length, (i) {
      return Favorite(
        id: maps[i]['id'],
        name: maps[i]['name'],
      );
    });
  }

  Future<void> updateFavorite(Favorite favorites) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given Favorite.
    await db.update(
      tableFavorite,
      favorites.toMap(),
      // Ensure that the Favorite has a matching id.
      where: 'id = ?',
      // Pass the Favorite's id as a whereArg to prevent SQL injection.
      whereArgs: [favorites.id],
    );
  }

  Future<void> deleteFavorite(int id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Favorite from the database.
    await db.delete(
      tableFavorite,
      // Use a `where` clause to delete a specific favorite.
      where: 'id = ?',
      // Pass the Favorite's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }


  //Funçao de teste se o database esta criado corretamente
  test() async {
    // Check if we have an existing copy first
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, databasePath);
    // try opening (will work if it exists)
    Database db;
    try {
      db = await openDatabase(path, readOnly: true);
    } catch (e) {
      print("Error $e");
    }
  }
}