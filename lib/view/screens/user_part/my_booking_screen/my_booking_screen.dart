import 'package:flutter/material.dart';
import 'package:izz_atlas_app/utils/app_colors/app_colors.dart';
import 'package:izz_atlas_app/utils/app_const/app_const.dart';
import 'package:izz_atlas_app/view/components/custom_netwrok_image/custom_network_image.dart';
import 'package:izz_atlas_app/view/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:izz_atlas_app/view/components/custom_text/custom_text.dart';
import '../../../components/custom_button/custom_button.dart';

class MyBookingScreen extends StatelessWidget {
  const MyBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomRoyelAppbar(leftIcon: true, titleName: "My Booking"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                gradient: LinearGradient(
                  colors: [
                    AppColors.black,
                    Color(0xff111827),
                    Color(0xff1F2937),
                  ],
                ),
              ),
              child: Column(
                children: [
                  CustomNetworkImage(
                    imageUrl: AppConstants.ntrition1,
                    height: 200,
                    borderRadius: BorderRadius.circular(10),
                    width: MediaQuery.sizeOf(context).width,
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: "Westfield Sports Lab",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white,
                      ),
                      CustomText(
                        text: "RM 120/HR",
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: AppColors.white,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.location_on),
                      CustomText(
                        text: "Westfield Sports Complex",
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xffA1A1A1),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.location_on),
                      CustomText(
                        text: "Football Field A",
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xffA1A1A1),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.location_on),
                      CustomText(
                        text: "Sep 25, 2024 • 6:00 PM - 7:00 PM",
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xffA1A1A1),
                      ),
                    ],
                  ),
                  CustomText(
                    top: 10,
                    text: "Your booking request on pending",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.yellow,
                    bottom: 20,
                  ),
                  CustomButton(
                    onTap: () {},
                     title: "CHAT WITH VENDOR",
                    isBorder:  true,
                    borderWidth: 2,
                    fillColor: Colors.transparent,
                    textColor: Colors.blueAccent,
                    borderColor: Colors.blueAccent,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
