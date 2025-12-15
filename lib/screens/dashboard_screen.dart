import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecopatrol_mobile/models/report_model.dart';
import 'package:ecopatrol_mobile/providers/session_provider.dart';
import 'package:ecopatrol_mobile/services/db_helper.dart';
import 'package:ecopatrol_mobile/screens/form_report_screen.dart';
import 'package:ecopatrol_mobile/screens/detail_report_screen.dart';
import 'package:ecopatrol_mobile/screens/settings_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  List<ReportModel> reports = [];

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    final db = DBHelper();
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
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(r.imagePath),
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stack) => const Icon(Icons.broken_image),
                ),
              )
                  : const Icon(Icons.image),
              title: Text(r.title),
              subtitle: Text(r.description),
              trailing: Chip(
                label: Text(r.status.toUpperCase()),
                backgroundColor: r.status == 'completed' ? Colors.green : Colors.red,
                labelStyle: const TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DetailReportScreen(report: r)),
                );
              },
            ),
          );
        },
      ),
    );
  }
}