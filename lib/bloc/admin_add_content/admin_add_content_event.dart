part of 'admin_add_content_bloc.dart';
abstract class AdminAddContentEvent {}

class TitleChanged extends AdminAddContentEvent {
  final String value;
  TitleChanged(this.value);
}

class DescriptionChanged extends AdminAddContentEvent {
  final String value;
  DescriptionChanged(this.value);
}

class VideoUrlChanged extends AdminAddContentEvent {
  final String value;
  VideoUrlChanged(this.value);
}

class PdfUrlChanged extends AdminAddContentEvent {
  final String value;
  PdfUrlChanged(this.value);
}



class SubmitContent extends AdminAddContentEvent {}

class LoadCourseForEdit extends AdminAddContentEvent {
  final Map<String, dynamic> course;
  LoadCourseForEdit(this.course);
}
class ResetAdminAddContent extends AdminAddContentEvent {}
