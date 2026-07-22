import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:news_app/api_service/hooks/auth_api.dart';
import 'package:news_app/config/routes.dart';
import 'package:news_app/theme/app_colors.dart';
import 'package:news_app/theme/app_theme.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await signup(
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        phone: _phoneController.text.trim(),
      );
      if (!mounted) return;
      context.go(AppRoutes.home);
    } catch (e) {
      _showError(_extractErrorMessage(e));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _extractErrorMessage(Object e) {
    // DioException carries the server's error payload in e.response?.data
    try {
      final dynamic data = (e as dynamic).response?.data;
      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      }
    } catch (_) {}
    return 'Signup failed. Please try again.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                Text(
                  'Create account',
                  style: TextStyle(
                    fontFamily: AppTheme.headingFont,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPri,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sign up to start catching up on your news.',
                  style: TextStyle(fontSize: 15, color: AppColors.textSec),
                ),
                const SizedBox(height: 40),

                // Full name field
                const Text(
                  'Full name',
                  style: TextStyle(
                    color: AppColors.textSec,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _fullNameController,
                  textCapitalization: TextCapitalization.words,
                  style: const TextStyle(color: AppColors.textPri),
                  decoration: _inputDecoration('Jane Doe'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter your full name';
                    }
                    if (!value.trim().contains(' ')) {
                      return 'Enter your first and last name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Email field
                const Text(
                  'Email',
                  style: TextStyle(
                    color: AppColors.textSec,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: AppColors.textPri),
                  decoration: _inputDecoration('you@example.com'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter your email';
                    }
                    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                        .hasMatch(value.trim())) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Phone field
                const Text(
                  'Phone number',
                  style: TextStyle(
                    color: AppColors.textSec,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: AppColors.textPri),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9+\s-]')),
                  ],
                  decoration: _inputDecoration('+1 555 123 4567'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter your phone number';
                    }
                    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
                    if (digits.length < 7) {
                      return 'Enter a valid phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Password field
                const Text(
                  'Password',
                  style: TextStyle(
                    color: AppColors.textSec,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: const TextStyle(color: AppColors.textPri),
                  decoration: _inputDecoration('••••••••').copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.textSec,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Pill button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSignup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.pri,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: AppColors.white,
                            ),
                          )
                        : const Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 32),

                Center(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: AppColors.textSec.withOpacity(0.7),
                        fontSize: 14,
                      ),
                      children: [
                        const TextSpan(text: "Already have an account? "),
                        TextSpan(
                          text: 'Log in',
                          style: const TextStyle(
                            color: AppColors.textPri,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context.go(AppRoutes.login);
                            },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: AppColors.textSec.withOpacity(0.7)),
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(54),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(54),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(54),
        borderSide: const BorderSide(color: AppColors.pri, width: 1.2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(54),
        borderSide: BorderSide(color: AppColors.error, width: 1.2),
      ),
    );
  }
}