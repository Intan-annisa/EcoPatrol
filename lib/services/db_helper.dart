import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> init() async {
    if (_db != null) return _db!;

    final path = join(await getDatabasesPath(), 'ecopatrol.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE reports (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            photoPath TEXT,
            latitude REAL,
            longitude REAL,
            status INTEGER
          )
        ''');
      },
    );

    return _db!;
  }
}