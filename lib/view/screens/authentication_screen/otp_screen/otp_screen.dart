import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:izz_atlas_app/view/components/custom_pin_code/custom_pin_code.dart';
import '../../../../core/app_routes/app_routes.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../components/custom_button/custom_button.dart';
import '../../../components/custom_loader/custom_loader.dart';
import '../../../components/custom_text/custom_text.dart';
import '../controller/auth_controller.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    // Retrieve argument to determine flow (Sign Up or Forgot Password)
    final String screenName = Get.arguments is String ? Get.arguments : "";

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
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
                      child: Column(
                        children: [
                          CustomText(
                            text: "VERIFY OTP",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                            bottom: 10.h,
                          ),
                          CustomText(
                            text: "Enter the code sent to your email.",
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.black_05,
                            maxLines: 2,
                            bottom: 10.h,
                          ),

                          CustomPinCode(controller: authController.otpController.value),

                          SizedBox(height: 20.h),

                          Obx(() {
                            return authController.otpLoading.value
                                ? const CustomLoader()
                                : CustomButton(
                              onTap: () {
                                authController.verifyOtp(screenName: screenName);
                              },
                              title: "VERIFY",
                              fillColor: AppColors.black,
                              textColor: AppColors.white,
                            );
                          }),

                          SizedBox(height: 10.h),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                text: "Didn't receive the code? ",
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black12,
                                bottom: 10.h,
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Call resend API if implemented
                                },
                                child: CustomText(
                                  text: " Resend",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.blue,
                                  bottom: 10.h,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: (){
                              Get.offAllNamed(AppRoutes.loginScreen);
                            },
                            child: CustomText(
                              top: 20,
                              text: "Back to Log In",
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.black.withOpacity(0.3),
                              bottom: 10.h,
                            ),
                          ),
                        ],
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