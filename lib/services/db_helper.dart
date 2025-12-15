import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:ecopatrol_mobile/models/report_model.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'ecopatrol.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE reports('
              'id INTEGER PRIMARY KEY AUTOINCREMENT, '
              'title TEXT, '
              'description TEXT, '
              'imagePath TEXT, '
              'latitude REAL, '
              'longitude REAL, '
              'date TEXT, '
              'status TEXT, '
              'completionNotes TEXT, '
              'completionPhotoPath TEXT, '
              'completedAt TEXT'
              ')',
        );
      },
    );
  }

  Future<int> insertReport(ReportModel report) async {
    final db = await database;
    return await db.insert('reports', report.toMap());
  }

  Future<List<ReportModel>> getReports() async {
    final db = await database;
    final maps = await db.query('reports', orderBy: 'id DESC');
    return maps.map((e) => ReportModel.fromMap(e)).toList();
  }

  Future<int> updateReport(ReportModel report) async {
    final db = await database;
    return await db.update(
      'reports',
      report.toMap(),
      where: 'id = ?',
      whereArgs: [report.id],
    );
  }

  Future<int> deleteReport(int id) async {
    final db = await database;
    return await db.delete('reports', where: 'id = ?', whereArgs: [id]);
  }
}