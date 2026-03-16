import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../utils/ToastMsg/toast_message.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../components/custom_button/custom_button.dart';
import '../../../components/custom_from_card/custom_from_card.dart';
import '../../../components/custom_loader/custom_loader.dart';
import '../../../components/custom_text/custom_text.dart';
import '../controller/auth_controller.dart';

class SetNewPassword extends StatelessWidget {
  SetNewPassword({super.key});

  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    // Retrieve arguments as a Map
    final arguments = Get.arguments as Map<String, dynamic>? ?? {};
    final String userId = arguments['id'] ?? "";
    final String accessToken = arguments['token'] ?? "";

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 80, left: 20, right: 20),
          child: Column(
            children: [
              CustomText(
                text: 'Set New Password',
                fontSize: 24.w,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
                bottom: 10.h,
              ),
              CustomText(
                text: 'Enter your new password below.',
                fontSize: 14.w,
                fontWeight: FontWeight.w500,
                color: AppColors.black_02,
                maxLines: 2,
              ),

              SizedBox(height: 50.h),

              // New Password Field
              CustomFormCard(
                title: 'New Password',
                hintText: "Enter new password",
                maxLine: 1,
                isPassword: true,
                controller: authController.updatePasswordController.value,
              ),

              SizedBox(height: 10.h),

              // Confirm Password Field
              CustomFormCard(
                title: 'Confirm Password',
                hintText: 'Confirm new password',
                maxLine: 1,
                isPassword: true,
                controller: authController.confirmNewPasswordController.value,
              ),

              SizedBox(height: 40.h),

              Obx(() {
                return authController.updatePasswordLoading.value
                    ? const CustomLoader()
                    : CustomButton(
                  onTap: () {
                    final password = authController.updatePasswordController.value.text;
                    final confirmPassword = authController.confirmNewPasswordController.value.text;

                    if (password.isEmpty || confirmPassword.isEmpty) {
                      showCustomSnackBar('Fields cannot be empty', isError: true);
                      return;
                    }

                    if (password != confirmPassword) {
                      showCustomSnackBar('Passwords do not match', isError: true);
                      return;
                    }

                    if (userId.isEmpty || accessToken.isEmpty) {
                      showCustomSnackBar("Session invalid. Please try again.", isError: true);
                      return;
                    }
                    debugPrint("User ID: ================$userId, Token: $accessToken");

                    // Pass ID and Token to Controller
                    authController.resetPassword(userId: userId, token: accessToken);
                  },
                  title: 'RESET PASSWORD',
                  fillColor: AppColors.black,
                  textColor: AppColors.white,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}