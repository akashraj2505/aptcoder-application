import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/admin_content_service.dart';

part 'admin_add_content_event.dart';
part 'admin_add_content_state.dart';

class AdminAddContentBloc
    extends Bloc<AdminAddContentEvent, AdminAddContentState> {
  final AdminContentService service;

  AdminAddContentBloc(this.service) : super(AdminAddContentState()) {
    on<TitleChanged>((e, emit) {
      emit(state.copyWith(title: e.value, error: null));
    });

    on<DescriptionChanged>((e, emit) {
      emit(state.copyWith(description: e.value, error: null));
    });

    on<VideoUrlChanged>((e, emit) {
      emit(state.copyWith(videoUrl: e.value, error: null));
    });

    on<PdfUrlChanged>((e, emit) {
      emit(state.copyWith(pdfUrl: e.value, error: null));
    });



    on<LoadCourseForEdit>(_loadForEdit);
    on<SubmitContent>(_submit);
    on<ResetAdminAddContent>((event, emit) {
      emit(AdminAddContentState());
    });
  }

  /// 🔹 LOAD COURSE FOR EDIT
  void _loadForEdit(
    LoadCourseForEdit event,
    Emitter<AdminAddContentState> emit,
  ) {
    final course = event.course;

    emit(
      state.copyWith(
        courseId: course['id'],
        title: course['title'] ?? '',
        description: course['description'] ?? '',
        videoUrl: course['videoUrl'] ?? '',
        pdfUrl: course['pdfUrl'] ?? '',
   
        error: null,
        success: false,
      ),
    );
  }

  /// 🔹 SUBMIT (ADD / EDIT)
  Future<void> _submit(
    SubmitContent event,
    Emitter<AdminAddContentState> emit,
  ) async {
    // ✅ Title validation
    if (state.title.trim().isEmpty) {
      emit(state.copyWith(error: "Course title is required"));
      return;
    }

    // ✅ At least one content required
    final hasVideo = state.videoUrl.trim().isNotEmpty;
    final hasPdf = state.pdfUrl.trim().isNotEmpty;

    if (!hasVideo && !hasPdf) {
      emit(
        state.copyWith(
          error: "Please add at least one content (Video / PDF )",
        ),
      );
      return;
    }

    emit(state.copyWith(loading: true, error: null));

    try {
      if (state.courseId == null) {
        // ➕ ADD COURSE
        await service.saveCourse(
          title: state.title.trim(),
          description: state.description.trim(),
          videoUrl: hasVideo ? state.videoUrl.trim() : null,
          pdfUrl: hasPdf ? state.pdfUrl.trim() : null,
        );
      } else {
        // ✏️ UPDATE COURSE
        await service.updateCourse(
          courseId: state.courseId!,
          title: state.title.trim(),
          description: state.description.trim(),
          videoUrl: hasVideo ? state.videoUrl.trim() : null,
          pdfUrl: hasPdf ? state.pdfUrl.trim() : null,
        );
      }

      emit(AdminAddContentState(success: true));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}
