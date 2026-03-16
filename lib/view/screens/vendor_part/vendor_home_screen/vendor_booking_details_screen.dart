import 'package:flutter/material.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../utils/app_const/app_const.dart';
import '../../../../utils/app_icons/app_icons.dart';
import '../../../components/custom_image/custom_image.dart';
import '../../../components/custom_netwrok_image/custom_network_image.dart';
import '../../../components/custom_royel_appbar/custom_royel_appbar.dart';
import '../../../components/custom_text/custom_text.dart';

class VendorBookingDetailsScreen extends StatelessWidget {
  const VendorBookingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomRoyelAppbar(leftIcon: true, titleName: "Booking Details"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff111827), Color(0xff1F2937)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomNetworkImage(
                            imageUrl: AppConstants.profileImage,
                            height: 80,
                            width: 80,
                            boxShape: BoxShape.circle,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                left: 8,
                                text: "Mehedi Bin Ab. Salam",
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.white,
                              ),
                              CustomText(
                                left: 8,
                                text: "Tennis Court Booking",
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textClr,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amberAccent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: CustomText(
                          text: "Pending",
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: "Date",
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textClr,
                          ),
                          CustomText(
                            text: "Oct 15, 2024",
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.white,
                          ),
                          CustomText(
                            top: 20,
                            text: "Court",
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textClr,
                          ),
                          CustomText(
                            text: "Court #3",
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.white,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: "Date",
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textClr,
                          ),
                          CustomText(
                            text: "Oct 15, 2024",
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.white,
                          ),
                          CustomText(
                            top: 20,
                            text: "Court",
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textClr,
                          ),
                          CustomText(
                            text: "Court #3",
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.white,
                          ),
                        ],
                      ),
                      SizedBox(),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: CustomText(
                text: "Actions",
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
                bottom: 20,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width / 2.2,
                  padding: EdgeInsets.symmetric(horizontal: 26, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xff111827), Color(0xff1F2937)],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check, color: AppColors.white),
                      CustomText(
                        left: 8,
                        text: "Approve",
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width / 2.2,
                  padding: EdgeInsets.symmetric(horizontal: 26, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.black_05,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomImage(
                        imageSrc: AppIcons.cancel,
                        height: 20,
                        width: 20,
                      ),
                      CustomText(
                        left: 8,
                        text: "Decline",
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              width: MediaQuery.sizeOf(context).width,
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(color: AppColors.black, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomImage(
                    imageSrc: AppIcons.calender,
                    height: 20,
                    width: 20,
                    imageColor: AppColors.black,
                  ),
                  CustomText(
                    left: 8,
                    text: "Suggest New Time",
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: MediaQuery.sizeOf(context).width,
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(color: AppColors.blue, width: 2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: CustomText(
                left: 8,
                text: "Suggest New Time",
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.blue,
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: MediaQuery.sizeOf(context).width,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff111827), Color(0xff1F2937)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "Contact Information",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                    bottom: 20,
                  ),
                  Row(
                    children: [
                      Icon(Icons.phone, color: AppColors.orange, size: 20),
                      CustomText(
                        left: 10,
                        text: "+1 (555) 123-4567",
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.white,
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Icon(Icons.email, color: AppColors.orange, size: 20),
                      CustomText(
                        left: 10,
                        text: "john.martinez@email.com",
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
