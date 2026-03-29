import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:izz_atlas_app/view/components/custom_button/custom_button.dart';
import 'package:izz_atlas_app/view/components/custom_from_card/custom_from_card.dart';
import 'package:izz_atlas_app/view/components/custom_loader/custom_loader.dart';
import 'package:izz_atlas_app/view/components/custom_text/custom_text.dart';
import '../../../../core/app_routes/app_routes.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../controller/auth_controller.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final AuthController authController = Get.put(AuthController());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final String loginRole = Get.arguments;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Background Gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.black,
                    Color(0xff111827),
                    Color(0xff1F2937)
                  ],
                ),
              ),
              height: MediaQuery.of(context).size.height, // Ensure full height
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
                  CustomText(
                    text: "ATLAS",
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                    bottom: 10.h,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: MediaQuery.sizeOf(context).width,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      // Added Form Widget here like your second project
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            CustomText(
                              text: "CREATE ACCOUNT",
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                              bottom: 10.h,
                            ),
                            // Name Field
                            CustomFormCard(
                              title: "Full Name",
                              hintText: "Enter your full name",
                              controller: authController.nameController.value,
                              validator: (value) =>
                              value == null || value.isEmpty
                                  ? 'Please enter your full name'
                                  : null,
                            ),
                            // Email/Phone Field
                            CustomFormCard(
                              title: "EMAIL",
                              hintText: "Enter your email",
                              controller: authController.emailController.value,
                              validator: (value) =>
                              value == null || value.isEmpty
                                  ? 'Please enter your email'
                                  : null,
                            ),
                            // Password Field
                            CustomFormCard(
                              title: "Password",
                              hintText: "Enter your password",
                              isPassword: true,
                              controller: authController.passwordController.value,
                              validator: (value) =>
                              value == null || value.isEmpty
                                  ? 'Please enter your password'
                                  : null,
                            ),
                            // Confirm Password Field (With Match Logic)
                            CustomFormCard(
                              title: "Confirm Password",
                              hintText: "Enter your password",
                              isPassword: true,
                              controller: authController.confirmPasswordController.value,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm your password';
                                } else if (value != authController.passwordController.value.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            // Referral Code (Optional)
                            (loginRole == 'USER')?
                              CustomFormCard(
                              title: "Referral Code (Optional)",
                              hintText: "Enter your referral code (optional)",
                              controller: authController.referralController.value,
                              )
                              : const SizedBox.shrink(),
                            SizedBox(height: 10.h),
                            // Sign Up Button
                            Obx(() {
                              return authController.signUpLoading.value
                                  ? const CustomLoader()
                                  : CustomButton(
                                onTap: () {
                                  if (formKey.currentState!.validate()) {
                                    authController.signUp(
                                      role: loginRole
                                    );
                                  }
                                },
                                title: "SIGN UP",
                                fillColor: AppColors.black,
                                textColor: AppColors.white,
                              );
                            }),
                            CustomText(
                              top: 20,
                              text: "SIGN UP WITH",
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.black.withOpacity(0.3),
                              bottom: 10.h,
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.toNamed(AppRoutes.userHomeScreen,arguments: "guest");
                              },
                              child: CustomText(
                                top: 20,
                                text: "CONTINUE AS GUEST",
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.blueAccent,
                                bottom: 10.h,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.toNamed(AppRoutes.loginScreen);
                              },
                              child: CustomText(
                                top: 20,
                                text: "Sign In",
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.blueAccent,
                                bottom: 10.h,
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