import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:izz_atlas_app/utils/app_icons/app_icons.dart';
import 'package:izz_atlas_app/view/components/custom_button/custom_button.dart';
import 'package:izz_atlas_app/view/components/custom_image/custom_image.dart';
import '../../../core/app_routes/app_routes.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../components/custom_text/custom_text.dart';
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
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
            padding: EdgeInsets.only(top: 60.0, right: 20.w, left: 20.w,bottom: 40.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomImage(imageSrc: AppIcons.discoverIcon),
                Center(
                  child: CustomText(
                    text: "Discover Sports\nVenues Near You",
                    fontWeight: FontWeight.w700,
                    fontSize: 30.sp,
                    color: AppColors.white,
                  ),
                ),  Center(
                  child: CustomText(
                    text: "Find your perfect court anytime,\nanywhere.",
                    fontWeight: FontWeight.w400,
                    fontSize: 18.sp,
                    color: AppColors.white,
                  ),
                ),
                Spacer(),
                CustomButton(onTap: (){
                  Get.toNamed(AppRoutes.frameScreen);
                },
                  textColor: AppColors.white,
                  fontSize: 16,
                  title: "GET STARTED",)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
