import 'package:aptcoder_application/theme/gradients.dart';
import 'package:aptcoder_application/widgets/app_snackbar.dart';
import 'package:aptcoder_application/widgets/forgot_password_dialog.dart';
import 'package:aptcoder_application/widgets/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:aptcoder_application/services/auth_service.dart';
import 'package:aptcoder_application/services/user_service.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _authService = AuthService();
  final _userService = UserService();
bool _isEmailLoading = false;
bool _isGoogleLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo or Icon
                  ShaderMask(
                    shaderCallback: (bounds) =>
                        AppGradients.adminGradient.createShader(bounds),
                    child: const Icon(
                      Icons.admin_panel_settings_rounded,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),

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
                    "Login to your admin account",
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
                      onPressed: _isEmailLoading ? null : _forgotPassword,
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Login Button
                  _buildPrimaryButton(
                    title: "Login",
                    onTap: _emailLogin,
                    isLoading: _isEmailLoading,
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
                  googleSignInButton(onTap: _isGoogleLoading ? () {} : _googleLogin),
                  const SizedBox(height: 32),

                  // Signup Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(color: Colors.grey[700], fontSize: 15),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                            context,
                            '/adminSignup',
                          );
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _emailLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isEmailLoading = true);

    try {
      final user = await _authService.signInWithEmail(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
      );

      if (user != null) {
        // Verify user role from Firestore
        final userData = await _userService.getUser(user.uid);

        if (userData != null && userData['role'] == 'admin') {
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/adminDashboard');
            AppSnackBar.show(
              context,
              message: 'Admin Login Successful!',
              type: SnackBarType.success,
            );
          }
        } else if (userData != null && userData['role'] == 'student') {
          // User exists but as a student
          AppSnackBar.show(
            context,
            message:
                'This email is registered as a student. Please login through the Student Portal.',
            type: SnackBarType.error,
          );
          await _authService.signOut();
        } else {
          AppSnackBar.show(
            context,
            message: 'Access denied. Admin account required.',
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
        setState(() => _isEmailLoading = false);
      }
    }
  }

  Future<void> _googleLogin() async {
    setState(() => _isGoogleLoading = true);

    try {
      final user = await _authService.signInWithGoogle();

      if (user != null) {
        // Check if user exists in Firestore
        final userData = await _userService.getUser(user.uid);

        if (userData != null && userData['role'] == 'admin') {
          // Existing admin user
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/adminDashboard');
            AppSnackBar.show(
              context,
              message: 'Admin Google Login Successful!',
              type: SnackBarType.success,
            );
          }
        } else if (userData != null && userData['role'] == 'student') {
          // User exists but as a student
          AppSnackBar.show(
            context,
            message:
                'This email is registered as a student. Please login through the Student Portal.',
            type: SnackBarType.error,
          );
          await _authService.signOut();
        } else {
          // New Google user - create admin profile
          await _userService.saveUser(
            uid: user.uid,
            name: user.displayName ?? 'Admin User',
            email: user.email ?? '',
            role: 'admin',
          );

          if (mounted) {
            Navigator.pushReplacementNamed(context, '/adminDashboard');
            AppSnackBar.show(
              context,
              message: 'Admin Google Signup Successful!',
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
        setState(() => _isGoogleLoading = false);
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
    return TextFormField(
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
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
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
        gradient: LinearGradient(colors: AppGradients.adminGradient.colors),
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
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
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
