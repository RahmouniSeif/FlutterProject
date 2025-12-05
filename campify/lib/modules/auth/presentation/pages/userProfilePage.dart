import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:campify/GeneratedServices/api.dart'; // Assumed import
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/globals.dart'; // Assumed import
import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
// =========================================================================
// COLOR PALETTE (Unchanged)
// =========================================================================

class AppColors {
  static const Color primary = Color(0xFF2C5F2D);
  static const Color accent = Color(0xFFFF7B54);
  static const Color backgroundLight = Color(0xFFF2F2F7);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF111811);
  static const Color textSecondaryLight = Color(0xFF618961);
  static const Color borderLight = Color(0xFFdbe6db);
}

// =========================================================================
// USER PROFILE PAGE (Refactored for inline editing)
// =========================================================================

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final _formKey = GlobalKey<FormState>();
  User? _user;
  Attachment? _attachment;
  bool _isLoading = true;
  String? _error;
  bool _isEditing = false; // New state to toggle edit mode
  var _image = null;

  // Controllers for editable fields
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString('userId');

      if (userId == null) {
        throw Exception('User ID not found in local storage.');
      }
      final apiClient = await primeHeaders();
      final userControllerApi = UserManagementApi(apiClient);
      final attachementControllerApi = AttachmentControllerApi(apiClient);

      final Attachment? attachment = await attachementControllerApi.getAttachmentByUserIdAndAttachmentType(userId, "profile");
      final User? fetchedUser = await userControllerApi.getUserById(userId);

      if (mounted) {
        setState(() {
          _user = fetchedUser;
          _attachment = attachment;
          // Set controller values upon loading/refresh
          _nameController.text = _user?.name ?? '';
          _emailController.text = _user?.email ?? '';
          _phoneController.text = _user?.phone ?? '';

          _isLoading = false;
          if (_user == null) {
            _error = 'User data not found for ID: $userId';
          }
        });
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = 'API Error ${e.code}: Failed to load profile.';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = 'An unexpected error occurred.';
        });
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Check if data is actually changed before calling API
    if (_user?.name == _nameController.text && _user?.email == _emailController.text && _user?.phone == _phoneController.text) {
      setState(() {
        _isEditing = false;
      });
      return;
    }

    setState(() {
      _isEditing = false; // Disable editing mode immediately
      _isLoading = true; // Show loading spinner
    });

    if (_user?.userId == null) {
      setState(() {
        _isLoading = false;
        _error = 'Cannot save: User ID is missing.';
      });
      return;
    }

    try {
      final apiClient = await primeHeaders();
      final userControllerApi = UserManagementApi(apiClient);
      _user?.name = _nameController.text ?? '';
      _user?.email = _emailController.text ?? '';
      _user?.phone = _phoneController.text ?? '';

      final updatedUser = await userControllerApi.updateUser(_user!.userId!, _user!);

      if (mounted) {
        setState(() {
          _user = updatedUser; // Update the local state
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: AppColors.primary,
        ));
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isEditing = true; // Re-enable editing on failure
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('API Error ${e.code}: Failed to update profile.'),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isEditing = true; // Re-enable editing on failure
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('An unexpected error occurred while saving.'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          // Conditional Content (Loading/Error/Data)
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          else if (_error != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_error!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red, fontSize: 16)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadUserProfile,
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                      child: const Text('Reload Profile'),
                    )
                  ],
                ),
              ),
            )
          else
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Form(
                // Form widget added here
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileHeader(user: _user!, attachment: _attachment!),
                    const SizedBox(height: 8),
                    _buildSectionTitle('Personal Information'),
                    _buildPersonalInformationCard(), // Use new inline fields
                  ],
                ),
              ),
            ),

          // Action Button is positioned at the bottom
          if (!_isLoading && _error == null)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: AppColors.backgroundLight,
                padding: const EdgeInsets.only(bottom: 16.0), // Padding applied once to the bottom
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Edit/Editing Mode Active Button
                    ActionButton(
                      isEditing: _isEditing,
                      onPressed: () {
                        setState(() {
                          _isEditing = !_isEditing;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surfaceLight,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimaryLight, size: 24),
        ),
      ),
      title: Text(_isEditing ? 'Edit Profile' : 'User Profile', style: const TextStyle(color: AppColors.textPrimaryLight, fontSize: 18, fontWeight: FontWeight.bold)),
      centerTitle: true,
      actions: [
        if (_isEditing)
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: _saveProfile,
              child: const Text('Save', style: TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          )
        else
          // Placeholder to keep the layout clean when not editing
          const SizedBox(width: 48),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
      child: Text(title, style: const TextStyle(color: AppColors.textPrimaryLight, fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  // Refactored to build the information card with editable fields
  Widget _buildPersonalInformationCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        color: AppColors.surfaceLight,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Column(
          children: [
            _buildInfoField('Full Name', _nameController, isEditable: _isEditing, validator: (v) => v!.isEmpty ? 'Name is required' : null),
            const Divider(color: AppColors.borderLight, height: 1, indent: 16),
            _buildInfoField('Email Address', _emailController, isEditable: _isEditing, keyboardType: TextInputType.emailAddress, validator: (v) => v!.contains('@') ? null : 'Enter a valid email'),
            const Divider(color: AppColors.borderLight, height: 1, indent: 16),
            _buildInfoField('Phone Number', _phoneController, isEditable: _isEditing, keyboardType: TextInputType.phone, showDivider: false, validator: (v) => v!.length < 8 ? 'Enter a valid phone' : null),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoField(String label, TextEditingController controller, {bool isEditable = false, TextInputType keyboardType = TextInputType.text, bool showDivider = true, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textSecondaryLight)),
          const SizedBox(height: 4),
          TextFormField(
            controller: controller,
            readOnly: !isEditable,
            keyboardType: keyboardType,
            validator: isEditable ? validator : null,
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              // Highlight only in edit mode
              errorStyle: isEditable ? const TextStyle(color: Colors.red, fontSize: 12) : const TextStyle(height: 0, fontSize: 0),
            ),
            style: const TextStyle(fontSize: 16, color: AppColors.textPrimaryLight, fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }
}

// =========================================================================
// SUB-WIDGETS (Updated ActionButton for simplicity)
// =========================================================================

class ProfileHeader extends StatefulWidget {
  final User user;
  final Attachment? attachment;

  const ProfileHeader({super.key, required this.user, this.attachment});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  String? base64Image;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.attachment != null) {
      base64Image = widget.attachment?.attachedFile; // initialize with existing image
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                SafeAvatar(base64Image: base64Image),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: _showImageSourceBottomSheet,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.edit, color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Text(
              widget.user.name ?? 'Guest User',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimaryLight),
            ),
          ],
        ),
      ),
    );
  }

  void _showImageSourceBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 50,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library, color: Colors.green),
                  title: const Text('Choose from Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt, color: Colors.blue),
                  title: const Text('Take Photo'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source, imageQuality: 80);
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        base64Image = base64Encode(bytes);
        widget.attachment?.attachedFile = base64Image;
        final apiClient = await primeHeaders();
        final attachementControllerApi = AttachmentControllerApi(apiClient);
        var res = await attachementControllerApi.updateAttachment(widget.attachment!.id!, widget.attachment!);
        if (res != null) {
          setState(() {
            base64Image = base64Encode(bytes); // store image as Base64
          });
        }
        setState(() {
          base64Image = base64Encode(bytes); // store image as Base64
        });

        // TODO: send base64Image to backend to save
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }
}

class ActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isEditing;
  const ActionButton({super.key, required this.onPressed, required this.isEditing});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(color: AppColors.backgroundLight),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEditing ? Colors.grey : AppColors.primary,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: Text(isEditing ? 'Editing Mode Active' : 'Edit Profile', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  final VoidCallback onPressed;
  const LogoutButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade700, // Distinct color for Logout
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          elevation: 0,
        ),
        child: const Text('Logout', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class SafeAvatar extends StatelessWidget {
  final String? base64Image; // can be null or empty

  const SafeAvatar({this.base64Image, super.key});

  @override
  Widget build(BuildContext context) {
    ImageProvider avatarImage;

    if (base64Image != null && base64Image!.isNotEmpty) {
      try {
        // Remove data URI prefix if present
        final base64Str = base64Image!.contains(',') ? base64Image!.split(',').last : base64Image!;

        // Decode Base64
        Uint8List imageBytes = base64Decode(base64Str);

        avatarImage = MemoryImage(imageBytes);
      } catch (e) {
        // If decoding fails, fallback to default avatar
        avatarImage = const NetworkImage(
          'https://lh3.googleusercontent.com/aida-public/AB6AXuD00w5y3hHAx5wGgMsTX2yEVcGH-VfD982dn8d9L5-etwPUjv0YQn59pIhmgf_Gfg0su18ObcHnEEo4n5csQ9sQDO8Wg0IF_cCAIO6hTtpLd-vJ-hKe-o-FysAH_YgoqVhAe1sUZrb2Y8nPAu7GfIaT3UGQrNOr8qU-sp72PRo_Ct-g3f4-M_NIEQDvv8_O9dkwhwCkpfWEIlmCNoBLxbn9PJadknGjpxkeC_yPJGTvIWrJklKS-rbxgL5Go3bNFTXnPOUCW5eFROS6',
        );
      }
    } else {
      // Null or empty: use default avatar
      avatarImage = const NetworkImage(
        'https://lh3.googleusercontent.com/aida-public/AB6AXuD00w5y3hHAx5wGgMsTX2yEVcGH-VfD982dn8d9L5-etwPUjv0YQn59pIhmgf_Gfg0su18ObcHnEEo4n5csQ9sQDO8Wg0IF_cCAIO6hTtpLd-vJ-hKe-o-FysAH_YgoqVhAe1sUZrb2Y8nPAu7GfIaT3UGQrNOr8qU-sp72PRo_Ct-g3f4-M_NIEQDvv8_O9dkwhwCkpfWEIlmCNoBLxbn9PJadknGjpxkeC_yPJGTvIWrJklKS-rbxgL5Go3bNFTXnPOUCW5eFROS6',
      );
    }

    return CircleAvatar(
      radius: 64,
      backgroundImage: avatarImage,
      backgroundColor: Colors.grey[200], // fallback background
    );
  }
}
