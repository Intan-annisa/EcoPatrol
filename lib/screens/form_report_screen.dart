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

  Future<void> _pickImage() async {
    final picked = await CameraService.pickImageFromCamera();
    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
      });
    }
  }

  Future<void> _getLocation() async {
    setState(() => _loadingLocation = true);

    final pos = await LocationService.getCurrentLocation();

    setState(() {
      latitude = pos.latitude;
      longitude = pos.longitude;
      _loadingLocation = false;
    });
  }

  Future<void> _saveReport() async {
    if (_titleController.text.isEmpty ||
        _descController.text.isEmpty ||
        imageFile == null ||
        latitude == null ||
        longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua data wajib diisi")),
      );
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

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Laporan berhasil disimpan")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: const Text("Buat Laporan")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Text("Judul Laporan"),
                const SizedBox(height: 6),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: "Contoh: Sampah menumpuk",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                const Text("Deskripsi"),
                const SizedBox(height: 6),
                TextField(
                  controller: _descController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Jelaskan kondisi di lapangan",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text("Foto Bukti"),
                const SizedBox(height: 10),
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: imageFile == null
                      ? const Center(child: Text("Belum ada foto"))
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(imageFile!, fit: BoxFit.cover),
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Ambil Foto"),
                    onPressed: _pickImage,
                  ),
                ),

                const SizedBox(height: 20),

                const Text("Lokasi"),
                const SizedBox(height: 8),

                _loadingLocation
                    ? const Center(child: CircularProgressIndicator())
                    : Text(
                  latitude == null
                      ? "Lokasi belum diambil"
                      : "Lat: $latitude\nLong: $longitude",
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.location_on),
                    label: const Text("Ambil Lokasi"),
                    onPressed: _getLocation,
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _saveReport,
                    child: const Text("Simpan Laporan"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}