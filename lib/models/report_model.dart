class ReportModel {
  final int? id;
  final String title;
  final String description;
  final String photoPath;
  final double latitude;
  final double longitude;
  final int status; // 0 = pending, 1 = selesai

  ReportModel({
    this.id,
    required this.title,
    required this.description,
    required this.photoPath,
    required this.latitude,
    required this.longitude,
    this.status = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'photoPath': photoPath,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
    };
  }

  factory ReportModel.fromMap(Map<String, dynamic> map) {
    return ReportModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      photoPath: map['photoPath'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      status: map['status'],
    );
  }
}