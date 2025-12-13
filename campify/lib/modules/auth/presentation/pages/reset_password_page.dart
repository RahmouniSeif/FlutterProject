import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../services/UserService.dart';
import '../../../../config/routes/app_routes.dart';

// Reuse colors for consistency
const Color primaryGreen = Color(0xFF2C5F2D);
const Color accentOrange = Color(0xFFFF7B54);
const Color inputFillColor = Color(0xFFE7F3E9);
const Color darkTextColor = Color(0xFF102213);
const Color lightTextColor = Colors.white;

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final UserService _userService = UserService();

  bool _isLoading = false;
  String? _message;
  bool _isError = false;

  Future<void> _handleResetPassword() async {
    final token = _tokenController.text.trim();
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (token.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        _message = 'All fields are required.';
        _isError = true;
      });
      return;
    }

    if (newPassword != confirmPassword) {
      setState(() {
        _message = 'Passwords do not match.';
        _isError = true;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      await _userService.resetPassword(token, newPassword);
      if (mounted) {
        setState(() {
          _message = 'Password reset successfully! Redirecting to login...';
          _isError = false;
        });

        // Delay to let user read the success message
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
        }
      }
    } catch (e) {
      setState(() {
        _message = 'Failed to reset password. Check your code or try again.';
        _isError = true;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _tokenController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background - Reusing the style
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/loginbg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),

          // Back Button
          Positioned(
            top: 50,
            left: 24,
            child: ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: lightTextColor, size: 28),
                    onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                  ),
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      padding: const EdgeInsets.all(24.0),
                      constraints: const BoxConstraints(maxWidth: 400),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Reset Password',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: darkTextColor,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Enter the code sent to your email and your new password.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black87),
                          ),
                          const SizedBox(height: 32),
                          if (_message != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Text(
                                _message!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: _isError ? accentOrange : primaryGreen,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          _buildTextField(
                            controller: _tokenController,
                            label: 'Reset Code',
                            hint: 'Enter reset code',
                            icon: Icons.vpn_key_outlined,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _newPasswordController,
                            label: 'New Password',
                            hint: 'Enter new password',
                            icon: Icons.lock_outline,
                            isPassword: true,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _confirmPasswordController,
                            label: 'Confirm Password',
                            hint: 'Confirm new password',
                            icon: Icons.lock_outline,
                            isPassword: true,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: _isLoading ? null : _handleResetPassword,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentOrange,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: lightTextColor,
                                      strokeWidth: 3,
                                    ),
                                  )
                                : const Text(
                                    'Reset Password',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, color: darkTextColor, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword,
          style: const TextStyle(color: darkTextColor),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: darkTextColor.withOpacity(0.6)),
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            prefixIcon: Icon(icon, color: primaryGreen),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: primaryGreen, width: 2),
            ),
            filled: true,
            fillColor: inputFillColor,
          ),
        ),
      ],
    );
  }
}
