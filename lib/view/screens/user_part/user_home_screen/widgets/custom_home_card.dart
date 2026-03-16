import 'package:flutter/material.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../components/custom_image/custom_image.dart';
import '../../../../components/custom_text/custom_text.dart';
class CustomHomeCard extends StatelessWidget {
  final Function()? onTap;
  final String? imagesrc;
  final String? name;
  const CustomHomeCard({super.key, this.onTap, this.imagesrc, this.name});

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 6.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            gradient: LinearGradient(
              colors: [Color(0xff1F2937), Color(0xff4B5563)],
            ),
          ),
          child: Column(
            children: [
              CustomImage(
                imageSrc: imagesrc?? "",
                height: 30,
                width: 30,
              ),
              CustomText(
                top: 8,
                text: name ??"",
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
