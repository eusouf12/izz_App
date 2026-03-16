import 'package:flutter/material.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../../utils/app_icons/app_icons.dart';
import '../../../../components/custom_image/custom_image.dart';
import '../../../../components/custom_text/custom_text.dart';

class CustomBookingCard extends StatelessWidget {
  final String? title;
  final String? icon;
  final VoidCallback? onTap;

  const CustomBookingCard({
    super.key,
    this.title,
    this.icon,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff1F2937), Color(0xff4B5563)],
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            CustomImage(imageSrc: icon ?? AppIcons.edit),
            CustomText(
              left: 8,
              text: title ?? "",
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.white,
            ),
          ],
        ),
      ),
    );
  }
}