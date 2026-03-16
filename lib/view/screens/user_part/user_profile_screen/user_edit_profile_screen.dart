import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:izz_atlas_app/view/screens/vendor_part/vendor_profile_screen/vendor_edit_profile_screen.dart';

import 'controller/user_profile_controller.dart';
class UserEditProfileScreen extends StatelessWidget {
   UserEditProfileScreen({super.key});
  final userProfileController = Get.put(UserProfileController);
  @override
  Widget build(BuildContext context) {
    return

        VendorEditProfileScreen();


      /*Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomRoyelAppbar(leftIcon: true,titleName: "Edit Profile",),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  Obx(() {
                    if (userProfileController.selectedImage.value != null) {
                      return Container(
                        height: 100.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: FileImage(userProfileController.selectedImage.value!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    } else {
                      return CustomNetworkImage(
                        imageUrl: AppConstants.profileImage,
                        height: 100.h,
                        width: 100.w,
                        boxShape: BoxShape.circle,
                      );
                    }
                  }),
                  Positioned(
                    bottom: 5,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        userProfileController.pickImageFromGallery();
                      },
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: AppColors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 18,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            CustomFormCard(
                title: "Name",
                hintText: "Mehedi Hassan",
                controller: TextEditingController()),
            CustomFormCard(
                title: "Email",
                hintText: "mehedi@gmail.com",
                controller: TextEditingController()),
            CustomFormCard(
                title: "Date of Birth",
                hintText: "12/09/2025",
                controller: TextEditingController()),
            CustomFormCard(
                title: "Country",
                hintText: "Mexico",
                controller: TextEditingController()),
            CustomFormCard(
                title: "Phone Number",
                hintText: "01518602063",
                controller: TextEditingController()),
            SizedBox(height: 30),
            CustomButton(onTap: (){},title: "SAVE",textColor: AppColors.white,)

          ],
        ),
      ),
    );*/
  }
}
