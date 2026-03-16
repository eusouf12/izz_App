import 'package:flutter/material.dart';
import 'package:izz_atlas_app/utils/app_colors/app_colors.dart';
import 'package:izz_atlas_app/view/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:izz_atlas_app/view/components/custom_text/custom_text.dart';
import 'package:izz_atlas_app/view/screens/vendor_part/vendor_profile_screen/vendor_terms_screen.dart';

class UserTermsScreen extends StatelessWidget {
  const UserTermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return

    VendorTermsScreen();

      Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomRoyelAppbar(
        leftIcon: true,
        titleName: "Terms of Conditions",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20.0),
        child: Column(
          children: [
            CustomText(
              text:
                  "Lorem ipsum dolor sit amet consectetur. Imperdiet iaculis convallis bibendum massa id elementum consectetur neque mauris.",
              fontSize: 14,
              fontWeight: FontWeight.w300,
              maxLines: 10,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );


  }
}
