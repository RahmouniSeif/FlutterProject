// Placeholder imports - replace with your actual paths
import 'dart:io';

import '../GeneratedServices/api.dart';

class UserService {
  final UserManagementApi _api;

  UserService() : _api = UserManagementApi(defaultApiClient);

  /// Calls the API to create a new user.
  /// Throws an exception (or returns null) on failure.
  Future<User?> signUp(User user) async {
    try {
      // The createUser method directly uses the underlying HTTP call.
      // It handles status codes >= 400 by throwing an ApiException.
      return await _api.createUser(user);
    } on ApiException catch (e) {
      // You can add specific handling for API errors here,
      // e.g., if (e.statusCode == HttpStatus.conflict) throw EmailConflictException();
      print('API Exception during sign up: ${e.code} - ${e.message}');
      rethrow; // Re-throw the exception to be caught in the UI layer
    } catch (e) {
      // Handle other potential errors (network issues, etc.)
      print('General Exception during sign up: $e');
      rethrow;
    }
  }
}
