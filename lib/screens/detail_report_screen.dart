import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecopatrol_mobile/models/report_model.dart';
import 'package:ecopatrol_mobile/services/db_helper.dart';
import 'package:ecopatrol_mobile/screens/edit_report_screen.dart';

class DetailReportScreen extends StatelessWidget {
  final ReportModel report;
  const DetailReportScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Laporan")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(report.imagePath),
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) => const Icon(Icons.broken_image, size: 250),
              ),
            ),
            const SizedBox(height: 20),
            Text(report.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Tanggal: ${report.date}", style: TextStyle(color: Colors.grey[700])),
            const SizedBox(height: 20),
            const Text("Deskripsi:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(report.description, style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 20),
            const Text("Lokasi:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text("Latitude: ${report.latitude}"),
            Text("Longitude: ${report.longitude}"),
            const SizedBox(height: 20),
            if (report.status == 'completed') ...[
              const Text("Catatan Penyelesaian:", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(report.completionNotes ?? "-"),
            ],
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => EditReportScreen(report: report)),
                  ).then((_) => Navigator.pop(context));
                },
                child: const Text("Edit Laporan"),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Hapus Laporan"),
                      content: const Text("Yakin ingin menghapus laporan ini?"),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
                        TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Hapus")),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    final db = DBHelper();
                    await db.deleteReport(report.id!);
                    Navigator.pop(context);
                  }
                },
                child: const Text("Hapus Laporan"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}