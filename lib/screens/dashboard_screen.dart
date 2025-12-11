import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ecopatrol_mobile/services/db_firebase.dart';
import 'package:ecopatrol_mobile/models/report_model.dart';
import 'detail_report_screen.dart';
import 'settings_screen.dart';
import 'form_report_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final db = DBFirebase();
  List<ReportModel> reports = [];

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    final data = await db.getReports();
    setState(() {
      reports = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadReports,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          )
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FormReportScreen()),
          ).then((_) => _loadReports());
        },
      ),

      body: reports.isEmpty
          ? const Center(child: Text("Belum ada laporan"))
          : ListView.builder(
        itemCount: reports.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final r = reports[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: r.imagePath.isNotEmpty
                  ? Image.file(
                File(r.imagePath),
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              )
                  : const Icon(Icons.image),
              title: Text(r.title),
              subtitle: Text(r.description),
              trailing: Text(r.status.toUpperCase()),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailReportScreen(report: r),
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
