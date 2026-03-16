import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:izz_atlas_app/utils/app_colors/app_colors.dart';
import 'package:izz_atlas_app/view/components/custom_button/custom_button.dart';
import 'package:izz_atlas_app/view/components/custom_from_card/custom_from_card.dart';
import 'package:izz_atlas_app/view/components/custom_loader/custom_loader.dart';
import 'package:izz_atlas_app/view/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:izz_atlas_app/view/components/custom_netwrok_image/custom_network_image.dart';
import 'controller/vendor_profile_controller.dart';

class VendorEditProfileScreen extends StatelessWidget {
  VendorEditProfileScreen({super.key});

  final VendorProfileController controller =
  Get.put(VendorProfileController());

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getUserProfile();
    });

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomRoyelAppbar(
        leftIcon: true,
        titleName: "Edit Profile",
      ),

      /// ================== BODY ==================
      body: Obx(() {
        if (controller.isProfileLoading.value) {
          return const Center(child: CustomLoader());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              // ================== Image Section ==================
              Center(
                child: Stack(
                  children: [
                    Container(
                      height: 100.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
                      child: Obx(
                            () => controller.selectedImage.value != null
                            ? ClipOval(
                          child: Image.file(
                            controller.selectedImage.value!,
                            height: 100.h,
                            width: 100.w,
                            fit: BoxFit.cover,
                          ),
                        )
                            : CustomNetworkImage(
                          imageUrl:
                          controller.userProfileModel.value.photo,
                          height: 100.h,
                          width: 100.w,
                          boxShape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 5,
                      right: 0,
                      child: GestureDetector(
                        onTap: controller.pickImageFromGallery,
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: const BoxDecoration(
                            color: AppColors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 18,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ================== Form Fields ==================
              CustomFormCard(
                title: "Full Name",
                hintText: "Enter your full name",
                controller: controller.nameController.value,
              ),

              CustomFormCard(
                title: "Email",
                hintText: "email@example.com",
                readOnly: true,
                controller: controller.emailController.value,
              ),

              CustomFormCard(
                title: "Country",
                hintText: "Enter your country",
                controller: controller.countryController.value,
              ),

              CustomFormCard(
                title: "Phone Number",
                hintText: "Enter phone number",
                controller: controller.phoneController.value,
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 80),
            ],
          ),
        );
      }),

      /// ================== BOTTOM FIXED SAVE BUTTON ==================
      bottomNavigationBar: Obx(
            () => Padding(
          padding: const EdgeInsets.all(20),
          child: controller.updateProfileLoading.value
              ? const CustomLoader()
              : CustomButton(
            onTap: controller.updateProfile,
            title: "SAVE CHANGES",
            textColor: AppColors.white,
            fillColor: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
