import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecopatrol_mobile/models/report_model.dart';
import 'package:ecopatrol_mobile/services/db_helper.dart';

class EditReportScreen extends StatefulWidget {
  final ReportModel report;
  const EditReportScreen({super.key, required this.report});

  @override
  State<EditReportScreen> createState() => _EditReportScreenState();
}

class _EditReportScreenState extends State<EditReportScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  late String _status;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.report.title);
    _descController = TextEditingController(text: widget.report.description);
    _status = widget.report.status;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _updateReport() async {
    if (_titleController.text.isEmpty || _descController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Semua field wajib diisi")));
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
      status: _status,
    );

    final db = DBHelper();
    await db.updateReport(updated);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Laporan")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: "Judul Laporan")),
            const SizedBox(height: 16),
            TextField(
              controller: _descController,
              maxLines: 4,
              decoration: const InputDecoration(labelText: "Deskripsi"),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _status,
              items: ['pending', 'completed'].map((e) {
                return DropdownMenuItem(value: e, child: Text(e.toUpperCase()));
              }).toList(),
              onChanged: (value) => setState(() => _status = value!),
              decoration: const InputDecoration(labelText: "Status"),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _updateReport,
                child: const Text("Simpan Perubahan"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}