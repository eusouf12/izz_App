import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:izz_atlas_app/utils/app_const/app_const.dart';
import 'package:izz_atlas_app/utils/app_icons/app_icons.dart';
import 'package:izz_atlas_app/view/components/custom_image/custom_image.dart';
import 'package:izz_atlas_app/view/components/custom_netwrok_image/custom_network_image.dart';
import 'package:izz_atlas_app/view/components/custom_text/custom_text.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../user_part/user_home_screen/widgets/custom_home_card.dart';
import '../../user_part/user_home_screen/widgets/custom_streak.dart';

class VendorProfileCollectScreen extends StatelessWidget {
  const VendorProfileCollectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.only(left: 16,right: 16,top: 60,bottom: 40),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CustomNetworkImage(
                        imageUrl: AppConstants.girlsPhoto,
                        height: 80,
                        width: 80,
                        boxShape: BoxShape.circle,
                        border: Border.all(color: Colors.amberAccent, width: 2),
                      ),
                      Positioned(
                        bottom: -10,
                        right: -16,
                        child: CustomImage(imageSrc: AppIcons.powerIcon),
                      ),
                    ],
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_rounded,
                              size: 16,
                              color: AppColors.black_02,
                            ),
                            CustomText(
                              textAlign: TextAlign.end,
                              text: "How It Works",
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.black_02,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xff1F2937), Color(0xff4B5563)],
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              children: [
                                //   CustomImage(imageSrc: ""),
                                CustomText(
                                  text: "Level 5",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.amberAccent,
                                ),
                              ],
                            ),
                          ),
                          CustomText(
                            left: 12,
                            text: "Weekend Warrior",
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black45,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              LinearProgressIndicator(
                color: AppColors.greyLight,
                minHeight: 10,
                borderRadius: BorderRadius.circular(20),
              ),
              SizedBox(height: 20),
              CustomText(
                text: "XP: 1,250 / 1,500 to Level 6",
                fontSize: 14.w,
                fontWeight: FontWeight.w400,
              ),
              SizedBox(height: 20),
              CustomText(
                text: "UNLOCK BADGES",
                fontSize: 16.w,
                fontWeight: FontWeight.w700,
                bottom: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                      gradient: LinearGradient(
                        colors: [Color(0xff1F2937), Color(0xff4B5563)],
                      ),
                    ),
                    child: Column(
                      children: [
                        CustomImage(
                          imageSrc: AppIcons.kingIcon,
                          height: 30,
                          width: 30,
                        ),
                        CustomText(
                          top: 8,
                          text: "VIP",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.white,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                      gradient: LinearGradient(
                        colors: [Color(0xff1F2937), Color(0xff4B5563)],
                      ),
                    ),
                    child: Column(
                      children: [
                        CustomImage(
                          imageSrc: AppIcons.singlepowerIcon,
                          height: 30,
                          width: 30,
                        ),
                        CustomText(
                          top: 8,
                          text: "VIP",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.white,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                      gradient: LinearGradient(
                        colors: [Color(0xff1F2937), Color(0xff4B5563)],
                      ),
                    ),
                    child: Column(
                      children: [
                        CustomImage(
                          imageSrc: AppIcons.daimondIcon,
                          height: 30,
                          width: 30,
                        ),
                        CustomText(
                          top: 8,
                          text: "VIP",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.white,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 26, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                      gradient: LinearGradient(
                        colors: [Color(0xff1F2937), Color(0xff4B5563)],
                      ),
                    ),
                    child: Column(
                      children: [
                        CustomImage(
                          imageSrc: AppIcons.privacyIcon,
                          height: 30,
                          width: 30,
                        ),
                        CustomText(
                          top: 8,
                          text: "VIP",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
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
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                  gradient: LinearGradient(
                    colors: [Color(0xff1F2937), Color(0xff4B5563)],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                   Row(
                     children: [
                       CustomImage(imageSrc: AppIcons.coinIcon),
                       SizedBox(width: 12),
                       Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           CustomText(
                             text: "Atlas Points",
                             fontSize: 18,
                             fontWeight: FontWeight.w500,
                             color: AppColors.white,
                           ),
                           CustomText(
                             text: "320",
                             fontSize: 28,
                             fontWeight: FontWeight.w700,
                             color: AppColors.white,
                           ),
                         ],
                       ),
                     ],
                   ),
                    Container(
                      width: 100,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Center(
                        child: CustomText(
                          text: "Redeem",
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              CustomText(
                top: 10,
                text: "Achievements",
                fontSize: 16.w,
                fontWeight: FontWeight.w700,
                bottom: 10,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    CustomHomeCard(imagesrc: AppIcons.bookingIcon,name: "First Booking",),
                    CustomHomeCard(imagesrc: AppIcons.starIcon,name: "Multi-Sport",),
                    CustomHomeCard(imagesrc: AppIcons.personsicon,name: "Referral Champ",),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    CustomHomeCard(imagesrc: AppIcons.icon1,name: "Streak Master",),
                    CustomHomeCard(imagesrc: AppIcons.icon2,name: "Champion",),
                    CustomHomeCard(imagesrc: AppIcons.icon3,name: "Elite            ",),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              StreakTrackerCard(streakDays: 4, totalDays: 7),
              SizedBox(height: 20,),
              Container(
                width: MediaQuery.sizeOf(context).width,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                  gradient: LinearGradient(
                    colors: [Color(0xff1F2937), Color(0xff4B5563)],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: "Invite Friends",
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Colors.amberAccent,
                            ),
                            CustomText(
                              text: "3 successful referrals",
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: AppColors.white,
                            ),
                            CustomText(
                              text: "+50 XP per referral",
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.amberAccent,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      width: 100,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.amberAccent,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Center(
                        child: CustomText(
                          text: "Invite More",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



