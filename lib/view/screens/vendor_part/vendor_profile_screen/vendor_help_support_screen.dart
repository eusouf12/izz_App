import 'package:flutter/material.dart';
import 'package:izz_atlas_app/utils/app_colors/app_colors.dart';
import 'package:izz_atlas_app/utils/app_images/app_images.dart';
import 'package:izz_atlas_app/view/components/custom_button/custom_button.dart';
import 'package:izz_atlas_app/view/components/custom_from_card/custom_from_card.dart';
import 'package:izz_atlas_app/view/components/custom_image/custom_image.dart';
import 'package:izz_atlas_app/view/components/custom_royel_appbar/custom_royel_appbar.dart';

class VendorHelpSupportScreen extends StatelessWidget {
  const VendorHelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomRoyelAppbar(leftIcon: true, titleName: "Help & Support"),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
             Center(child: CustomImage(imageSrc: AppImages.helpImage)),
            SizedBox(height: 30,),
            CustomFormCard(title: "Title",
                hintText: "Enter the title of your issue",
                controller: TextEditingController()),
            CustomFormCard(title: "Write in bellow box",
                hintText: "Write here...",
                maxLine: 3,
                controller: TextEditingController()),
            SizedBox(height: 30,),
            CustomButton(onTap: (){},title: "SEND",textColor: AppColors.white,),
            SizedBox(height: 10,),
            CustomButton(onTap: (){},title: "LIVE CHAT",textColor: Colors.amberAccent,),
          ],
        ),
      ),
    );
  }
}
