import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/app_colors/app_colors.dart';
import '../custom_image/custom_image.dart';
import '../custom_text/custom_text.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.height = 54,
    this.width = double.maxFinite,
    required this.onTap,
    this.title = '',
    this.marginVertical = 0,
    this.marginHorizontal = 0,
    this.fillColor = AppColors.white,
    this.textColor = AppColors.black,
    this.isBorder = false,
    this.fontSize,
    this.borderWidth,
    this.borderRadius,
    this.borderColor =AppColors.primary,
    this.showSocialButton = false,
    this.imageSrc,
    this.fontWeight,
  });

  final double height;
  final double? width;
  final Color? fillColor;
  final Color textColor;
  final Color borderColor;
  final VoidCallback? onTap;
  final String title;
  final double marginVertical;
  final double marginHorizontal;
  final bool isBorder;
  final double? fontSize;
  final double? borderWidth;
  final double? borderRadius;
  final bool showSocialButton;
  final String? imageSrc;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 0.0),
        margin: EdgeInsets.symmetric(
            vertical: marginVertical, horizontal: marginHorizontal),
        alignment: Alignment.center,
        height: height,
        width: width,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [AppColors.black, Color(0xff1F2937), Color(0xff4B5563)]),
          border: isBorder
              ? Border.all(color: borderColor, width: borderWidth ?? .05)
              : null,
          borderRadius: BorderRadius.circular(borderRadius ?? 50),
          color: fillColor,
        ),
        child: showSocialButton ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomImage(imageSrc: imageSrc ?? "",imageColor: AppColors.white,),
            CustomText(
              left: 8,
              fontSize: fontSize ?? 16.sp,
              fontWeight: fontWeight ?? FontWeight.w700,
              color: textColor,
              textAlign: TextAlign.center,
              text: title,

            ),
          ],
        ) : CustomText(
          fontSize: fontSize ?? 18.sp,
          fontWeight: FontWeight.w700,
          color: textColor,
          textAlign: TextAlign.center,
          text: title,
        ),
      ),
    );
  }
}
