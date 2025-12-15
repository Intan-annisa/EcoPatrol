import 'package:flutter/material.dart';
import 'package:ecopatrol_mobile/models/report_model.dart';

class EditReportScreen extends StatefulWidget {
  final ReportModel report;

  const EditReportScreen({super.key, required this.report});

  @override
  State<EditReportScreen> createState() => _EditReportScreenState();
}

class _EditReportScreenState extends State<EditReportScreen> {
  late TextEditingController titleCtrl;
  late TextEditingController descCtrl;

  @override
  void initState() {
    super.initState();
    titleCtrl = TextEditingController(text: widget.report.title);
    descCtrl = TextEditingController(text: widget.report.description);
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
              controller: titleCtrl,
              decoration: const InputDecoration(
                labelText: "Judul",
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: descCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Deskripsi",
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                widget.report.title = titleCtrl.text;
                widget.report.description = descCtrl.text;

                Navigator.pop(context, widget.report);
              },
              child: const Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }
}
