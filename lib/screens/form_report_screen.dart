import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecopatrol_mobile/models/report_model.dart';
import 'package:ecopatrol_mobile/providers/session_provider.dart';
import 'package:ecopatrol_mobile/services/camera_service.dart';
import 'package:ecopatrol_mobile/services/location_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ecopatrol_mobile/services/db_helper.dart';

class FormReportScreen extends ConsumerStatefulWidget {
  const FormReportScreen({super.key});

  @override
  ConsumerState<FormReportScreen> createState() => _FormReportScreenState();
}

class _FormReportScreenState extends ConsumerState<FormReportScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  File? _imageFile;
  double? _lat, _long;

  bool _loadingLocation = false;
  bool _saving = false;

  Future<void> _pickImage() async {
    final picked = await CameraService.pickImageFromCamera();
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  Future<void> _getLocation() async {
    setState(() => _loadingLocation = true);
    try {
      final pos = await LocationService.getCurrentLocation();
      setState(() {
        _lat = pos.latitude;
        _long = pos.longitude;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => _loadingLocation = false);
    }
  }

  Future<void> _saveReport() async {
    if (_saving) return;
    if (_titleController.text.isEmpty ||
        _descController.text.isEmpty ||
        _imageFile == null ||
        _lat == null ||
        _long == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lengkapi semua data")));
      return;
    }

    setState(() => _saving = true);

    try {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final newPath = '${appDir.path}/$fileName';
      await _imageFile!.copy(newPath);

      final report = ReportModel(
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        imagePath: newPath,
        latitude: _lat!,
        longitude: _long!,
      );

      final db = DBHelper();
      await db.insertReport(report);

      if (!context.mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("✅ Laporan berhasil disimpan")));

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal: $e")));
    } finally {
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Buat Laporan")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: "Judul")),
            const SizedBox(height: 12),
            TextField(controller: _descController, maxLines: 4, decoration: const InputDecoration(labelText: "Deskripsi")),
            const SizedBox(height: 16),
            _imageFile == null
                ? const Text("Belum ada foto")
                : Image.file(_imageFile!, height: 180, width: double.infinity, fit: BoxFit.cover),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text("Ambil Foto"),
              onPressed: _pickImage,
            ),
            const SizedBox(height: 16),
            _loadingLocation
                ? const CircularProgressIndicator()
                : Text(_lat == null ? "Lokasi belum diambil" : "Lat: $_lat\nLong: $_long"),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.location_on),
              label: const Text("Ambil Lokasi"),
              onPressed: _getLocation,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saving ? null : _saveReport,
                child: _saving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Simpan Laporan"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}