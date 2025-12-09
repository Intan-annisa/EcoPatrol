import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ecopatrol_mobile/services/db_helper.dart';
import 'package:ecopatrol_mobile/models/report_model.dart';
import 'detail_report_screen.dart';

class ListReportScreen extends StatefulWidget {
  const ListReportScreen({super.key});

  @override
  State<ListReportScreen> createState() => _ListReportScreenState();
}

class _ListReportScreenState extends State<ListReportScreen> {
  final db = DBHelper();
  List<ReportModel> reports = [];

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    final data = await db.getAllReports();
    setState(() {
      reports = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Laporan"),
      ),
      body: reports.isEmpty
          ? const Center(child: Text("Belum ada laporan"))
          : ListView.builder(
              itemCount: reports.length,
              itemBuilder: (context, i) {
                final item = reports[i];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(item.imagePath),
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(item.title),
                    subtitle: Text(item.date),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailReportScreen(report: item),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}