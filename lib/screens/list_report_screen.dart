import 'package:flutter/material.dart';
import 'package:ecopatrol_mobile/models/report_model.dart';
import 'detail_report_screen.dart';


class ListReportScreen extends StatefulWidget {
  final List<ReportModel> reports;

  const ListReportScreen({super.key, required this.reports});

  @override
  State<ListReportScreen> createState() => _ListReportScreenState();
}

class _ListReportScreenState extends State<ListReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("List Laporan")),

      body: ListView.builder(
        itemCount: widget.reports.length,
        itemBuilder: (context, index) {
          final report = widget.reports[index];

          return ListTile(
            title: Text(report.title),
            subtitle: Text(report.description),

            onTap: () async {
              // Ambil report yang sudah diedit dari detail
              final updated = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailReportScreen(report: report),
                ),
              );

              // Kalau ada perubahan -> apply ke list
              if (updated != null && updated is ReportModel) {
                setState(() {});
              }
            },
          );
        },
      ),
    );
  }
}
