import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:izz_atlas_app/utils/app_const/app_const.dart';
import 'package:izz_atlas_app/utils/app_icons/app_icons.dart';
import 'package:izz_atlas_app/view/components/custom_image/custom_image.dart';
import 'package:izz_atlas_app/view/components/custom_loader/custom_loader.dart';
import 'package:izz_atlas_app/view/components/custom_netwrok_image/custom_network_image.dart';
import 'package:izz_atlas_app/view/components/custom_text/custom_text.dart';
import '../../../../../core/app_routes/app_routes.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../components/custom_royel_appbar/custom_royel_appbar.dart';
import '../../../vendor_part/vendor_profile_screen/controller/vendor_profile_controller.dart';
import '../../user_home_screen/widgets/custom_home_card.dart';
import '../../user_home_screen/widgets/custom_streak.dart';
import '../controller/user_gamification_profile_controller.dart';

class UserCollectScreen extends StatelessWidget {
  UserCollectScreen({super.key});

  final VendorProfileController vendorProfileController = Get.put(VendorProfileController());
  final UserGamificationController gamificationController = Get.put(UserGamificationController());

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      vendorProfileController.getUserProfile();
      gamificationController.fetchGamificationProfile();
      gamificationController.getUserStreak();
    });
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomRoyelAppbar(leftIcon: true, titleName: "Collect",),

      body: Obx(() {
        if (gamificationController.isLoading.value) {
          return const Center(child: CustomLoader());
        }

        final data = gamificationController.gamificationModel.value?.data;

        if (data == null) {
          return const Center(child: Text("No Data Found"));
        }

        // Safe progress calculation (backend driven)
        final double progress = data.nextLevelXP == 0 ? 0 : (data.currentXP / data.nextLevelXP).clamp(0.0, 1.0);

        return Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 40),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ---------------- Profile + Level ----------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Obx(() {
                          final userModel = vendorProfileController.userProfileModel.value;
                          final userGamification = gamificationController.gamificationModel.value?.data;
                          final badges = userGamification?.badges ?? [];

                          int displayLimit = 3;
                          int totalBadges = badges.length;
                          int displayCount = totalBadges > displayLimit ? displayLimit : totalBadges;
                          int extraCount = totalBadges > displayLimit ? totalBadges - displayLimit : 0;

                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              CustomNetworkImage(
                                imageUrl: (userModel.photo.isNotEmpty) ? userModel.photo : AppConstants.profileImage,
                                height: 80,
                                width: 80,
                                boxShape: BoxShape.circle,
                                border: Border.all(color: Colors.amberAccent, width: 2),
                              ),
                              Positioned(
                                bottom: -12,
                                right: -8,
                                child: SizedBox(
                                  height: 30,
                                  width: 70,
                                  child: Stack(
                                    children: [
                                      ...List.generate(displayCount, (index) {
                                        return Positioned(
                                          left: index * 15.0,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(color: Colors.white, width: 1.5),
                                            ),
                                            child: CustomNetworkImage(
                                              imageUrl: badges[index].iconUrl,
                                              height: 25,
                                              width: 25,
                                              boxShape: BoxShape.circle,
                                            ),
                                          ),
                                        );
                                      }),
                                      //extra badge
                                      if (extraCount > 0)
                                        Positioned(
                                          left: displayCount * 15.0,
                                          child: Container(
                                            height: 25,
                                            width: 25,
                                            decoration: BoxDecoration(
                                              color: Colors.amberAccent,
                                              shape: BoxShape.circle,
                                              border: Border.all(color: Colors.white, width: 1.5),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "+$extraCount",
                                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xff1F2937), Color(0xff4B5563)],),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: CustomText(
                            text: "Level ${data.currentLevel}",
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.amberAccent,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.userHowItWorkScreen);
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.info_rounded, size: 16),
                              SizedBox(width: 4),
                              Text("How It Works"),
                            ],
                          ),
                        ),
                        CustomText(
                          top: 8,
                          text: data.levelTitle,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black45,
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// ---------------- XP Progress ----------------
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(20),
                  backgroundColor: AppColors.greyLight,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.black,
                  ),
                ),
                const SizedBox(height: 10),
                CustomText(
                  text:
                  "XP: ${data.currentXP} / ${data.nextLevelXP} to Level ${data.currentLevel + 1}",
                ),

                const SizedBox(height: 20),

                /// ---------------- Badges ----------------
                const CustomText(
                  text: "UNLOCK BADGES",
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: data.badges.map((badge) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                            gradient: const LinearGradient(
                              colors: [Color(0xff1F2937), Color(0xff4B5563)],
                            ),
                          ),
                          child: Column(
                            children: [
                              CustomNetworkImage(
                                imageUrl: badge.iconUrl,
                                height: 30,
                                width: 30,
                              ),
                              CustomText(
                                top: 6,
                                text: badge.name,
                                fontSize: 12,
                                color: AppColors.white,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 20),

                /// ---------------- Atlas Points ----------------
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17),
                    gradient: const LinearGradient(
                      colors: [Color(0xff1F2937), Color(0xff4B5563)],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CustomImage(imageSrc: AppIcons.coinIcon),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CustomText(
                                text: "Atlas Points",
                                fontSize: 18,
                                color: Colors.white,
                              ),
                              CustomText(
                                text: data.atlasPoints.toString(),
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ],
                      ),
                      // =========== Redeem Button ===========
                      GestureDetector(
                        onTap: (){

                        },
                        child: Container(
                          width: 100,
                          height: 35,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: const Center(
                            child: Text(
                              "Redeem",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// ---------------- Achievements ----------------
                const CustomText(
                  text: "Achievements",
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: data.achievements.map((a) {
                      return CustomHomeCard(
                        imagesrc: a.iconUrl!.isNotEmpty ? a.iconUrl : AppIcons.starIcon,
                        name: a.name,
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 20),

                /// ---------------- Streak ----------------
                Obx(() {
                  final streak = gamificationController.streakList.first;

                  return StreakTrackerCard(
                    streakDays: streak.currentStreak ?? 1,
                    totalDays: 7,
                    onClaim: () {
                      gamificationController.claimStreakReward();
                    },
                  );
                }),


                const SizedBox(height: 20),

                /// ---------------- Referral ----------------
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17),
                    gradient: const LinearGradient(
                      colors: [Color(0xff1F2937), Color(0xff4B5563)],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomText(
                            text: "Invite Friends",
                            fontSize: 22,
                            color: Colors.amberAccent,
                          ),
                          CustomText(
                            text:
                            "${data.referralCount} successful referrals",
                            fontSize: 18,
                            color: Colors.white,
                          ),
                          const CustomText(
                            text: "+50 XP per referral",
                            fontSize: 14,
                            color: Colors.amberAccent,
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
                        child: const Center(
                          child: Text("Invite More"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
