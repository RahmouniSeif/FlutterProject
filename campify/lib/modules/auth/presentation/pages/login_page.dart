import 'dart:ui'; // For BackdropFilter

import 'package:flutter/material.dart';
import '../../../../config/routes/app_routes.dart';

// NOTE: You would typically wrap this widget in a BlocProvider for state management.

// Define colors based on the Figma/Tailwind config for perfect fidelity
const Color primaryGreen = Color(0xFF2C5F2D); // Deep Forest Green (primary)
const Color accentOrange = Color(0xFFFF7B54); // Sunset Orange (accent)
const Color inputFillColor = Color(0xFFE7F3E9); // Light green input background
const Color darkTextColor = Color(0xFF102213); // Near black text
const Color lightTextColor = Colors.white; // Main text color on dark background

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine screen size for responsive card placement
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // 1. Dark Forest Background Image
          Container(
            decoration: const BoxDecoration(
              // Background image path updated to use 'assets/images/loginbg.png' as requested
              image: DecorationImage(
                image: AssetImage('assets/images/loginbg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              // Dark overlay for contrast, matching the HTML's bg-black/50
              color: Colors.black.withOpacity(0.5),
            ),
          ),

          // 2. Top Logo (Centered)
          Positioned(
            top: screenHeight > 600 ? 64 : 40, // Responsive top padding
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  height: 48,
                  width: 48,
                  decoration: const BoxDecoration(
                    color: primaryGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.forest, color: Colors.white, size: 30),
                  ),
                ),
                const SizedBox(height: 8),
                // Text logo is not explicitly in the image, but the green circle is.
                // We'll keep the clean logo style from the Figma-implied context.
              ],
            ),
          ),

          // 3. Scrollable Content (Aligned to the bottom/center)
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                // Max height for the SingleChildScrollView to keep card aligned near bottom on tall screens
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: screenHeight * 0.7, // Card starts lower
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
                    child: Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 400),
                        // --- White Card Container with Backdrop Filter ---
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // Replicate backdrop-blur-xl
                            child: Container(
                              padding: const EdgeInsets.all(24.0),
                              decoration: BoxDecoration(
                                // card-light: rgba(255, 255, 255, 0.9)
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // --- Header ---
                                  const Text(
                                    'Welcome Back,\nCamper!',
                                    textAlign: TextAlign.center, // Centered title
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: darkTextColor,
                                    ),
                                  ),
                                  const SizedBox(height: 32),

                                  // --- Email Field ---
                                  _buildTextField(
                                    label: 'Email',
                                    hint: 'Enter your email',
                                    icon: Icons.mail_outline,
                                    isPassword: false,
                                  ),

                                  const SizedBox(height: 24),

                                  // --- Password Field ---
                                  _buildTextField(
                                    label: 'Password',
                                    hint: 'Enter your password',
                                    icon: Icons.lock_outline,
                                    isPassword: true,
                                  ),

                                  // --- Forgot Password Link ---
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {
                                        // TODO: Implement navigation to Forgot Password flow
                                        print('Forgot Password tapped');
                                      },
                                      child: const Text(
                                        'Forgot Password?',
                                        style: TextStyle(color: primaryGreen, fontSize: 14, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // --- Log In Button ---
                                  ElevatedButton(
                                    onPressed: () {
                                      // TODO: Get Bloc instance and dispatch a LoginEvent
                                      print('Log In Tapped (Logic needs to be implemented in LoginBloc)');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: accentOrange,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      elevation: 0,
                                    ),
                                    child: const Text(
                                      'Log In',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                  ),

                                  // --- Separator ---
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 32.0),
                                    child: Row(
                                      children: [
                                        Expanded(child: Divider(color: Colors.grey)),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                                          child: Text('Or log in with', style: TextStyle(color: Colors.grey)),
                                        ),
                                        Expanded(child: Divider(color: Colors.grey)),
                                      ],
                                    ),
                                  ),

                                  // --- Social Sign-in Buttons ---
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // The Figma image uses specific brand icons, using text placeholders here
                                      _buildSocialButton('G', () => print('Google Login')),
                                      _buildSocialButton('A', () => print('Apple Login')),
                                      _buildSocialButton('f', () => print('Facebook Login')),
                                    ],
                                  ),

                                  const SizedBox(height: 48),

                                  // --- Don't have an account link ---
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("Don't have an account? ", style: TextStyle(color: darkTextColor, fontSize: 16, fontWeight: FontWeight.w500)),
                                      GestureDetector(
                                        onTap: () {
                                          // Navigate to the Sign Up Page
                                          Navigator.of(context).pushNamed(AppRoutes.signUp);
                                        },
                                        child: const Text(
                                          'Sign Up',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: primaryGreen,
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
                    ),
                  ),
                ),
              ),
            ),
          ),
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
                    color: Colors.white.withOpacity(0.1), // Translucent white background
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: lightTextColor, size: 28),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for form text fields
  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    required bool isPassword,
    TextInputType keyboardType = TextInputType.text,
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
          obscureText: isPassword,
          keyboardType: keyboardType,
          style: const TextStyle(color: darkTextColor),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: darkTextColor.withOpacity(0.6)),
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            prefixIcon: const Icon(Icons.mail_outline, color: primaryGreen), // Icon inside the field
            suffixIcon: isPassword ? const Icon(Icons.visibility_outlined, color: primaryGreen) : null,
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

  // Helper widget for social sign-in buttons
  Widget _buildSocialButton(String text, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Center(
            child: Text(text, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: darkTextColor)),
          ),
        ),
      ),
    );
  }
}
