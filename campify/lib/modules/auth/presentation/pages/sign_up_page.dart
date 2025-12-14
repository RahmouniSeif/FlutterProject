import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// Assuming the following files exist in your project structure
import '../../../../GeneratedServices/api.dart'; // Contains User model and related generated classes
import '../../../../config/routes/app_routes.dart';
import '../../../../services/UserService.dart';

// 1. Convert to a StatefulWidget to manage form state and loading
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Controllers for form fields
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  // NEW: Controller for Phone Number
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // State variables
  bool _isLoading = false;
  String? _errorMessage;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // --- Color Palette ---
  static const primaryColor = Color(0xFF537446); // Dark Green
  static const secondaryColor = Color(0xFFB06F65); // Muted Brown/Red
  static const textColor = Color(0xFF4A4A4A);
  static const linkColor = Color(0xFFB06F65);
  static const primaryGreen = Color(0xFF2C5F2D); // Deep Forest Green
  static const darkTextPrimary = Color(0xFF102213);

  // --- Service Instance ---
  final UserService _userService = UserService();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose(); // Dispose the new controller
    super.dispose();
  }

  // --- Sign-Up Logic ---
  Future<void> _signUp() async {
    // 1. Validate Form Fields
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // 2. Check Password Match
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = "Passwords do not match.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 3. Create User object (now including phone)
      final newUser = User(
        name: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        userType: 'client',
        // NEW: Include phone number, use null if empty or phone number field isn't required by API
        phone: _phoneController.text.isNotEmpty ? _phoneController.text.trim() : null,
      );

      // 4. Call the API
      final createdUser = await _userService.signUp(newUser);

      // 5. Handle Success
      if (createdUser != null) {
        if (mounted) {
          // Show a confirmation and navigate to the Login page
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account created successfully! Please log in.')),
          );
          // Navigate to the login page
          Navigator.of(context).pushReplacementNamed(AppRoutes.login);
        }
      } else {
        // Handle case where API returns null
        setState(() {
          _errorMessage = "Sign up failed. Please try again.";
        });
      }
    } catch (e) {
      // 6. Handle Error
      String message = "An unknown error occurred.";
      if (e.toString().contains('409') || e.toString().contains('Conflict')) {
        message = "Email is already registered. Please log in.";
      } else if (e.toString().contains('400') || e.toString().contains('Bad Request')) {
        message = "Invalid input data. Check your fields.";
      } else {
        message = "Sign-up failed. Check your network connection or server status.";
      }

      if (mounted) {
        setState(() {
          _errorMessage = message;
        });
      }
      print('Sign-up error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Helper widget for form text fields
  Widget _buildTextField({
    required String label,
    required String hint,
    required bool isPassword,
    required TextEditingController controller,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    bool isVisible = false,
    VoidCallback? onToggleVisibility,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, color: textColor, fontSize: 14),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            obscureText: isPassword && !isVisible,
            keyboardType: keyboardType,
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey),
              contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFF0F0F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: primaryColor, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
              filled: true,
              fillColor: const Color(0xFFF7F7F7),
              // Conditional icon for password visibility
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        isVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: onToggleVisibility,
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for social sign-in buttons (kept for UI, no logic)
  Widget _buildSocialButton(IconData icon) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: OutlinedButton(
          onPressed: () => print('${icon.toString()} social login tapped'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            side: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          child: Icon(icon, color: Colors.black54, size: 28),
        ),
      ),
    );
  }

  // Helper function for clickable text spans (kept for UI, no change)
  TextSpan _buildTapText(String text, VoidCallback onTap) {
    return TextSpan(
      text: text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: linkColor,
        decoration: TextDecoration.underline,
      ),
      recognizer: TapGestureRecognizer()..onTap = onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create Account', style: TextStyle(color: darkTextPrimary)),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryGreen),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // --- Error Message Display ---
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // --- Form Fields ---
                _buildTextField(
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  isPassword: false,
                  controller: _fullNameController,
                  validator: (value) => value!.isEmpty ? 'Please enter your full name.' : null,
                ),
                _buildTextField(
                  label: 'Email Address',
                  hint: 'you@example.com',
                  isPassword: false,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) return 'Please enter your email.';
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Enter a valid email.';
                    return null;
                  },
                ),

                // NEW: Phone Number Field
                _buildTextField(
                  label: 'Phone Number (Optional)',
                  hint: '12345678',
                  isPassword: false,
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  // Validator for optional field: only validate if it's not empty
                  validator: (value) {
                    if (value!.isNotEmpty && !RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$').hasMatch(value)) {
                      return 'Enter a valid phone number.';
                    }
                    return null;
                  },
                ),

                _buildTextField(
                  label: 'Password',
                  hint: 'Enter your password',
                  isPassword: true,
                  isVisible: _isPasswordVisible,
                  onToggleVisibility: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  controller: _passwordController,
                  validator: (value) => value!.length < 6 ? 'Password must be at least 6 characters.' : null,
                ),
                _buildTextField(
                  label: 'Confirm Password',
                  hint: 'Confirm your password',
                  isPassword: true,
                  isVisible: _isConfirmPasswordVisible,
                  onToggleVisibility: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                  controller: _confirmPasswordController,
                  validator: (value) {
                    if (value!.isEmpty) return 'Please confirm your password.';
                    if (value != _passwordController.text) return 'Passwords do not match.';
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // --- Create Account Button ---
                ElevatedButton(
                  onPressed: _isLoading ? null : _signUp, // Disable button while loading
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Create Account',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                ),

                const SizedBox(height: 24),

                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account? ", style: TextStyle(color: textColor)),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(AppRoutes.login);
                          },
                          child: const Text(
                            'Log In',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: linkColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'By signing up, you agree to our ',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                          children: [
                            _buildTapText('Terms of Service', () => print('View Terms')),
                            const TextSpan(text: ' and '),
                            _buildTapText('Privacy Policy.', () => print('View Privacy')),
                          ],
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
    );
  }
}
