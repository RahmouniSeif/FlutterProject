import 'package:campify/modules/auth/presentation/pages/login_page.dart';
import 'package:campify/modules/home/homePage.dart';
import 'package:flutter/material.dart';

// Import all necessary page widgets from the modules
import '../../modules/auth/presentation/pages/LicenseVerificationPage.dart';
import '../../modules/auth/presentation/pages/user_role_selection_page.dart';
import '../../modules/auth/presentation/pages/sign_up_page.dart';
// TODO: Create the actual login page
// import '../../modules/auth/presentation/pages/login_page.dart';
// TODO: Create the license/owner sign-up page
// import '../../modules/auth/presentation/pages/owner_license_page.dart';

/// Defines all named routes used throughout the application.
abstract class AppRoutes {
  // --- Auth Module Routes ---
  static const String userRoleSelection = '/'; // Initial route
  static const String signUp = '/auth/signUp';
  static const String login = '/auth/login';
  static const String license = '/auth/license';

  // --- Other Module Routes (Examples) ---
  static const String home = '/home';
  static const String marketplace = '/marketplace';

  /// A map of all named routes and the corresponding [WidgetBuilder].
  static Map<String, WidgetBuilder> routes = {
    // --- Auth Module Routes ---

    // The initial screen after app launch
    userRoleSelection: (context) => const UserRoleSelectionPage(),

    // The standard sign-up flow for Campers
    signUp: (context) => const SignUpPage(),

    // Placeholder for the Login Screen
    login: (context) => const LoginPage(),

    // Placeholder for the Owner/License Screen
    license: (context) => LicenseVerificationPage(),

    // --- Other Module Routes (Examples) ---
    // Example: A main tab screen after successful login
    home: (context) => HomePage(),
    marketplace: (context) => const Placeholder(child: Text('Marketplace Screen')),
  };
}
