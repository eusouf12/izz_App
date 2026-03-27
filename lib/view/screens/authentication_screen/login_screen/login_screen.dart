import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:izz_atlas_app/utils/app_icons/app_icons.dart';
import 'package:izz_atlas_app/view/components/custom_image/custom_image.dart';
import '../../../../core/app_routes/app_routes.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../components/custom_button/custom_button.dart';
import '../../../components/custom_from_card/custom_from_card.dart';
import '../../../components/custom_loader/custom_loader.dart';
import '../../../components/custom_text/custom_text.dart';
import '../controller/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final AuthController authController = Get.put(AuthController());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.sizeOf(context).height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.black,
                    Color(0xff111827),
                    Color(0xff1F2937),
                  ],
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
                  CustomText(
                    text: "ATLAS",
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                    bottom: 80.h,
                  ),
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
                              text: "LOG IN",
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                              bottom: 10.h,
                            ),

                            // Email Field
                            CustomFormCard(
                              title: "EMAIL",
                              hintText: "Enter your email",
                              // Controller connect kora holo
                              controller:
                                  authController.loginEmailController.value,
                              // Validation add kora holo
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Field cannot be empty";
                                }
                                return null;
                              },
                            ),

                            // Password Field
                            CustomFormCard(
                              title: "PASSWORD",
                              hintText: "Enter your password",
                              isPassword: true,
                              // Controller connect kora holo
                              controller:
                                  authController.loginPasswordController.value,
                              // Validation
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Password cannot be empty";
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 20.h),

                            // Login Button with Obx for Loading state
                            Obx(() {
                              return authController.loginLoading.value
                                  ? const Center(
                                      child: CustomLoader(),
                                    ) // Or use CustomLoader()
                                  : CustomButton(
                                      onTap: () {
                                        // Form validation check
                                        if (formKey.currentState!.validate()) {
                                          authController.loginUser();
                                        }
                                      },
                                      title: "LOG IN",
                                      fillColor: AppColors.black,
                                      textColor: AppColors.white,
                                    );
                            }),
                            SizedBox(height: 20.h),

                            // CustomText(
                            //   top: 20,
                            //   text: "CONTINUE WITH",
                            //   fontSize: 14,
                            //   fontWeight: FontWeight.w400,
                            //   color: AppColors.black.withOpacity(0.3), // .withValues replacement
                            //   bottom: 10.h,
                            // ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     CustomImage(
                            //       imageSrc: AppIcons.google,
                            //       height: 40,
                            //       width: 40,
                            //     ),
                            //     SizedBox(width: 26),
                            //     // CustomImage(
                            //     //   imageSrc: AppIcons.apple,
                            //     //   imageColor: AppColors.black,
                            //     //   height: 65,
                            //     //   width: 65,
                            //     // ),
                            //   ],
                            // ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  text: "Didn't have an account yet?",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: const Color.fromARGB(124, 0, 0, 0),
                                  bottom: 10.h,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(AppRoutes.frameScreen);
                                  },
                                  child: CustomText(
                                    text: " Sign Up",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.blue,
                                    bottom: 10.h,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                // Logic ta check kore nio, eta forgot password e jabe
                                Get.toNamed(AppRoutes.forgotScreen);
                              },
                              child: CustomText(
                                top: 20,
                                text: "Forgot Password?",
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.blue,
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
