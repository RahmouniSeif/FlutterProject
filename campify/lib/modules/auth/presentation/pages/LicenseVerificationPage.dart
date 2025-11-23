import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For TextInputFormatter
import 'dart:ui'; // For BackdropFilter
import '../../../../config/routes/app_routes.dart'; // Import to use navigation

// --- Color Palette based on the Figma/HTML snippet ---
const Color primaryGreen = Color(0xFF2C5F2D); // Deep Forest Green (primary)
const Color darkTextColor = Color(0xFF102213); // Near black text
const Color lightTextColor = Colors.white; // Main text color on dark background
const Color subtextColor = Color(0xFFE0E0E0); // Lighter text (subtext/description)
const Color errorRed = Color(0xFFC84B31); // Error color
const Color inputFillColor = Colors.white10; // Input background (white/10 opacity)
const Color inputBorderColor = Colors.white24; // Input border (white/24 opacity)

class LicenseVerificationPage extends StatefulWidget {
  const LicenseVerificationPage({super.key});

  @override
  State<LicenseVerificationPage> createState() => _LicenseVerificationPageState();
}

class _LicenseVerificationPageState extends State<LicenseVerificationPage> {
  // State variables for form management and validation
  final TextEditingController _controller = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Add listener for real-time validation and input formatting
    _controller.addListener(_validateKeyOnChange);
  }

  @override
  void dispose() {
    _controller.removeListener(_validateKeyOnChange);
    _controller.dispose();
    super.dispose();
  }

  // Input formatter that adds dashes to the 16-character key: XXXX-XXXX-XXXX-XXXX
  String _formatKey(String text) {
    String rawText = text.toUpperCase().replaceAll('-', '');
    final StringBuffer buffer = StringBuffer();
    for (int i = 0; i < rawText.length; i++) {
      buffer.write(rawText[i]);
      if (i % 4 == 3 && i != rawText.length - 1) {
        buffer.write('-');
      }
    }
    return buffer.toString();
  }

  // Validation logic and input cleaning/formatting
  void _validateKeyOnChange() {
    String rawKey = _controller.text.replaceAll('-', '').trim();

    // 1. Enforce max length of 16 raw characters
    if (rawKey.length > 16) {
      final newText = _formatKey(rawKey.substring(0, 16));
      _controller.value = _controller.value.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
      rawKey = rawKey.substring(0, 16);
    }

    // 2. Format the input text (add dashes)
    final formattedText = _formatKey(rawKey);

    // Check if re-formatting is needed to maintain structure/cursor position
    if (formattedText != _controller.text) {
      // Find the current cursor position index relative to the raw text
      int rawCursorIndex = _controller.text.substring(0, _controller.selection.start).replaceAll('-', '').length;

      // Determine the new cursor position in the formatted text
      int newCursorIndex = 0;
      int dashCount = 0;
      for (int i = 0; i < rawCursorIndex; i++) {
        newCursorIndex++;
        if ((i + 1) % 4 == 0) dashCount++;
      }
      newCursorIndex += dashCount; // Add back dashes before the cursor

      // Apply new formatted value and cursor position
      _controller.value = _controller.value.copyWith(
        text: formattedText,
        selection: TextSelection.collapsed(offset: newCursorIndex),
      );
    }

    // 3. Clear/set error state based on length
    if (_errorMessage != null && rawKey.length == 16) {
      // Clear error when the user corrects the length
      setState(() {
        _errorMessage = null;
      });
    }
  }

  // Simulate license key verification
  Future<void> _verifyLicenseKey() async {
    final rawKey = _controller.text.replaceAll('-', '').trim();

    // Final validation check
    if (rawKey.length != 16) {
      setState(() {
        _errorMessage = 'License key must be exactly 16 alphanumeric characters.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null; // Clear previous errors
    });

    try {
      // --- Simulate API Call ---
      await Future.delayed(const Duration(seconds: 2));

      // Simple mock logic: accept a specific key, reject others
      if (rawKey == '1234567890123456') {
        // Verification successful
        if (mounted) {
          // Navigate to the Owner Sign Up page
          // Using pushReplacementNamed to prevent coming back to this screen
          Navigator.of(context).pushReplacementNamed(AppRoutes.signUp);
        }
      } else {
        // Verification failed
        setState(() {
          _errorMessage = 'The license key is invalid or has expired. Please check and try again.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred during verification. Check your connection.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Helper widget to build the custom license key input field
  Widget _buildLicenseKeyField() {
    final bool hasError = _errorMessage != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        const Text(
          'License Key',
          style: TextStyle(
            color: lightTextColor, // White label
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),

        // Custom Input Field Layout
        Container(
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasError ? errorRed : inputBorderColor,
              width: hasError ? 2 : 1,
            ),
            color: inputFillColor, // White/10
          ),
          child: Row(
            children: [
              // 1. Key Icon Prefix
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Icon(
                  Icons.key_outlined, // Outlined key icon
                  color: lightTextColor.withOpacity(0.5),
                ),
              ),

              // 2. Text Field
              Expanded(
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.characters,
                  textAlignVertical: TextAlignVertical.center,
                  enabled: !_isLoading,
                  decoration: const InputDecoration(
                    hintText: 'XXXX-XXXX-XXXX-XXXX',
                    hintStyle: TextStyle(color: lightTextColor, letterSpacing: 1.5),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 15),
                  ),
                  style: const TextStyle(
                    color: lightTextColor, // White input text
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2.0, // Wider spacing for key visibility
                  ),
                ),
              ),
            ],
          ),
        ),

        // Error Message
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 4.0),
            child: Text(
              _errorMessage!,
              style: const TextStyle(
                color: errorRed,
                fontSize: 13,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isKeyValidLength = _controller.text.replaceAll('-', '').trim().length == 16;
    final bool isButtonEnabled = isKeyValidLength && !_isLoading;

    return Scaffold(
      backgroundColor: Colors.black, // Ensure pure black behind the image/overlay
      body: Stack(
        children: [
          // 1. Dark Forest Background Image
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  // Placeholder image URL, assuming it provides the moody forest look
                  image: AssetImage('assets/images/licensebg.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                // Dark overlay matching the Figma style
                color: Colors.black.withOpacity(0.4),
              ),
            ),
          ),

          // 2. Content (Aligned to the bottom portion)
          SafeArea(
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // --- Header Text Block ---
                      const Text(
                        'Center Owner\nVerification',
                        style: TextStyle(
                          color: lightTextColor,
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Enter your license key to unlock your center's dashboard and connect with campers.",
                        style: TextStyle(
                          color: subtextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 48),

                      // --- License Key Input ---
                      _buildLicenseKeyField(),
                      const SizedBox(height: 32),

                      // --- Validate Key Button ---
                      ElevatedButton(
                        onPressed: isButtonEnabled ? _verifyLicenseKey : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          disabledBackgroundColor: primaryGreen.withOpacity(0.5),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 4,
                          minimumSize: const Size(double.infinity, 56),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : const Text(
                                'Validate Key',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                      ),

                      const SizedBox(height: 24),

                      // --- Help Link ---
                      TextButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                print('Contact support link tapped');
                                // TODO: Implement contact support link/modal
                              },
                        child: Text(
                          "Need help? Contact Support",
                          style: TextStyle(
                            fontSize: 14,
                            color: subtextColor.withOpacity(_isLoading ? 0.8 : 1.0),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20), // Padding at the very bottom
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 3. Back Button (Top Left, Blurred Circle)
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
}
