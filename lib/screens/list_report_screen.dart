import 'package:flutter/material.dart';
import 'package:ecopatrol_mobile/models/report_model.dart';
import 'package:ecopatrol_mobile/services/db_helper.dart';
import 'detail_report_screen.dart';

class ListReportScreen extends StatefulWidget {
  const ListReportScreen({super.key});

  @override
  State<ListReportScreen> createState() => _ListReportScreenState();
}

class _ListReportScreenState extends State<ListReportScreen> {
  final DBFirebase db = DBFirebase();
  List<ReportModel> reports = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    final data = await db.getReports();
    setState(() {
      reports = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List Laporan"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadReports,
          )
        ],
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : reports.isEmpty
          ? const Center(child: Text("Belum ada laporan"))
          : ListView.builder(
        itemCount: reports.length,
        itemBuilder: (context, index) {
          final report = reports[index];

          return Card(
            child: ListTile(
              title: Text(report.title),
              subtitle: Text(report.description),
              trailing: Text(report.status.toUpperCase()),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        DetailReportScreen(report: report),
                  ),
                );
                _loadReports();
              },
            ),
          );
        },
      ),
    );
  }
}
