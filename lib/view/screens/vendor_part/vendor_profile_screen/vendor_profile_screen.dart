import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:izz_atlas_app/core/app_routes/app_routes.dart';
import 'package:izz_atlas_app/utils/app_const/app_const.dart';
import 'package:izz_atlas_app/view/components/custom_nav_bar/vendor_navbar.dart';
import 'package:izz_atlas_app/view/components/custom_netwrok_image/custom_network_image.dart';
import 'package:izz_atlas_app/view/components/custom_text/custom_text.dart';
import 'package:izz_atlas_app/view/screens/user_part/user_profile_screen/widgets/custom_profile_card.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../components/custom_logout_popup/custom_logout_popup.dart';
import 'controller/vendor_profile_controller.dart';

class VendorProfileScreen extends StatelessWidget {
  VendorProfileScreen({super.key});

  final VendorProfileController vendorProfileController = Get.put(VendorProfileController());

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= Dynamic Profile Section =================
              Obx(() {
                final userModel = vendorProfileController.userProfileModel.value;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomNetworkImage(
                      imageUrl: (userModel.photo.isNotEmpty)
                          ? userModel.photo
                          : AppConstants.profileImage,
                      height: 80,
                      width: 80,
                      boxShape: BoxShape.circle,
                      border: Border.all(color: Colors.amberAccent, width: 2),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: CustomText(
                        text: userModel.fullName.isNotEmpty
                            ? userModel.fullName
                            : "Vendor Name",
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                );
              }),
              // =======================================================

              const SizedBox(height: 20),
              //chat
              CustomProfileCard(
                nameTitle: "Chats",
                onTap: () {
                  Get.toNamed(AppRoutes.userMessageListScreen);
                },
              ),
              //Edit Profile =======
              CustomProfileCard(
                nameTitle: "Edit Profile",
                onTap: () {
                  Get.toNamed(AppRoutes.vendorEditProfileScreen);
                },
              ),
              CustomProfileCard(
                nameTitle: "Change Password",
                onTap: () {
                  Get.toNamed(AppRoutes.vendorChangePasswordScreen);
                },
              ),
              CustomProfileCard(
                nameTitle: "Trams of Services",
                onTap: () {
                  Get.toNamed(AppRoutes.vendorTermsScreen);
                },
              ),
              CustomProfileCard(
                nameTitle: "Privacy and Policy",
                onTap: () {
                  Get.toNamed(AppRoutes.vendorPrivacyScreen);
                },
              ),
              CustomProfileCard(
                nameTitle: "About Us",
                onTap: () {
                  Get.toNamed(AppRoutes.vendorAboutUsScreen);
                },
              ),


              /*CustomProfileCard(
                nameTitle: "Help & support",
                onTap: () {
                  Get.toNamed(AppRoutes.vendorHelpSupportScreen);
                },
              ),*/
              //delete
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
                      insetPadding: const EdgeInsets.all(8),
                      contentPadding: const EdgeInsets.all(8),
                      content: SizedBox(
                        width: MediaQuery.sizeOf(context).width,
                        child: CustomShowDialog(
                          textColor: AppColors.black,
                          buttonTextColor: AppColors.white,
                          title: "Logout Your Account",
                          discription: "Are you sure you want to\n Vendor Logout?",
                          showRowButton: true,
                          showCloseButton: true,
                          leftTextButton: "Yes",
                          rightTextButton: "No",
                          leftOnTap: (){
                            Get.offAllNamed(AppRoutes.loginScreen);
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
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
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
      bottomNavigationBar: VendorNavbar(currentIndex: 2),
    );
  }
}