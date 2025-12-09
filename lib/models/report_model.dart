
class ReportModel {
  int? id;
  String title;
  String description;
  String imagePath;
  double latitude;
  double longitude;
  String date;

  // --- TAMBAHAN UNTUK OFFICER (Mahasiswa 4) ---
  String status; // "pending" atau "completed"
  String? completionNotes;     // deskripsi tindakan saat selesai
  String? completionPhotoPath; // path foto hasil pengerjaan
  String? completedAt;         // timestamp penyelesaian

  ReportModel({
    this.id,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.latitude,
    required this.longitude,
    required this.date,
    this.status = "pending", // default: belum selesai
    this.completionNotes,
    this.completionPhotoPath,
    this.completedAt,
  });

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "description": description,
    "imagePath": imagePath,
    "latitude": latitude,
    "longitude": longitude,
    "date": date,
    "status": status,
    "completionNotes": completionNotes,
    "completionPhotoPath": completionPhotoPath,
    "completedAt": completedAt,
  };

  factory ReportModel.fromMap(Map<String, dynamic> map) {
    return ReportModel(
      id: map["id"],
      title: map["title"],
      description: map["description"],
      imagePath: map["imagePath"],
      latitude: map["latitude"],
      longitude: map["longitude"],
      date: map["date"],
      status: map["status"] ?? "pending",
      completionNotes: map["completionNotes"],
      completionPhotoPath: map["completionPhotoPath"],
      completedAt: map["completedAt"],
    );
  }
}