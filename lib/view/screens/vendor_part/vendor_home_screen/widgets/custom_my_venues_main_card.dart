import 'package:flutter/material.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../../utils/app_icons/app_icons.dart';
import '../../../../components/custom_image/custom_image.dart';
import '../../../../components/custom_text/custom_text.dart';
import 'custom_booking_card.dart';

class CustomMyVenuesMainCard extends StatelessWidget {
  final String? iconData;
  final String? title;
  final String? subTitle;
  final String? buttonText;

  final VoidCallback? onTapEdit;
  final VoidCallback? onTapAvailability;
  final VoidCallback? onTapDetails;

  const CustomMyVenuesMainCard({
    super.key,
    this.iconData,
    this.title,
    this.subTitle,
    this.buttonText,
    this.onTapEdit,
    this.onTapAvailability,
    this.onTapDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff111827), Color(0xff1F2937)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          CustomImage(imageSrc: iconData ?? AppIcons.venues1),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  left: 0,
                                  text: title ?? "Unknown Venue",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.white,
                                  maxLines: 1,
                                ),
                                CustomText(
                                  left: 0,
                                  text: subTitle ?? "Unknown Location",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textClr,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.amberAccent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: CustomText(
                            text: buttonText ?? "Active",
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black,
                          ),
                        ),
                         ],
                    )
                  ],
                ),
                SizedBox(height: 10,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomBookingCard(
                      title: "Edit",
                      icon: AppIcons.edit,
                      onTap: onTapEdit,
                    ),
                    CustomBookingCard(
                      title: "Availability",
                      icon: AppIcons.calender,
                      onTap: onTapAvailability,
                    ),
                    CustomBookingCard(
                      title: "Details",
                      icon: AppIcons.eyeIcon,
                      onTap: onTapDetails,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}