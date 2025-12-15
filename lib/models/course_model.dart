class CourseModel {
  final String id;
  final String title;
  final String description;
  final String? videoUrl;
  final String? pdfUrl;

  CourseModel({
    required this.id,
    required this.title,
    required this.description,
    this.videoUrl,
    this.pdfUrl,
  });

  factory CourseModel.fromFirestore(String id, Map<String, dynamic> data) {
    return CourseModel(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      videoUrl: data['videoUrl'],
      pdfUrl: data['pdfUrl'],
    );
  }
}
