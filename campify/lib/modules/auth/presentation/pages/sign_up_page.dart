import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart'; // Standard Bloc import
import '../../../../config/routes/app_routes.dart';

// NOTE: You would typically wrap this widget in a BlocProvider in your main.dart or routing config.

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    // --- Define the color palette based on the image ---
    const primaryColor = Color(0xFF537446); // Dark Green
    const secondaryColor = Color(0xFFB06F65); // Muted Brown/Red
    const textColor = Color(0xFF4A4A4A);
    const linkColor = Color(0xFFB06F65); // For "Log In" link
// --- Consistent Color Palette ---
    const Color primaryGreen = Color(0xFF2C5F2D); // Deep Forest Green
    const Color lightBackground = Color(0xFFF6F8F6);
    const Color darkTextPrimary = Color(0xFF102213);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Create Account', style: TextStyle(color: darkTextPrimary)),
        centerTitle: true,
        // The leading back button (Icons.arrow_back) is automatically
        // included by Flutter's AppBar when it detects it can pop a route.
        // We ensure the background is clean white and elevation is zero.
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent, // Ensures no color tint on scroll (Flutter 3.16+)
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryGreen), // Color the back arrow
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // --- Header and Icon ---
              // const Center(
              //   child: Padding(
              //     padding: EdgeInsets.only(top: 16.0, bottom: 24.0),
              //     child: Column(
              //       children: [
              //         // Placeholder for the tent icon shown in the image
              //         CircleAvatar(
              //           radius: 30,
              //           backgroundColor: primaryColor,
              //           child: Icon(Icons.terrain, size: 30, color: Colors.white),
              //         ),
              //         SizedBox(height: 16),
              //         Text(
              //           'Join the Adventure',
              //           style: TextStyle(
              //             fontSize: 28,
              //             fontWeight: FontWeight.bold,
              //             color: textColor,
              //           ),
              //         ),
              //         SizedBox(height: 8),
              //         Text(
              //           'Create an account to start your journey.',
              //           style: TextStyle(fontSize: 16, color: Colors.grey),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),

              // --- Form Fields ---
              const SizedBox(height: 16),
              _buildTextField(label: 'Full Name', hint: 'Enter your full name', isPassword: false),
              _buildTextField(label: 'Email Address', hint: 'you@example.com', isPassword: false, keyboardType: TextInputType.emailAddress),
              _buildTextField(label: 'Password', hint: 'Enter your password', isPassword: true),
              _buildTextField(label: 'Confirm Password', hint: 'Confirm your password', isPassword: true),
              const SizedBox(height: 32),

              // --- Create Account Button ---
              ElevatedButton(
                onPressed: () {
                  // TODO: Get Bloc instance using BlocProvider.of(context)
                  // TODO: Dispatch a SignUpEvent with form data
                  print('Create Account Tapped (Logic needs to be implemented in SignUpBloc)');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                ),
                child: const Text(
                  'Create Account',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),

              // --- Separator ---
              Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('Or continue with', style: TextStyle(color: Colors.grey)),
                    ),
                    Expanded(child: Divider(color: Colors.grey)),
                  ],
                ),
              ),

              // --- Social Sign-in Buttons ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSocialButton(Icons.apple), // Placeholder for Apple/Generic
                  _buildSocialButton(Icons.email), // Placeholder for Google/Email
                  _buildSocialButton(Icons.facebook), // Placeholder for Facebook
                ],
              ),

              const SizedBox(height: 24),

              // --- Footer Links ---
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? ", style: TextStyle(color: textColor)),
                      GestureDetector(
                        onTap: () {
                          // Navigate to the Login Page
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
    );
  }

  // Helper widget for form text fields
  Widget _buildTextField({
    required String label,
    required String hint,
    required bool isPassword,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4A4A4A), fontSize: 14),
          ),
          const SizedBox(height: 8),
          TextField(
            obscureText: isPassword,
            keyboardType: keyboardType,
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
                borderSide: const BorderSide(color: Color(0xFF537446), width: 2),
              ),
              filled: true,
              fillColor: const Color(0xFFF7F7F7),
              // Conditional icon for password visibility
              suffixIcon: isPassword ? const Icon(Icons.remove_red_eye_outlined, color: Colors.grey) : null,
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for social sign-in buttons
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

  // Helper function for clickable text spans
  TextSpan _buildTapText(String text, VoidCallback onTap) {
    return TextSpan(
      text: text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Color(0xFFB06F65),
        decoration: TextDecoration.underline,
      ),
      recognizer: TapGestureRecognizer()..onTap = onTap,
    );
  }
}
