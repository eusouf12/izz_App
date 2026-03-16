import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:izz_atlas_app/utils/app_colors/app_colors.dart';
import 'package:izz_atlas_app/utils/app_icons/app_icons.dart';
import 'package:izz_atlas_app/view/components/custom_button/custom_button.dart';
import 'package:izz_atlas_app/view/components/custom_text/custom_text.dart';
import 'package:izz_atlas_app/view/components/custom_text_field/custom_text_field.dart';
import '../../../../core/app_routes/app_routes.dart';
import '../../../../utils/app_images/app_images.dart';
import '../../../components/custom_image/custom_image.dart';

class UserSocialScreen extends StatelessWidget {
  const UserSocialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: "ATLAS",
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
                TextButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.loginScreen);
                  },
                  child: CustomText(
                    text: "Sign In",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
            CustomTextField(
              fillColor: AppColors.white,
              fieldBorderColor: AppColors.greyLight,
              prefixIcon: Icon(Icons.search, color: AppColors.greyLight),
              hintText: "Search",
              hintStyle: TextStyle(color: AppColors.greyLight),
            ),
            CustomText(
              text: "SPORTS",
              fontSize: 18,
              fontWeight: FontWeight.w700,
              top: 16,
            ),
            Stack(
              clipBehavior: Clip.none,
              children: [
                CustomImage(
                  width: MediaQuery.sizeOf(context).width,
                  boxFit: BoxFit.cover,
                  imageSrc: AppImages.sportsImageOne,
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 50,
                  child: Column(
                    children: [
                      CustomText(
                        text: "BE PART OF ATLAS",
                        color: AppColors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        bottom: 6,
                      ),
                      CustomButton(
                        onTap: () {
                          Get.toNamed(AppRoutes.userHomeScreen, arguments: "user",);
                        },
                        title: "Join Now",
                        width: 120,
                        fillColor: Colors.blueAccent,
                        height: 38,
                        textColor: AppColors.white,
                        fontSize: 18,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomImage(imageSrc: AppImages.footballIcon),
                CustomImage(imageSrc: AppImages.tennisIcon),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomImage(imageSrc: AppImages.basketballIcon),
                CustomImage(imageSrc: AppImages.tennisIcon),
              ],
            ),
            GestureDetector(
              onTap: (){
                Get.toNamed(AppRoutes.signUpScreen, arguments: "user",);
              },
              child: Center(
                child: CustomText(
                  top: 20,
                  text: "Sign up to unlock full access",
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  bottom: 20,
                ),
              ),
            ),
            CustomButton(onTap: (){}, title: "Continue with Google",
            showSocialButton: true,
              imageSrc: AppIcons.google,
              isBorder: true,
              borderColor: AppColors.greyLight,
              textColor: AppColors.white,
              borderWidth: 1,
            ),
            SizedBox(height: 10,),
            // CustomButton(onTap: (){}, title: "Continue with Apple",
            //   showSocialButton: true,
            //   imageSrc: AppIcons.apple,
            //   fillColor: AppColors.black,
            //   textColor: AppColors.white,
            // )
          ],
        ),
      ),
    );
  }
}
