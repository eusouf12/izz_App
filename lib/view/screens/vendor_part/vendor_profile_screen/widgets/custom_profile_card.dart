import 'package:flutter/material.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../../utils/app_icons/app_icons.dart';
import '../../../../components/custom_image/custom_image.dart';
import '../../../../components/custom_text/custom_text.dart';
class CustomProfileCard extends StatelessWidget {
  final String? nameTitle;
  final Function()? onTap;
const CustomProfileCard({super.key, this.nameTitle, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [
                Color(0xff1F2937),
                Color(0xff4B5563),
              ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: nameTitle ?? "",
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppColors.white,
              ),
              CustomImage(imageSrc: AppIcons.arrowIcon, height: 40,width: 40,)
            ],
          ),
        ),
      ),
    );
  }
}
