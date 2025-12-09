import 'package:firebase_database/firebase_database.dart';
import '../models/report_model.dart';

class DBFirebase {
  final DatabaseReference _db =
  FirebaseDatabase.instance.ref().child("reports");

  // INSERT REPORT KE FIREBASE
  Future<void> insertReport(ReportModel report) async {
    final newRef = _db.push();
    await newRef.set(report.toMap());
  }

  // GET ALL REPORTS
  Future<List<ReportModel>> getReports() async {
    final snapshot = await _db.get();

    if (!snapshot.exists) return [];

    List<ReportModel> data = [];

    for (var child in snapshot.children) {
      final map = Map<String, dynamic>.from(child.value as Map);
      data.add(ReportModel.fromMap(map));
    }

    return data;
  }

  // UPDATE REPORT
  Future<void> updateReport(String id, ReportModel report) async {
    await _db.child(id).update(report.toMap());
  }

  // DELETE REPORT
  Future<void> deleteReport(String id) async {
    await _db.child(id).remove();
  }
}
