import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:izz_atlas_app/core/app_routes/app_routes.dart';
import 'package:izz_atlas_app/utils/app_colors/app_colors.dart';
import 'package:izz_atlas_app/view/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:izz_atlas_app/view/screens/user_part/user_profile_screen/widgets/custom_account_card_list.dart';

class VendorAccountSettings extends StatelessWidget {
  const VendorAccountSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomRoyelAppbar(leftIcon: true, titleName: "Account Settings"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16.0),
        child: Column(
          children: [
            CustomAccountCardList(
              name: "Change Password",
              onTap: () {
                Get.toNamed(AppRoutes.vendorChangePasswordScreen);
              },
            ),
            CustomAccountCardList(
              name: "Terms of Services",
              onTap: () {
                Get.toNamed(AppRoutes.vendorTermsScreen);
              },
            ),
            CustomAccountCardList(name: "Privacy Policy",  onTap: () {
              Get.toNamed(AppRoutes.vendorPrivacyScreen);
            },),
            CustomAccountCardList(name: "About us",  onTap: () {
              Get.toNamed(AppRoutes.vendorAboutUsScreen);
            },),
          ],
        ),
      ),
    );
  }
}
