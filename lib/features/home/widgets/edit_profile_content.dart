import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/primary_button.dart';
import '../../profile/profile_controller.dart';

class EditProfileContent extends GetView<ProfileController> {
  const EditProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Header
            Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => context.pop(),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Edit profile',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 48), // To balance the back button
              ],
            ),
            const SizedBox(height: 30),
            // Glassmorphic Card
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          final imageUrl = controller.profileImageUrl;

                          return Center(
                            child: Stack(
                              children: [
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: imageUrl != null
                                        ? DecorationImage(
                                            image: NetworkImage(imageUrl),
                                            fit: BoxFit.cover,
                                          )
                                        : const DecorationImage(
                                            image: AssetImage(
                                              'assets/images/profile_placeholder.png',
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                    border: Border.all(
                                      color: Colors.white24,
                                      width: 4,
                                    ),
                                  ),
                                  child: imageUrl == null
                                      ? const Icon(
                                          Icons.person,
                                          color: Colors.white,
                                          size: 48,
                                        )
                                      : null,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0D1A2A),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white24,
                                        width: 2,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt_outlined,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        const SizedBox(height: 20),
                        // Input Fields
                        Obx(
                          () => _buildTextField(
                            'Full Name',
                            controller.userProfile.value?.name.isNotEmpty ==
                                    true
                                ? controller.userProfile.value!.name
                                : 'Not available',
                          ),
                        ),
                        const SizedBox(height: 10),
                        Obx(
                          () => _buildTextField(
                            'Email',
                            controller.userProfile.value?.email.isNotEmpty ==
                                    true
                                ? controller.userProfile.value!.email
                                : 'Not available',
                          ),
                        ),
                        const SizedBox(height: 10),
                        Obx(
                          () => _buildTextField(
                            'Phone Number',
                            controller.userProfile.value?.contact?.isNotEmpty ==
                                    true
                                ? controller.userProfile.value!.contact!
                                : 'Not available',
                          ),
                        ),
                        const Spacer(),
                        // Save Button
                        PrimaryButton(
                          text: 'Save',
                          onPressed: () {
                            context.pop();
                          },
                          borderRadius: 12,
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 80), // Space for bottom nav
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          ),
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: GoogleFonts.outfit(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
