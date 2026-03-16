import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../../utils/app_const/app_const.dart';
import '../../../../components/custom_netwrok_image/custom_network_image.dart';
import '../../../../components/custom_text/custom_text.dart';
class CustomNearbyContainer extends StatelessWidget {
  final String? imageUrl;
  final String? title;
  final Function()? onTap;
  const CustomNearbyContainer({super.key, this.imageUrl, this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Stack(
        children: [
          GestureDetector(
            onTap: onTap,
            child: CustomNetworkImage(
              imageUrl: imageUrl ?? AppConstants.ntrition,
              height: 130.h,
              width: MediaQuery.sizeOf(context).width,
              borderRadius: BorderRadius.circular(13),
            ),
          ),
          Positioned(
            left: 20,
            top: 10,
            child: CustomText(
              text: title ?? "Nearby Venues",
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
