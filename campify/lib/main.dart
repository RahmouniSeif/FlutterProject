import 'package:flutter/material.dart';

import 'config/routes/app_routes.dart';

// --- COLOR PALETTE ---
const Color primary = Color(0xFF386641);
const Color secondary = Color(0xFF6A994E);
const Color backgroundLight = Color(0xFFF7F7F7);
const Color backgroundDark = Color(0xFF121212);
const Color cardLight = Color(0xFFFFFFFF);
const Color cardDark = Color(0xFF1E1E1E);

// --- Main Application Widget (for demonstration) ---
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CampConnect',
      // The initial route points to the first decision screen
      initialRoute: AppRoutes.userRoleSelection,
      routes: AppRoutes.routes, // Defined in lib/config/routes/
      theme: ThemeData(
        fontFamily: 'Plus Jakarta Sans',
        primaryColor: primary,
        scaffoldBackgroundColor: backgroundLight,
        brightness: Brightness.light,
        colorScheme: ColorScheme.light(
          primary: primary,
          secondary: secondary,
          surface: cardLight,
          background: backgroundLight,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        fontFamily: 'Plus Jakarta Sans',
        primaryColor: primary,
        scaffoldBackgroundColor: backgroundDark,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: primary,
          secondary: secondary,
          surface: cardDark,
          background: backgroundDark,
        ),
        useMaterial3: true,
      ),
    );
  }
}
