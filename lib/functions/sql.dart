import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:star_wars/functions/class.dart';

class Sql{

  //https://www.youtube.com/watch?v=ckXSR79AACg

  static final Sql instance = Sql._init();
  Sql._init();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('data.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async{
    final databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');

    return await openDatabase(path,version: 1,onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async{
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

       await db.execute('''CREATE TABLE $tableFavorites (
           ${FavoriteFields.id} $idType,
           ${FavoriteFields.name} $textType
           )
           ''');
  }

  Future<Favorites> create(Favorites favorites) async{
    final db = await instance.database;

    final json = favorites.toJson();
    const columns = FavoriteFields.name;
    final values = '${json[FavoriteFields.name]}';

    //final id = await db.rawInsert('INSERT INTO $tableFavorites ($columns) VALUES ($values)');

    final id = await db.insert(tableFavorites,favorites.toJson());

    return favorites.copy(id: id);
  }

  Future<Favorites> readNote(int id) async{
    final db = await instance.database;

    final maps = await db.query(
      tableFavorites,
      columns: FavoriteFields.values,
      where: '${FavoriteFields.id} = ?',
      whereArgs: [id],
    );
    if(maps.isNotEmpty){
      return Favorites.fromJson(maps.first);
    }else{
      throw Exception('ID $id not found');
    }
  }

  Future<List<Favorites>> readAllFavorites() async{
    final db = await instance.database;

    const orderBy = '${FavoriteFields.name} ASC';
    final result = await db.query(tableFavorites,orderBy: orderBy);

    return result.map((json) => Favorites.fromJson(json)).toList();
  }

  Future<int> update(Favorites favorites) async{
    final db = await instance.database;

    return db.update(
      tableFavorites,
      favorites.toJson(),
      where: '${FavoriteFields.id} = ?',
      whereArgs: [favorites.id],
    );
  }

  Future<int> delete(int id) async{
    final db = await instance.database;

    return db.delete(
      tableFavorites,
      where: '${FavoriteFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async{
    final db = await instance.database;
    db.close();
  }

}