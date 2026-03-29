// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:izz_atlas_app/view/components/custom_guest_login_dialog/custom_guest_login_dialog.dart';
import 'package:izz_atlas_app/view/screens/user_part/my_booking_screen/user_my_bookings_screen.dart';

import '../../../core/app_routes/app_routes.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/app_icons/app_icons.dart';
import '../../components/custom_image/custom_image.dart';
import '../../screens/user_part/user_profile_screen/user_profile_screen.dart';

class Navbar extends StatefulWidget {
  final int? currentIndex;
  final bool isGuest;
  const Navbar({this.currentIndex, this.isGuest = false, super.key});

  @override
  State<Navbar> createState() => _UserNavBarState();
}

class _UserNavBarState extends State<Navbar> {
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
            onTap: () {
              if (widget.isGuest) {
                showGuestLoginDialog();
              } else {
                Get.toNamed(AppRoutes.userMyBookingsScreen);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.black, width: 8.w),
              ),
              child: FloatingActionButton(
                onPressed: () {
                  if (widget.isGuest) {
                    showGuestLoginDialog();
                  } else {
                    Get.toNamed(AppRoutes.userMyBookingsScreen);
                  }
                },
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
      if (widget.isGuest && (index == 1 || index == 2)) {
        showGuestLoginDialog();
        return;
      }
      setState(() => bottomNavIndex = index);
      switch (index) {
        case 0:
          Get.offAllNamed(AppRoutes.userHomeScreen, arguments: widget.isGuest? "guest" : null);
          break;
        case 1:
          Get.to(() => UserMyBookingsScreen());
          break;
        case 2:
          Get.to(() => UserProfileScreen());
          break;
      }
    } else if (widget.isGuest && (index == 1 || index == 2)) {
      showGuestLoginDialog();
    }
  }
}