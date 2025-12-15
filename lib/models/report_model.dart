class ReportModel {
  int? id;
  String title;
  String description;
  String imagePath;
  double latitude;
  double longitude;
  String date;
  String status;
  String? completionNotes;
  String? completionPhotoPath;
  String? completedAt;

  ReportModel({
    this.id,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.latitude,
    required this.longitude,
    String? date, // Tidak pakai `this.date`
    this.status = 'pending',
    this.completionNotes,
    this.completionPhotoPath,
    this.completedAt,
  }) : date = (date?.isEmpty == true)
      ? DateTime.now().toIso8601String()
      : date ?? DateTime.now().toIso8601String();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imagePath': imagePath,
      'latitude': latitude,
      'longitude': longitude,
      'date': date,
      'status': status,
      'completionNotes': completionNotes,
      'completionPhotoPath': completionPhotoPath,
      'completedAt': completedAt,
    };
  }

  factory ReportModel.fromMap(Map<String, dynamic> map) {
    return ReportModel(
      id: map['id'] as int?,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imagePath: map['imagePath'] ?? '',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      date: map['date'] as String?,
      status: map['status'] ?? 'pending',
      completionNotes: map['completionNotes'] as String?,
      completionPhotoPath: map['completionPhotoPath'] as String?,
      completedAt: map['completedAt'] as String?,
    );
  }
}