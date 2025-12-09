import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ecopatrol_mobile/models/report_model.dart';

class DetailReportScreen extends StatelessWidget {
  final ReportModel report;

  const DetailReportScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Laporan"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FOTO BESAR
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(report.imagePath),
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),

            // JUDUL
            Text(
              report.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // TANGGAL
            Text(
              "Tanggal: ${report.date}",
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),

            // DESKRIPSI
            const Text(
              "Deskripsi:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              report.description,
              style: const TextStyle(fontSize: 15),
            ),

            const SizedBox(height: 20),

            // LOKASI
            const Text(
              "Lokasi:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text("Latitude  : ${report.latitude}"),
            Text("Longitude : ${report.longitude}"),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}