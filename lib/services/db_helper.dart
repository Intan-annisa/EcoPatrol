import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/report_model.dart';

class DBHelper {
  static Database? _db;

  Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), "reports.db");

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute("""
      CREATE TABLE reports (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        imagePath TEXT,
        latitude REAL,
        longitude REAL,
        date TEXT
      )
      """);
    });
  }

  Future<Database> get database async {
    _db ??= await initDB();
    return _db!;
  }

  Future<int> insertReport(ReportModel report) async {
    final db = await database;
    return await db.insert("reports", report.toMap());
  }

  Future<List<ReportModel>> getAllReports() async {
    final db = await database;
    final res = await db.query("reports", orderBy: "id DESC");
    return res.map((e) => ReportModel.fromMap(e)).toList();
  }
}
