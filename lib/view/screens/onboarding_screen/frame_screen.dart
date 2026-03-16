import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/app_routes/app_routes.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/app_icons/app_icons.dart';
import '../../components/custom_image/custom_image.dart';
import '../../components/custom_text/custom_text.dart';

class FrameScreen extends StatelessWidget {
  const FrameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.black, Color(0xff111827), Color(0xff1F2937)],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 80.0,
              right: 20.w,
              left: 20.w,
              bottom: 40.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomImage(imageSrc: AppIcons.divIcon),
                Center(
                  child: CustomText(
                    top: 20.h,
                    text: "How do you want to join?",
                    fontWeight: FontWeight.w700,
                    fontSize: 20.sp,
                    color: AppColors.white,
                    bottom: 10.h,
                  ),
                ),
                Center(
                  child: CustomText(
                    text:
                        "Choose to book sports venues as a player, or manage them as a vendor.",
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    maxLines: 2,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: 60),
                GestureDetector(
                  onTap: () {
                    // Get.toNamed(AppRoutes.userHomeScreen);
                    Get.toNamed(AppRoutes.signUpScreen, arguments: "USER");
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xff1F2937), Color(0xff4B5563)],
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      children: [
                        CustomImage(imageSrc: AppIcons.userIcon),
                        SizedBox(width: 16.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: "Join as User",
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                            ),
                            CustomText(
                              text:
                                  "Discover courts, book instantly,\nand play anytime.",
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.white,
                              textAlign: TextAlign.start,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    // Get.toNamed(AppRoutes.vendorHomeScreen);
                    Get.toNamed(AppRoutes.signUpScreen, arguments: "VENDOR");
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xff1F2937), Color(0xff4B5563)],
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      children: [
                        CustomImage(imageSrc: AppIcons.userIcon),
                        SizedBox(width: 16.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: "Join as Vendor",
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                            ),
                            CustomText(
                              text:
                                  "List your venues, manage\nbookings, and grow your\nbusiness.",
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.white,
                              textAlign: TextAlign.start,
                              maxLines: 3,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: "Already have an account?",
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.white,
                    ),
                    TextButton(onPressed: (){
                      Get.toNamed(AppRoutes.loginScreen);
                    }, child: CustomText(
                      text: "Sign In",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueAccent,
                    ),)
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
