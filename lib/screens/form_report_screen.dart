import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ecopatrol_mobile/services/camera_service.dart';
import 'package:ecopatrol_mobile/services/location_service.dart';
import 'package:ecopatrol_mobile/services/db_firebase.dart';
import 'package:ecopatrol_mobile/models/report_model.dart';

class FormReportScreen extends StatefulWidget {
  const FormReportScreen({super.key});

  @override
  State<FormReportScreen> createState() => _FormReportScreenState();
}

class _FormReportScreenState extends State<FormReportScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  File? imageFile;
  double? latitude;
  double? longitude;

  bool _loadingLocation = false;
  final db = DBFirebase();

  // Ambil gambar dari kamera
  Future<void> _pickImage() async {
    final picked = await CameraService.pickImageFromCamera();
    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
      });
    }
  }

  // Ambil lokasi GPS
  Future<void> _getLocation() async {
    setState(() => _loadingLocation = true);

    final pos = await LocationService.getCurrentLocation();

    setState(() {
      latitude = pos.latitude;
      longitude = pos.longitude;
      _loadingLocation = false;
    });
  }

  // Validasi dan simpan
  Future<void> _saveReport() async {
    if (_titleController.text.isEmpty ||
        _descController.text.isEmpty ||
        imageFile == null ||
        latitude == null ||
        longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Semua data wajib diisi"),
      ));
      return;
    }

    final report = ReportModel(
      title: _titleController.text,
      description: _descController.text,
      imagePath: imageFile!.path,
      latitude: latitude!,
      longitude: longitude!,
      date: DateTime.now().toString(),
    );

    await db.insertReport(report);

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Laporan berhasil disimpan!"),
    ));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buat Laporan"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // J U D U L
            const Text("Judul Laporan:", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: "Masukkan judul...",
              ),
            ),
            const SizedBox(height: 16),

            // D E S K R I P S I
            const Text("Deskripsi:", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _descController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: "Masukkan deskripsi...",
              ),
            ),
            const SizedBox(height: 16),

            // F O T O
            const Text("Foto Bukti:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            Center(
              child: imageFile == null
                  ? Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey[300],
                child: const Center(child: Text("Belum ada foto")),
              )
                  : Image.file(imageFile!, height: 200),
            ),
            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.camera_alt),
              label: const Text("Ambil Foto"),
            ),

            const SizedBox(height: 20),

            // L O K A S I
            const Text("Lokasi:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            _loadingLocation
                ? const Center(child: CircularProgressIndicator())
                : Text(latitude == null
                ? "Belum ada lokasi"
                : "Lat: $latitude, Long: $longitude"),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: _getLocation,
              icon: const Icon(Icons.location_on),
              label: const Text("Ambil Lokasi"),
            ),

            const SizedBox(height: 30),

            // S I M P A N
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveReport,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text("Simpan Laporan"),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
