import 'package:flutter/material.dart';
import 'package:ecopatrol_mobile/models/report_model.dart';

class DetailReportScreen extends StatefulWidget {
  final ReportModel report;

  const DetailReportScreen({super.key, required this.report});

  @override
  State<DetailReportScreen> createState() => _DetailReportScreenState();
}

class _DetailReportScreenState extends State<DetailReportScreen> {
  late TextEditingController titleController;
  late TextEditingController descController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.report.title);
    descController = TextEditingController(text: widget.report.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Laporan")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Judul"),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: "Deskripsi"),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                widget.report.title = titleController.text;
                widget.report.description = descController.text;

                Navigator.pop(context, widget.report);
              },
              child: const Text("Simpan Perubahan"),
            )
          ],
        ),
      ),
    );
  }
}
