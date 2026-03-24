import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:izz_atlas_app/core/app_routes/app_routes.dart';
import 'package:izz_atlas_app/utils/app_const/app_const.dart';
import 'package:izz_atlas_app/utils/app_icons/app_icons.dart';
import 'package:izz_atlas_app/view/components/custom_image/custom_image.dart';
import 'package:izz_atlas_app/view/components/custom_nav_bar/navbar.dart';
import 'package:izz_atlas_app/view/components/custom_netwrok_image/custom_network_image.dart';
import 'package:izz_atlas_app/view/components/custom_text/custom_text.dart';
import 'package:izz_atlas_app/view/screens/user_part/user_profile_screen/widgets/custom_profile_card.dart';

import '../../../../helper/shared_prefe/shared_prefe.dart';
import '../../../../utils/app_colors/app_colors.dart';
import 'controller/user_gamification_profile_controller.dart';
import '../../../components/custom_logout_popup/custom_logout_popup.dart';
import '../../vendor_part/vendor_profile_screen/controller/vendor_profile_controller.dart';

class UserProfileScreen extends StatelessWidget {
  UserProfileScreen({super.key});

  final VendorProfileController vendorProfileController = Get.put(VendorProfileController());
  final UserGamificationController gamificationController = Get.put(UserGamificationController());

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      vendorProfileController.getUserProfile();
    });

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 60.0),
          child: Column(
            children: [
              //header
              Row(
                children: [
                  Obx(() {
                    final userModel = vendorProfileController.userProfileModel.value;
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CustomNetworkImage(
                          imageUrl: (userModel.photo.isNotEmpty) ? userModel.photo : AppConstants.profileImage,
                          height: 80,
                          width: 80,
                          boxShape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.amberAccent,
                            width: 2,
                          ),
                        ),
                        Positioned(
                          bottom: -10,
                          right: -16,
                          child: CustomImage(
                            imageSrc: AppIcons.powerIcon,
                          ),
                        ),
                      ],
                    );
                  }),

                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() {
                        final userModel = vendorProfileController.userProfileModel.value;
                        return  CustomText(left: 8, text: userModel.fullName.isNotEmpty ? userModel.fullName : "", fontWeight: FontWeight.w600, fontSize: 20, maxLines: 1, overflow: TextOverflow.ellipsis,);
                      }),
                      Obx(() {
                        final gData = gamificationController.gamificationModel.value?.data;
                        return Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xff1F2937), Color(0xff4B5563)],
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: CustomText(
                                text: gData != null ? "Level ${gData.currentLevel}" : "Level -",
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.amberAccent,
                              ),
                            ),
                            CustomText(
                              left: 12,
                              text: gData?.levelTitle ?? "",
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black45,
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              //progressbar
              Obx(() {
                final gData = gamificationController.gamificationModel.value?.data;
                final double progress = (gData == null || gData.nextLevelXP == 0) ? 0 : (gData.currentXP / gData.nextLevelXP).clamp(0.0, 1.0);
                return Column(
                  children: [
                    LinearProgressIndicator(
                      value: progress,
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(20),
                      backgroundColor: AppColors.greyLight,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.black),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: gData != null
                              ? "XP: ${gData.currentXP} / ${gData.nextLevelXP} to Level ${gData.currentLevel + 1}"
                              : "XP: - / -",
                          fontSize: 14.w,
                          fontWeight: FontWeight.w400,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.userCollectScreen);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.amberAccent,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: CustomText(
                              text: "Collect",
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
              SizedBox(height: 20),
              //Chats
              CustomProfileCard(
                nameTitle: "Chats",
                onTap: () {
                  Get.toNamed(AppRoutes.userMessageListScreen);
                },
              ),
              CustomProfileCard(
                nameTitle: "Edit Profile",
                onTap: () {
                  Get.toNamed(AppRoutes.userEditProfileScreen);
                },
              ),
              //Change Password
              CustomProfileCard(
                nameTitle: "Change Password",
                onTap: () {
                  Get.toNamed(AppRoutes.userChangePasswordScreen);
                },
              ),
              //Terms
              CustomProfileCard(
                nameTitle: "Terms & Conditions",
                onTap: () {
                  Get.toNamed(AppRoutes.userTermsScreen);
                },
              ),
              //Privacy
              CustomProfileCard(
                nameTitle: "Privacy Policy",
                onTap: () {
                Get.toNamed(AppRoutes.userPrivacyScreen);
              },
              ),
              //About
              CustomProfileCard(
                nameTitle: "About Us",
                onTap: () {
                Get.toNamed(AppRoutes.userAboutUsScreen);
              },
              ),
              //delete account
              CustomProfileCard(
                  nameTitle: "Delete Account",
                  onTap: () {
                    showDialog(
                      context: context,
                      builder:
                          (ctx) =>
                          AlertDialog(
                            backgroundColor: AppColors.white,
                            insetPadding: EdgeInsets.all(8),
                            contentPadding: EdgeInsets.all(8),
                            content: SizedBox(
                              width: MediaQuery.sizeOf(context).width,
                              child: CustomShowDialog(
                                textColor: AppColors.black,
                                title: "Delete Your Account",
                                discription: "Are You Sure Delete Your Account",
                                showColumnButton: true,
                                showCloseButton: true,
                                rightOnTap: () {
                                  Get.back();
                                },
                                leftOnTap: () async {
                                  vendorProfileController.deleteAccount(userId:  vendorProfileController.userProfileModel.value.id);
                                 // Get.offAllNamed(AppRoutes.loginScreen);
                                },
                              ),
                            ),
                          ),
                    );
                  }
              ),
              //logout
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: AppColors.white,
                      insetPadding: EdgeInsets.all(8),
                      contentPadding: EdgeInsets.all(8),
                      content: SizedBox(
                        width: MediaQuery.sizeOf(context).width,
                        child: CustomShowDialog(
                          textColor: AppColors.black,
                          buttonTextColor: AppColors.white,
                          title: "Logout Your Account",
                          discription:
                          "Are you sure you want to\nUser Logout",
                          showRowButton: true,
                          showCloseButton: true,
                          leftTextButton: "Yes",
                          rightTextButton: "No",
                          leftOnTap: (){
                            Get.toNamed(AppRoutes.frameScreen);
                          },
                          rightOnTap: () {
                            Get.back();
                          },
                        ),
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 0,
                  color: Colors.transparent,
                  child: Container(
                    width: MediaQuery.sizeOf(context).width,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [Color(0xffEF4444), Color(0xff1E1E1E)],
                      ),
                    ),
                    child: Row(
                      children: [
                        CustomText(
                          text: "Logout",
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Navbar(currentIndex: 2),
    );
  }
}
