import 'dart:ui';
import 'package:flutter/material.dart';
// Note: AppRoutes must be defined elsewhere in your project for compilation.
import '../../../../config/routes/app_routes.dart';
// 1. Import the generated services. All API client classes, request/response models
// (LoginRequest, User), and exceptions (ApiException) must be available here.
import 'package:campify/GeneratedServices/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:campify/core/utils/globals.dart';

// Define colors based on the Figma/Tailwind config for perfect fidelity
const Color primaryGreen = Color(0xFF2C5F2D); // Deep Forest Green (primary)
const Color accentOrange = Color(0xFFFF7B54); // Sunset Orange (accent)
const Color inputFillColor = Color(0xFFE7F3E9); // Light green input background
const Color darkTextColor = Color(0xFF102213); // Near black text
const Color lightTextColor = Colors.white; // Main text color on dark background

// --- CONVERTED TO STATEFULWIDGET TO MANAGE INPUTS AND STATE ---
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 🔰 Text Editing Controllers for form fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 🔄 State variables for UI feedback
  bool _isLoading = false;
  String? _errorMessage;

  // ⚙️ Function to handle the login process and API call
  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null; // Clear previous error
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Basic client-side validation
    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Email and password are required.';
      });
      return;
    }

    try {
      // 2. Initialize the API client and use the new UserControllerApi
      // final apiClient = ApiClient();
      final apiClient = await primeHeaders();

      final userControllerApi = UserManagementApi(apiClient);

      // 3. Prepare the request object (using the generated LoginRequest model)
      final loginRequest = LoginRequest(
        email: email,
        password: password,
      );

      // 4. Call the generated API method.
      final User? loggedInUser = await userControllerApi.login(loginRequest);

      setState(() {
        _isLoading = false;
      });

      // Check if the user object was successfully returned and has a unique ID
      if (loggedInUser != null && loggedInUser.userId != null) {
        await prefs.setString("userName", loggedInUser.name.toString());
        await prefs.setString("userId", loggedInUser.userId.toString());

        Navigator.of(context).pushNamedAndRemoveUntil(
          '/home',
          (Route<dynamic> route) => false, // This predicate removes all routes
        );
      } else {
        // Handle API success but invalid credentials/missing data
        setState(() {
          _errorMessage = 'Invalid email or password.';
        });
      }
    } on ApiException catch (e) {
      // 5. Handle API errors (e.g., 401 Unauthorized, 500 Server Error)
      setState(() {
        _isLoading = false;
        // Providing more user-friendly messages for common errors
        _errorMessage = e.code == 401 ? 'Invalid email or password.' : 'Login failed. Error Code: ${e.code} | Message: ${e.message}';
        print('API Exception Details: ${e.message}');
      });
    } catch (e) {
      // Handle general errors (e.g., network issues)
      setState(() {
        _isLoading = false;
        _errorMessage = 'An unexpected error occurred. Check your network connection.';
        print('General Error: $e');
      });
    }
  }

  // 🗑️ Dispose controllers to prevent memory leaks
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 🎨 Widget building starts here
  @override
  Widget build(BuildContext context) {
    // Determine screen size for responsive layout
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // 1. Dark Forest Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                // NOTE: Asset must exist in your project's assets folder and pubspec.yaml
                image: AssetImage('assets/images/loginbg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              // Dark overlay for contrast
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
              ],
            ),
          ),

          // 3. Scrollable Content (Aligned to the bottom/center)
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                // Use ConstrainedBox to ensure the login card sits lower on large screens
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
                                    'Welcome Back,\nCamper! 🏕️',
                                    textAlign: TextAlign.center, // Centered title
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: darkTextColor,
                                    ),
                                  ),
                                  const SizedBox(height: 32),

                                  // --- ERROR MESSAGE DISPLAY ---
                                  if (_errorMessage != null)
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 16.0),
                                      child: Text(
                                        _errorMessage!,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(color: accentOrange, fontWeight: FontWeight.w600),
                                      ),
                                    ),

                                  // --- Email Field ---
                                  _buildTextField(
                                    controller: _emailController, // Linked
                                    label: 'Email',
                                    hint: 'Enter your email',
                                    icon: Icons.mail_outline,
                                    isPassword: false,
                                    keyboardType: TextInputType.emailAddress,
                                  ),

                                  const SizedBox(height: 24),

                                  // --- Password Field ---
                                  _buildTextField(
                                    controller: _passwordController, // Linked
                                    label: 'Password',
                                    hint: 'Enter your password',
                                    icon: Icons.lock_outline,
                                    isPassword: true,
                                  ),

                                  // --- Forgot Password Link ---
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: _isLoading
                                          ? null
                                          : () {
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
                                    onPressed: _isLoading ? null : _handleLogin, // Disabled while loading
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
                                            'Log In',
                                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                          ),
                                  ),

                                  // --- Separator ---
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 32.0),
                                    child: Row(
                                      children: [
                                        const Expanded(child: Divider(color: Colors.grey)),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                                          child: Text('Or log in with', style: TextStyle(color: Colors.grey)),
                                        ),
                                        const Expanded(child: Divider(color: Colors.grey)),
                                      ],
                                    ),
                                  ),

                                  // --- Social Sign-in Buttons ---
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Placeholder social buttons
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
                                        onTap: _isLoading
                                            ? null
                                            : () {
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

          // 4. Back Button (Top Left) with Backdrop Blur
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
                    onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🛠️ Helper widget for custom form text fields
  Widget _buildTextField({
    required TextEditingController controller,
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
          controller: controller, // Linked controller
          obscureText: isPassword,
          keyboardType: keyboardType,
          style: const TextStyle(color: darkTextColor),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: darkTextColor.withOpacity(0.6)),
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            prefixIcon: Icon(icon, color: primaryGreen), // Icon inside the field
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

  // 🌐 Helper widget for social sign-in buttons
  Widget _buildSocialButton(String text, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(12),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        child: Text(
          text,
          style: const TextStyle(color: darkTextColor, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
