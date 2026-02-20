import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;

  const EditProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _phoneController = TextEditingController();
  final _skillsController = TextEditingController();
  
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.name ?? '';
    _bioController.text = widget.user.bio ?? '';
    _phoneController.text = widget.user.phoneNumber ?? '';
    _skillsController.text = widget.user.skills?.join(', ') ?? '';
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);
    try {
      String? photoUrl = widget.user.photoUrl;

      if (_imageFile != null) {
        photoUrl = await _firestoreService.uploadProfileImage(_imageFile!, widget.user.uid);
      }

      List<String>? skills;
      if (_skillsController.text.isNotEmpty) {
        skills = _skillsController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      }

      final updatedUser = UserModel(
        uid: widget.user.uid,
        email: widget.user.email,
        name: _nameController.text.trim(),
        role: widget.user.role,
        createdAt: widget.user.createdAt,
        photoUrl: photoUrl,
        bio: _bioController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        skills: skills,
      );

      await _firestoreService.updateUser(updatedUser);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated successfully!')));
        Navigator.pop(context, true); // Return true to indicate update
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : (widget.user.photoUrl != null
                            ? NetworkImage(widget.user.photoUrl!)
                            : null) as ImageProvider?,
                    child: (_imageFile == null && widget.user.photoUrl == null)
                        ? const Icon(Icons.person, size: 60, color: Colors.grey)
                        : null,
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            CustomTextField(
              labelText: 'Full Name',
              controller: _nameController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              labelText: 'Bio',
              controller: _bioController,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              labelText: 'Phone Number',
              controller: _phoneController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              labelText: 'Skills (comma separated)',
              controller: _skillsController,
              hintText: 'Flutter, Dart, Firebase...',
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'Save Changes',
              onPressed: _saveProfile,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
