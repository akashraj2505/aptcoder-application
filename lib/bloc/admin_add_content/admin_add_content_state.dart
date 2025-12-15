part of 'admin_add_content_bloc.dart';

class AdminAddContentState {
  final String? courseId; // 👈 NEW
  final String title;
  final String description;
  final String videoUrl;
  final String pdfUrl;
  final bool loading;
  final bool success;
  final String? error;

  AdminAddContentState({
    this.courseId,
    this.title = '',
    this.description = '',
    this.videoUrl = '',
    this.pdfUrl = '',
    this.loading = false,
    this.success = false,
    this.error,
  });

  AdminAddContentState copyWith({
    String? courseId,
    String? title,
    String? description,
    String? videoUrl,
    String? pdfUrl,
    bool? loading,
    bool? success,
    String? error,
  }) {
    return AdminAddContentState(
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      description: description ?? this.description,
      videoUrl: videoUrl ?? this.videoUrl,
      pdfUrl: pdfUrl ?? this.pdfUrl,
      loading: loading ?? this.loading,
      success: success ?? this.success,
      error: error,
    );
  }
}
