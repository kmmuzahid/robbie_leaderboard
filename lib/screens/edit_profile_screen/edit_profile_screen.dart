import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:get/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_leaderboard/constants/app_icon_path.dart';
import 'package:the_leaderboard/constants/app_image_path.dart';
import 'package:the_leaderboard/screens/edit_profile_screen/controller/edit_profile_controller.dart';
import 'package:the_leaderboard/widgets/icon_widget/icon_widget.dart';
import 'package:the_leaderboard/widgets/image_widget/image_widget.dart';

import '../../constants/app_colors.dart';
import '../../widgets/appbar_widget/appbar_widget.dart';
import '../../widgets/button_widget/button_widget.dart';
import '../../widgets/space_widget/space_widget.dart';
import '../../widgets/text_widget/text_widgets.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _controller = Get.put(EditProfileController());
  // Controllers for text fields
 

  // Variable to store the selected image
  File? _selectedImage;

  // Image picker instance
  final ImagePicker _picker = ImagePicker();

  // Method to pick an image from the gallery
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error picking image: $e")),
      );
    }
  }

  

  // Helper method to build a text field
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          text: label,
          fontColor: AppColors.greyLight,
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
        const SpaceWidget(spaceHeight: 8),
        TextField(
          controller: controller,
          style: const TextStyle(color: AppColors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.blue,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.blueDark,
        appBar: const AppbarWidget(title: ""),
        body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Picture
                Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: _selectedImage != null
                            ? Image.file(
                                _selectedImage!,
                                fit: BoxFit.cover,
                                width: 80,
                                height: 80,
                              )
                            : const ImageWidget(
                                height: 80,
                                width: 80,
                                imagePath: AppImagePath.profileImage,
                              ),
                      ),
                    ),
                    Positioned(
                      bottom: -2,
                      right: -2,
                      child: GestureDetector(
                        onTap: _pickImage, // Call the image picker
                        child: const IconWidget(
                          height: 30,
                          width: 30,
                          icon: AppIconPath.editImageButtonIcon,
                        ),
                      ),
                    ),
                  ],
                ),
                const SpaceWidget(spaceHeight: 24),
                             
                // Username
                _buildTextField(
                  label: "Username",
                  controller: _controller.usernameController,
                ),
                const SpaceWidget(spaceHeight: 12),
                  _buildTextField(
                  label: "Contact",
                  controller: _controller.contactController,
                ),
                const SpaceWidget(spaceHeight: 12),
                  _buildTextField(
                  label: "City",
                  controller: _controller.cityController,
                ),
                const SpaceWidget(spaceHeight: 12),
                  _buildTextField(
                  label: "Gender",
                  controller: _controller.genderController,
                ),
                const SpaceWidget(spaceHeight: 12),
                  _buildTextField(
                  label: "Age",
                  controller: _controller.ageController,
                ),
                const SpaceWidget(spaceHeight: 12),
                  _buildTextField(
                  label: "Role",
                  controller: _controller.roleController,
                ),
                const SpaceWidget(spaceHeight: 12),
                // Instagram Link
                _buildTextField(
                  label: "Instagram Link",
                  controller: _controller.instagramController,
                ),
                const SpaceWidget(spaceHeight: 12),
                // Twitter Link
                _buildTextField(
                  label: "Twitter Link",
                  controller: _controller.twitterController,
                ),
                const SpaceWidget(spaceHeight: 12),
                // Country
                _buildTextField(
                  label: "Country",
                  controller: _controller.countryController,
                ),
                const SpaceWidget(spaceHeight: 24),
                // Save Changes Button
              ],
            ),
          
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: ButtonWidget(
            onPressed: _controller.saveChange,
            label: "Save Changes",
            buttonWidth: double.infinity,
          ),
        ),
      ),
    );
  }
}
