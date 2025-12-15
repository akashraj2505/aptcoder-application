import 'package:aptcoder_application/bloc/student_dashboard/student_dashboard_bloc.dart';
import 'package:aptcoder_application/screens/student/dashboard/student_dashboard_screen.dart';
import 'package:aptcoder_application/services/student_dashboard_service.dart';
import 'package:aptcoder_application/widgets/app_snackbar.dart';
import 'package:aptcoder_application/widgets/forgot_password_dialog.dart';
import 'package:aptcoder_application/widgets/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:aptcoder_application/services/auth_service.dart';
import 'package:aptcoder_application/services/user_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentLoginScreen extends StatefulWidget {
  const StudentLoginScreen({super.key});

  @override
  State<StudentLoginScreen> createState() => _StudentLoginScreenState();
}

class _StudentLoginScreenState extends State<StudentLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _authService = AuthService();
  final _userService = UserService();
  bool _isLoading = false;
  bool _obscurePassword = true;

  void _goToStudentDashboard(BuildContext context, String studentId) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) =>
              StudentDashboardBloc(StudentDashboardService())
                ..add(LoadStudentDashboard(studentId)),
          child: const StudentDashboardScreen(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade50, Colors.white, Colors.purple.shade50],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo with gradient background
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [Colors.blue.shade400, Colors.purple.shade400],
                      ).createShader(bounds),
                      child: const Icon(
                        Icons.school_rounded,
                        size: 70,
                        color: Colors.white, // required for ShaderMask
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Title
                    Text(
                      "Welcome Back!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Login to continue learning",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 40),

                    // Email Field
                    _buildInputField(
                      label: "Email Address",
                      icon: Icons.email_outlined,
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password Field
                    _buildInputField(
                      label: "Password",
                      icon: Icons.lock_outline,
                      controller: _passwordCtrl,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.grey[600],
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _isLoading ? null : _forgotPassword,
                        child: ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [
                              Colors.blue.shade600,
                              Colors.purple.shade600,
                            ],
                          ).createShader(bounds),
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Login Button
                    _buildPrimaryButton(
                      title: "Login",
                      onTap: _emailLogin,
                      isLoading: _isLoading,
                    ),
                    const SizedBox(height: 24),

                    // Divider
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey[400])),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "OR",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey[400])),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Google Sign In Button
                    googleSignInButton(
                      onTap: _isLoading ? () {} : _googleLogin,
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _emailLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = await _authService.signInWithEmail(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
      );

      if (user != null) {
        // Verify user role from Firestore
        final userData = await _userService.getUser(user.uid);

        if (userData != null && userData['role'] == 'student') {
          if (mounted) {
            _goToStudentDashboard(context, user.uid);
            AppSnackBar.show(
              context,
              message: 'Student Login Successful!',
              type: SnackBarType.success,
            );
          }
        } else if (userData != null && userData['role'] == 'admin') {
          // User exists but as an admin
          AppSnackBar.show(
            context,
            message:
                'This email is registered as an admin. Please login through the Admin Portal.',
            type: SnackBarType.error,
          );
          await _authService.signOut();
        } else {
          AppSnackBar.show(
            context,
            message: 'Access denied. Student account required.',
            type: SnackBarType.error,
          );
          await _authService.signOut();
        }
      } else {
        AppSnackBar.show(
          context,
          message: 'Login failed. Please check your credentials.',
          type: SnackBarType.error,
        );
      }
    } catch (e) {
      AppSnackBar.show(
        context,
        message: 'Error: ${e.toString()}',
        type: SnackBarType.error,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _googleLogin() async {
    setState(() => _isLoading = true);

    try {
      final user = await _authService.signInWithGoogle();

      if (user != null) {
        // Check if user exists in Firestore
        final userData = await _userService.getUser(user.uid);

        if (userData != null && userData['role'] == 'student') {
          // Existing student user
          if (mounted) {
            _goToStudentDashboard(context, user.uid);
            AppSnackBar.show(
              context,
              message: 'Student Google Login Successful!',
              type: SnackBarType.success,
            );
          }
        } else if (userData != null && userData['role'] == 'admin') {
          // User exists but as an admin
          AppSnackBar.show(
            context,
            message:
                'This email is registered as an admin. Please login through the Admin Portal.',
            type: SnackBarType.error,
          );
          await _authService.signOut();
        } else {
          // New Google user - create student profile
          await _userService.saveUser(
            uid: user.uid,
            name: user.displayName ?? 'Student',
            email: user.email ?? '',
            role: 'student',
          );

          if (mounted) {
            _goToStudentDashboard(context, user.uid);
            AppSnackBar.show(
              context,
              message: 'Student Google SignUp Successful!',
              type: SnackBarType.success,
            );
          }
        }
      } else {
        AppSnackBar.show(
          context,
          message: 'Google sign-in failed. Please try again.',
          type: SnackBarType.error,
        );
      }
    } catch (e) {
      AppSnackBar.show(
        context,
        message: 'Error: ${e.toString()}',
        type: SnackBarType.error,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _forgotPassword() async {
    await showForgotPasswordDialog(context);
  }

  Widget _buildInputField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey[600]),
          suffixIcon: suffixIcon,
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[700]),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton({
    required String title,
    required VoidCallback onTap,
    required bool isLoading,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.purple.shade400],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade300.withOpacity(0.5),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
