import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:izz_atlas_app/core/app_routes/app_routes.dart';
import 'package:izz_atlas_app/utils/app_colors/app_colors.dart';
import 'package:izz_atlas_app/view/components/custom_button/custom_button.dart';
import 'package:izz_atlas_app/view/components/custom_text/custom_text.dart';

class GuestLoginDialog extends StatelessWidget {
  const GuestLoginDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Icon(
                  Icons.close,
                  color: AppColors.black,
                  size: 24.sp,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Icon(
              Icons.lock_outline,
              size: 60.sp,
              color: AppColors.primary,
            ),
            SizedBox(height: 20.h),
            CustomText(
              text: "Login Required",
              fontSize: 22.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
            SizedBox(height: 10.h),
            CustomText(
              text: "Please login to access this feature.",
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.black_80,
            ),
            SizedBox(height: 30.h),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    onTap: () => Get.back(),
                    title: "Cancel",
                    height: 48.h,
                    fillColor: AppColors.white,
                    textColor: AppColors.black,
                    isBorder: true,
                    borderWidth: 1,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: CustomButton(
                    onTap: () {
                      Get.back();
                      Get.offAllNamed(AppRoutes.loginScreen);
                    },
                    title: "Login",
                    height: 48.h,
                    textColor: AppColors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void showGuestLoginDialog() {
  Get.dialog(
    const GuestLoginDialog(),
    barrierDismissible: true,
  );
}
