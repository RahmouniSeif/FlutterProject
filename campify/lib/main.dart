import 'package:flutter/material.dart';

import 'config/routes/app_routes.dart';

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
      // The initial route points to the first decision screen
      initialRoute: AppRoutes.userRoleSelection,
      routes: AppRoutes.routes, // Defined in lib/config/routes/
      // ... theme and other config
    );
  }
}
