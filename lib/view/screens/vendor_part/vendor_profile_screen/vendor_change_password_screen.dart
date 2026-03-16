import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:izz_atlas_app/utils/app_colors/app_colors.dart';
import 'package:izz_atlas_app/view/components/custom_button/custom_button.dart';
import 'package:izz_atlas_app/view/components/custom_from_card/custom_from_card.dart';
import 'package:izz_atlas_app/view/components/custom_loader/custom_loader.dart';
import 'package:izz_atlas_app/view/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'controller/vendor_profile_controller.dart';

class VendorChangePasswordScreen extends StatelessWidget {
  VendorChangePasswordScreen({super.key});

  final VendorProfileController controller = Get.put(VendorProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomRoyelAppbar(leftIcon: true, titleName: "Change Password"),
      body: Obx(() {
        return controller.updatePasswordLoading.value
            ? const Center(child: CustomLoader())
            : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40.0),
          child: Column(
            children: [
              CustomFormCard(
                title: "Old Password",
                isPassword: true,
                controller: controller.oldPasswordController.value,
              ),
              CustomFormCard(
                title: "New Password",
                isPassword: true,
                controller: controller.newPasswordController.value,
              ),
              CustomFormCard(
                title: "Confirm New Password",
                isPassword: true,
                controller: controller.confirmPasswordController.value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Confirm password is required";
                  } else if (value != controller.newPasswordController.value.text) {
                    return "Passwords do not match";
                  }
                  return null;
                },
              ),
              const Spacer(),
              CustomButton(
                onTap: () {
                  debugPrint("This is button");
                  controller.changePassword();
                },
                title: "UPDATE PASSWORD",
                textColor: AppColors.white,
              ),
            ],
          ),
        );
      }),
    );
  }
}
