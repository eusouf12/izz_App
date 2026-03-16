// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:izz_atlas_app/view/screens/vendor_part/vendor_profile_screen/vendor_profile_screen.dart';

import '../../../core/app_routes/app_routes.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/app_icons/app_icons.dart';
import '../../components/custom_image/custom_image.dart';
import '../../screens/vendor_part/vendor_home_screen/vendor_booking_request_screen.dart';

class VendorNavbar extends StatefulWidget {
  final int? currentIndex;
  const VendorNavbar({this.currentIndex, super.key});

  @override
  State<VendorNavbar> createState() => _VendorNavBarState();
}

class _VendorNavBarState extends State<VendorNavbar> {
  late int bottomNavIndex;

  final List<String> icons = [
    AppIcons.homeIcon,
    AppIcons.calenderIcon,
    AppIcons.personIcon,
  ];

/*  final List<String> userNavText = [
    AppStrings.signUp,
    AppStrings.signUp,
    AppStrings.signUp,
  ];*/

  @override
  void initState() {
    bottomNavIndex = widget.currentIndex ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 80.h,
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
            color: AppColors.black,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10.r),
              topLeft: Radius.circular(10.r),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                icons.length,
                    (index) => InkWell(
                  onTap: () => onTap(index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        icons[index],
                        height: 30.h,
                        width: 30.w,
                        color: bottomNavIndex == index
                            ? AppColors.blue
                            : AppColors.white,
                      ),
                      SizedBox(height: 4.h),
                     /* CustomText(
                        text: userNavText[index],
                        color: bottomNavIndex == index
                            ? AppColors.red
                            : AppColors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                      ),*/
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: -30.h,
          left: 0,
          right: 0,
          child: GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.vendorBookingRequestScreen),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.black, width: 8.w),
              ),
              child: FloatingActionButton(
                onPressed: () => Get.toNamed(AppRoutes.vendorBookingRequestScreen),
                backgroundColor: AppColors.blue,
                shape: CircleBorder(),
                child: CustomImage(
                  imageSrc: AppIcons.calenderIcon,
                  height: 40,
                  width: 40,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void onTap(int index) {
    if (index != bottomNavIndex) {
      setState(() => bottomNavIndex = index);
      switch (index) {
        case 0:
         Get.offAllNamed(AppRoutes.vendorHomeScreen);
          break;
        case 1:
          Get.to(() => VendorBookingRequestScreen());
          break;
        case 2:
          Get.to(() => VendorProfileScreen());
          break;
      }
    }
  }
}