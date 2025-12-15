import 'package:aptcoder_application/bloc/admin/admin_dashboard_bloc.dart';
import 'package:aptcoder_application/widgets/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aptcoder_application/bloc/admin_add_content/admin_add_content_bloc.dart';

class AdminAddContentScreen extends StatefulWidget {
  const AdminAddContentScreen({super.key});

  @override
  State<AdminAddContentScreen> createState() => _AdminAddContentScreenState();
}

class _AdminAddContentScreenState extends State<AdminAddContentScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AdminAddContentBloc>().add(ResetAdminAddContent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.indigo.shade50,
              Colors.white,
              Colors.blue.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: BlocListener<AdminAddContentBloc, AdminAddContentState>(
            listener: (context, state) {
              if (state.error != null) {
                AppSnackBar.show(
                  context,
                  message: state.error!,
                  type: SnackBarType.error,
                );
              }

              if (state.success) {
                AppSnackBar.show(
                  context,
                  message: 'Course Added Successfully',
                  type: SnackBarType.success,
                );

                Navigator.pop(context);
                context.read<AdminDashboardBloc>().add(LoadAdminDashboard());
              }
            },
            child: Column(
              children: [
                // Custom Header
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_rounded),
                          onPressed: () => Navigator.pop(context),
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Create New Course",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Add course details and materials",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: BlocBuilder<AdminAddContentBloc, AdminAddContentState>(
                    builder: (context, state) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Course Title Card
                            _buildInputCard(
                              icon: Icons.title_rounded,
                              label: "Course Title",
                              hint: "e.g., Introduction to Flutter",
                              gradient: [Colors.indigo.shade400, Colors.indigo.shade600],
                              onChanged: (v) => context.read<AdminAddContentBloc>().add(
                                TitleChanged(v),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Course Description Card
                            _buildInputCard(
                              icon: Icons.description_outlined,
                              label: "Course Description",
                              hint: "Brief description of the course",
                              maxLines: 3,
                              gradient: [Colors.blue.shade400, Colors.blue.shade600],
                              onChanged: (v) => context.read<AdminAddContentBloc>().add(
                                DescriptionChanged(v),
                              ),
                            ),

                            const SizedBox(height: 24),

                            Text(
                              "Course Materials",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                              ),
                            ),

                            const SizedBox(height: 16),

                            // YouTube Video URL Card
                            _buildInputCard(
                              icon: Icons.play_circle_outline_rounded,
                              label: "YouTube Video URL",
                              hint: "https://youtube.com/watch?v=...",
                              gradient: [Colors.red.shade400, Colors.red.shade600],
                              onChanged: (v) => context.read<AdminAddContentBloc>().add(
                                VideoUrlChanged(v),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // PDF URL Card
                            _buildInputCard(
                              icon: Icons.picture_as_pdf_outlined,
                              label: "PDF URL",
                              hint: "https://drive.google.com/file/d/...",
                              gradient: [Colors.green.shade400, Colors.green.shade600],
                              onChanged: (v) => context.read<AdminAddContentBloc>().add(
                                PdfUrlChanged(v),
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Submit Button
                            Container(
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.indigo.shade400, Colors.blue.shade500],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.indigo.shade300.withOpacity(0.5),
                                    blurRadius: 16,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                                child: InkWell(
                                  onTap: state.loading
                                      ? null
                                      : () => context.read<AdminAddContentBloc>().add(
                                          SubmitContent(),
                                        ),
                                  borderRadius: BorderRadius.circular(16),
                                  child: Center(
                                    child: state.loading
                                        ? const SizedBox(
                                            height: 24,
                                            width: 24,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2.5,
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: const [
                                              Icon(Icons.check_circle_outline, color: Colors.white, size: 22),
                                              SizedBox(width: 8),
                                              Text(
                                                "Create Course",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputCard({
    required IconData icon,
    required String label,
    required String hint,
    required List<Color> gradient,
    required Function(String) onChanged,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: gradient,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: gradient[0].withOpacity(0.5),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              onChanged: onChanged,
              maxLines: maxLines,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade800,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 14,
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: gradient[0], width: 2),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}