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

  /// Calls the API to request a password reset.
  Future<void> forgotPassword(String email) async {
    try {
      final requestBody = {'email': email};
      await _api.forgotPassword(requestBody);
    } on ApiException catch (e) {
      print('API Exception during forgot password: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('General Exception during forgot password: $e');
      rethrow;
    }
  }

  /// Calls the API to reset the password using the token and new password.
  Future<void> resetPassword(String token, String newPassword) async {
    try {
      final requestBody = {
        'token': token,
        'newPassword': newPassword,
      };
      await _api.resetPassword(requestBody);
    } on ApiException catch (e) {
      print('API Exception during reset password: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('General Exception during reset password: $e');
      rethrow;
    }
  }
}
