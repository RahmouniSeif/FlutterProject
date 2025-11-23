import 'package:flutter/material.dart';
import '../../../../config/routes/app_routes.dart';

// --- Consistent Color Palette ---
const Color primaryGreen = Color(0xFF2C5F2D); // Deep Forest Green
const Color darkTextPrimary = Color(0xFF102213);
const Color darkTextSecondary = Color(0xFF4A6B8A);
const Color cardLight = Colors.white;

// New color for text on dark backgrounds
const Color lightTextColor = Colors.white;
const Color lightTextSecondary = Color(0xFFE0E0E0); // Light gray for subtext

// Enum for managing the selected role state
enum UserRole { camper, owner }

class UserRoleSelectionPage extends StatefulWidget {
  const UserRoleSelectionPage({super.key});

  @override
  State<UserRoleSelectionPage> createState() => _UserRoleSelectionPageState();
}

class _UserRoleSelectionPageState extends State<UserRoleSelectionPage> {
  // State to hold the currently selected role, default to Camper
  UserRole _selectedRole = UserRole.camper;

  // Function to handle navigation based on the selected role
  void _continue() {
    String routeName;
    if (_selectedRole == UserRole.camper) {
      // Camper navigates directly to the Sign Up form
      routeName = AppRoutes.login;
    } else {
      // Owner navigates to the License Verification page first
      routeName = AppRoutes.license;
    }
    Navigator.of(context).pushNamed(routeName);
  }

  // A helper function to create the interactive role selection card
  Widget _buildRoleCard({
    required String title,
    required String description,
    required IconData icon,
    required UserRole role,
  }) {
    final bool isSelected = _selectedRole == role;

    // Determine the color for the icon background based on selection
    final Color iconBgColor = isSelected ? primaryGreen.withOpacity(0.2) : primaryGreen.withOpacity(0.1);

    return InkWell(
      onTap: () {
        setState(() {
          _selectedRole = role; // Update state on tap
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: cardLight, // Card background remains white for contrast
          borderRadius: BorderRadius.circular(12),
          // Highlight border for the selected card
          border: Border.all(
            color: isSelected ? primaryGreen : Colors.transparent,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: darkTextPrimary.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            // 1. Icon Section (Left)
            Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 32,
                color: primaryGreen,
              ),
            ),

            const SizedBox(width: 20),

            // 2. Text Content (Middle)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: darkTextPrimary, // Dark text on white card
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: darkTextSecondary, // Secondary dark text on white card
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            // 3. Radio/Checkmark (Right)
            if (isSelected)
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: primaryGreen,
                  shape: BoxShape.circle,
                  border: Border.all(color: primaryGreen, width: 2),
                ),
                child: const Icon(
                  Icons.check,
                  size: 16,
                  color: Colors.white,
                ),
              )
            else
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: darkTextSecondary.withOpacity(0.5), width: 2),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The background color is now handled by the Stack's first child
      body: Stack(
        children: <Widget>[
          // 1. Background Image and Overlay
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  // Set the user's requested network image as background
                  image: NetworkImage(
                    'https://thumbs.dreamstime.com/b/cozy-cartoon-camping-spot-forest-glowing-tents-bright-moonlight-warm-campfire-night-smartphone-wallpaper-404694127.jpg',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              // Add a dark overlay for text contrast and blending
              child: Container(
                color: Colors.black.withOpacity(0.4),
              ),
            ),
          ),

          // 2. Content Layer
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // --- App Logo/Header ---
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0, bottom: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.forest, size: 30, color: primaryGreen),
                        const SizedBox(width: 8),
                        const Text(
                          'CAMPIFY',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: lightTextColor, // Changed to white for contrast
                          ),
                        ),
                      ],
                    ),
                  ),

                  // --- Heading Section ---
                  const Padding(
                    padding: EdgeInsets.only(top: 24.0, bottom: 32.0),
                    child: Text(
                      'How will you be using our app?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: lightTextColor, // Changed to white for contrast
                        height: 1.2,
                      ),
                    ),
                  ),

                  // --- Role Selection Cards ---
                  _buildRoleCard(
                    title: "I'm a Camper",
                    description: 'To find and book adventures',
                    icon: Icons.house_siding,
                    role: UserRole.camper,
                  ),

                  const SizedBox(height: 16),

                  _buildRoleCard(
                    title: "I'm a Center Owner",
                    description: 'To manage my campsite',
                    icon: Icons.storefront_outlined,
                    role: UserRole.owner,
                  ),

                  const Spacer(), // Pushes content up

                  // --- Continue Button ---
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: ElevatedButton(
                      onPressed: _continue, // Enabled since one role is always selected
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)), // Rounded-full
                        elevation: 4,
                        minimumSize: const Size(double.infinity, 56),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),

                  // --- Log In Link ---
                  // Padding(
                  //   padding: const EdgeInsets.only(bottom: 24.0),
                  //   child: TextButton(
                  //     onPressed: () {
                  //       // Navigate to the Login Page
                  //       Navigator.of(context).pushReplacementNamed(AppRoutes.login);
                  //     },
                  //     child: const Text(
                  //       'Already have an account? Log In',
                  //       style: TextStyle(
                  //         fontSize: 14,
                  //         color: lightTextSecondary, // Changed to light gray for contrast
                  //         fontWeight: FontWeight.w500,
                  //         decoration: TextDecoration.underline,
                  //         decorationColor: lightTextSecondary,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
