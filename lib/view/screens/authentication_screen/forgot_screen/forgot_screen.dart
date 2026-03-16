import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../components/custom_button/custom_button.dart';
import '../../../components/custom_from_card/custom_from_card.dart';
import '../../../components/custom_text/custom_text.dart';
import '../controller/auth_controller.dart';

class ForgotScreen extends StatelessWidget {
  ForgotScreen({super.key});

  final AuthController authController = Get.find<AuthController>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Background Gradient (Same as Login)
            Container(
              height: MediaQuery.sizeOf(context).height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.black, Color(0xff111827), Color(0xff1F2937)],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 80.0,
                right: 16.w,
                left: 16.w,
                bottom: 40.h,
              ),
              child: Column(
                children: [
                  // App Name
                  CustomText(
                    text: "ATLAS",
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                    bottom: 80.h,
                  ),

                  // White Container Form
                  Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.sizeOf(context).width,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            CustomText(
                              text: "FORGOT PASSWORD",
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                              bottom: 10.h,
                            ),

                            // Description Text
                            CustomText(
                              text: "Enter your email to reset your password",
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                              bottom: 20.h,
                            ),

                            // Email Field
                            CustomFormCard(
                              title: "EMAIL ADDRESS",
                              hintText: "Enter your email",
                              controller: authController.forgetPasswordController.value,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Email cannot be empty";
                                }
                                // Optional: Add email regex validation
                                if (!GetUtils.isEmail(value)) {
                                  return "Enter a valid email";
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 20.h),

                            // Send Code Button with Loading
                            Obx(() {
                              return authController.forgetPasswordLoading.value
                                  ? const Center(child: CircularProgressIndicator())
                                  : CustomButton(
                                onTap: () {
                                  if (formKey.currentState!.validate()) {
                                    authController.forgetPassword();
                                  }
                                },
                                title: "SEND CODE",
                                fillColor: AppColors.black,
                                textColor: AppColors.white,
                              );
                            }),

                            SizedBox(height: 20.h),

                            // Back to Login Link
                            GestureDetector(
                              onTap: () {
                                Get.back(); // Or Get.toNamed(AppRoutes.loginScreen);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.arrow_back, size: 16, color: AppColors.black),
                                  SizedBox(width: 5),
                                  CustomText(
                                    text: "Back to Login",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.black,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}