import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:http/http.dart';
import '../../../../config/routes/app_routes.dart';
import 'package:campify/GeneratedServices/api.dart';

// --- API Client Initialization ---
final ApiClient _apiClient = ApiClient();
final AdmLicenseControllerApi licenseApi = AdmLicenseControllerApi(_apiClient);

// --- Color Palette based on the Figma/HTML snippet ---
const Color primaryGreen = Color(0xFF2C5F2D);
const Color lightTextColor = Colors.white;
const Color subtextColor = Color(0xFFE0E0E0);
const Color errorRed = Color(0xFFC84B31);
const Color inputFillColor = Colors.white10;
const Color inputBorderColor = Colors.white24;
const Color darkTextColor = Color(0xFF102213); // Near black text

// Define UUID constants
const int uuidRawLength = 32; // 32 characters (hex digits)
const int uuidFormattedLength = 36; // 32 characters + 4 dashes

class LicenseVerificationPage extends StatefulWidget {
  const LicenseVerificationPage({super.key});

  @override
  State<LicenseVerificationPage> createState() => _LicenseVerificationPageState();
}

class _LicenseVerificationPageState extends State<LicenseVerificationPage> {
  // State variables for form management and validation
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();

  String? _errorMessage;
  bool _isLoading = false;

  // Regex to check if the raw key is valid hex characters (0-9, a-f)
  final RegExp _hexRegex = RegExp(r'^[0-9A-F]+$');

  @override
  void initState() {
    super.initState();
    _controller.addListener(_validateKeyOnChange);
  }

  @override
  void dispose() {
    _controller.removeListener(_validateKeyOnChange);
    _controller.dispose();
    super.dispose();
  }

  // Input formatter that adds dashes to the UUID: 8-4-4-4-12
  String _formatKey(String text) {
    String rawText = text.toUpperCase().replaceAll('-', '');
    final StringBuffer buffer = StringBuffer();
    final List<int> groups = [8, 12, 16, 20]; // Dash positions relative to raw index

    for (int i = 0; i < rawText.length; i++) {
      buffer.write(rawText[i]);
      if (groups.contains(i + 1) && i + 1 < uuidRawLength) {
        buffer.write('-');
      }
    }
    return buffer.toString();
  }

  // Validation logic and input cleaning/formatting
  void _validateKeyOnChange() {
    String rawKey = _controller.text.replaceAll('-', '').trim();

    // 1. Enforce max length of 32 raw characters
    if (rawKey.length > uuidRawLength) {
      rawKey = rawKey.substring(0, uuidRawLength);
    }

    // Ensure only valid hexadecimal characters are kept (optional, but good practice)
    rawKey = rawKey.replaceAll(RegExp(r'[^0-9A-Fa-f]'), '');

    // 2. Format the input text (add dashes)
    final formattedText = _formatKey(rawKey);

    // Check if re-formatting is needed to maintain structure/cursor position
    if (formattedText != _controller.text) {
      // Logic to maintain cursor position
      int rawCursorIndex = _controller.text.substring(0, _controller.selection.start).replaceAll('-', '').length;

      int newCursorIndex = 0;
      int dashCount = 0;
      final List<int> dashGroups = [8, 4, 4, 4, 12];

      int currentRawCount = 0;
      for (int groupSize in dashGroups) {
        if (rawCursorIndex > currentRawCount) {
          int countInGroup = rawCursorIndex - currentRawCount;
          newCursorIndex += countInGroup;
          currentRawCount += countInGroup;

          if (currentRawCount < rawCursorIndex) {
            dashCount++;
            newCursorIndex++;
          }
        }
      }

      // Fallback for edge cases, usually should rely on logic above
      if (newCursorIndex > formattedText.length) newCursorIndex = formattedText.length;

      // Apply new formatted value and cursor position
      _controller.value = _controller.value.copyWith(
        text: formattedText,
        selection: TextSelection.collapsed(offset: newCursorIndex),
      );
    }

    // 3. Clear/set error state based on length
    if (_errorMessage != null && rawKey.length == uuidRawLength) {
      setState(() {
        _errorMessage = null;
      });
    }
  }

  // --- API INTEGRATION LOGIC ---
  Future<void> _verifyLicenseKey() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null; // Clear previous errors
    });

    try {
      // ** 1. Call the generated service method **
      // The API call uses the raw 32-character key if the API expects it without dashes

      final license = _licenseController.text;
      final LicenseCheckResponse? response = await licenseApi.checkLicenseStatus(license);

      if (!mounted) return;

      // ** 2. Handle Successful API Call (HTTP 200) **
      if (response != null && response.valid == true) {
        // License is VALID
        if (mounted) {
          // Navigate to the Owner Sign Up page
          Navigator.of(context).pushReplacementNamed(AppRoutes.login);
        }
      } else {
        // License is INVALID
        setState(() {
          _errorMessage = response?.message ?? 'The license key is invalid or has expired. Please check and try again.';
        });
      }
    } on ApiException catch (e) {
      // ** 3. Handle API Errors (e.g., HTTP 4xx, 5xx status codes) **
      setState(() {
        _errorMessage = 'Verification failed (Status ${e.code}). Please check your key or network connection.';
      });
    } catch (e) {
      // ** 4. Handle General Errors (e.g., network timeout, unexpected parsing errors) **
      setState(() {
        _errorMessage = 'An unexpected error occurred during verification. Check your network connection.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Helper widget to build the custom license key input field
// Helper widget to build the custom license key input field
  Widget _buildLicenseKeyField() {
    final bool hasError = _errorMessage != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label... (omitted for brevity)
        const Text(
          'License Key (UUID)',
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
                  // Keep this for vertical alignment
                  textAlignVertical: TextAlignVertical.center,
                  enabled: !_isLoading,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(uuidFormattedLength),
                  ],
                  decoration: const InputDecoration(
                    hintText: 'XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX',
                    hintStyle: TextStyle(color: lightTextColor, letterSpacing: 1.5),
                    border: InputBorder.none,
                    // --- CORRECTION 1: Adjust contentPadding ---
                    // Use symmetric vertical padding to center the text manually
                    // while maintaining the Row's alignment.
                    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                  ),
                  style: const TextStyle(
                    color: lightTextColor, // White input text
                    // --- CORRECTION 2: Set readable fontSize ---
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5, // Reduced letterSpacing slightly for UUID length
                  ),
                ),
              ),
            ],
          ),
        ),

        // Error Message... (omitted for brevity)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Check against the raw length (32) for button enablement
    final bool isKeyValidLength = _controller.text.replaceAll('-', '').trim().length == uuidRawLength;
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
                      _buildTextField(
                        controller: _licenseController, // Linked
                        label: 'Password',
                        hint: 'Enter your password',
                        icon: Icons.key,
                        isPassword: false,
                      ),

                      // _buildLicenseKeyField(),
                      const SizedBox(height: 32),

                      // --- Validate Key Button ---
                      ElevatedButton(
                        onPressed: _verifyLicenseKey,
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
                      const SizedBox(height: 24),

                      // --- Help Link ---
                      TextButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                // TODO: Implement contact support link/modal navigation
                                print('Contact support link tapped');
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
}
