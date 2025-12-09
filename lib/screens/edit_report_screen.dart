import 'package:flutter/material.dart';
import 'package:ecopatrol_mobile/models/report_model.dart';
import 'package:ecopatrol_mobile/services/db_helper.dart';

class EditReportScreen extends StatefulWidget {
  final ReportModel report;

  const EditReportScreen({super.key, required this.report});
  @override
  State<EditReportScreen> createState() => _EditReportScreenState();
}

class _EditReportScreenState extends State<EditReportScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  final db = DBHelper();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.report.title;
    _descController.text = widget.report.description;
  }

  Future<void> _updateReport() async {
    if (_titleController.text.isEmpty || _descController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua field wajib diisi")),
      );
      return;
    }

    final updated = ReportModel(
      id: widget.report.id,
      title: _titleController.text,
      description: _descController.text,
      imagePath: widget.report.imagePath,
      latitude: widget.report.latitude,
      longitude: widget.report.longitude,
      date: widget.report.date,
    );

    await db.updateReport(updated);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Laporan berhasil diperbarui")),
    );

    Navigator.pop(context, true); // kembali dan refresh
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Laporan")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                label: Text("Judul Laporan"),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descController,
              maxLines: 4,
              decoration: const InputDecoration(
                label: Text("Deskripsi"),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _updateReport,
                child: const Text("Simpan Perubahan"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
