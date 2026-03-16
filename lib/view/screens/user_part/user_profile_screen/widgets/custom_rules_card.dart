import 'package:flutter/material.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../../utils/app_icons/app_icons.dart';
import '../../../../components/custom_image/custom_image.dart';
import '../../../../components/custom_text/custom_text.dart';
class CustomRulesCard extends StatelessWidget {
  final String? icons;
  final String? title;
  final String? description;
  const CustomRulesCard({super.key, this.icons, this.title, this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Color(0xFFF111827),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Row(
          children: [
            CustomImage(imageSrc: icons?? AppIcons.eyeImage, height: 40,width: 40,),
            SizedBox(width: 12,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: title ??"Earn XP for Every Action",
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                  bottom: 8,
                ),CustomText(
                  text: description?? "Booking, reviewing, referring friends, and\ncompleting challenges all earn XP.",
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                  maxLines: 3,
                  textAlign: TextAlign.start,

                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
