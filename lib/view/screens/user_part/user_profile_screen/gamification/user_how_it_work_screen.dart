import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:izz_atlas_app/utils/app_colors/app_colors.dart';
import 'package:izz_atlas_app/utils/app_icons/app_icons.dart';
import 'package:izz_atlas_app/view/components/custom_loader/custom_loader.dart';
import 'package:izz_atlas_app/view/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:izz_atlas_app/view/components/custom_text/custom_text.dart';
import 'package:izz_atlas_app/view/screens/user_part/user_profile_screen/widgets/custom_rules_card.dart';
import 'package:get/get.dart';
import '../../../vendor_part/vendor_profile_screen/controller/vendor_profile_controller.dart' show VendorProfileController;
import '../controller/user_gamification_profile_controller.dart';

class UserHowItWorkScreen extends StatelessWidget {
   UserHowItWorkScreen({super.key});
   final VendorProfileController vendorProfileController = Get.put(VendorProfileController());
   final UserGamificationController gamificationController = Get.put(UserGamificationController());

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      gamificationController.getLevels();
      vendorProfileController.getUserProfile();
      gamificationController.fetchGamificationProfile();
    });
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomRoyelAppbar(
        leftIcon: true,
        titleName: "Gamification Rules",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CustomText(
                  text:
                      "Learn how to earn rewards, level up,\nand unlock exclusive benefits.",
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  maxLines: 2,
                  bottom: 8,
                ),
              ),
              Divider(color: AppColors.black, thickness: 1.6),
              CustomRulesCard(
                icons: AppIcons.rules1,
                title: "Earn XP for Every Action",
                description: "Booking, reviewing, referring friends, and\ncompleting challenges all earn XP.",
              ),
              CustomRulesCard(
                icons: AppIcons.rules2,
                title: "Level Up to Unlock Discounts",
                description: "Each level unlocks new perks like % off\nbookings, priority access, and exclusive badges.",
              ),
              CustomRulesCard(
                icons: AppIcons.rules3,
                title: "Maintain Streaks for Bonus XP",
                description: "Book consistently to build streaks and earn\nextra XP.",
              ),
              CustomRulesCard(
                icons: AppIcons.rules4,
                title: "Complete Challenges",
                description: "Seasonal and sport-specific challenges offer\nbig XP boosts and rare badges.",
              ),
              CustomRulesCard(
                icons: AppIcons.rules5,
                title: "Refer Friends for Rewards",
                description: "Invite friends and earn Atlas Points when\nthey book.",
              ),
              CustomRulesCard(
                icons: AppIcons.rules6,
                title: "Redeem Atlas Points",
                description: "Use points for discounts, priority booking,\nor unlocking premium venues.",
              ),
              CustomRulesCard(
                icons: AppIcons.rules7,
                title: "Next-Purchase Bonuses",
                description: "Earn coupons after booking—use them\nwithin 7 days for extra savings.",
              ),
        
        
              CustomText(
                text: "LEVEL BENEFITS",
                fontSize: 16,
                fontWeight: FontWeight.w700,
                bottom: 20,
              ),
              Obx(() {
                if (gamificationController.isLevelLoading.value) {
                  return const Center(child: CustomLoader());
                }

                final levels = gamificationController.levelList;
                final currentLevel = gamificationController.gamificationModel.value?.data.currentLevel ?? 0;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(levels.length, (index) {
                    final data = levels[index];
                    bool isCurrent = (currentLevel == data.level);
                    bool isUnlocked = (currentLevel ?? 0) >= (data.level ?? 0);

                    return IntrinsicHeight(
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 12.r,
                                height: 12.r,
                                decoration: BoxDecoration(
                                  color: isCurrent ? AppColors.green : (isUnlocked ? AppColors.green.withOpacity(0.5) : Colors.white24),
                                  shape: BoxShape.circle,
                                  boxShadow: isCurrent ? [BoxShadow(color: AppColors.green.withOpacity(0.5), blurRadius: 10, spreadRadius: 2)] : [],
                                ),
                              ),
                              if (index != levels.length - 1)
                                Expanded(
                                  child: VerticalDivider(
                                    color: isUnlocked ? AppColors.green.withOpacity(0.5) : Colors.white10,
                                    thickness: 2,
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(width: 16.w),

                          Expanded(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              margin: EdgeInsets.only(bottom: 12.h),
                              padding: EdgeInsets.all(16.r),
                              decoration: BoxDecoration(
                                color: isCurrent ? AppColors.green.withOpacity(0.1) :  Color(0xFFF111827),
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: isCurrent ? AppColors.green.withOpacity(0.5) : Colors.white10,
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText(
                                        text: "Level ${data.level}",
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        color: isCurrent ? AppColors.green : Colors.white,
                                      ),
                                      if (isCurrent)
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                                          decoration: BoxDecoration(
                                            color: AppColors.green,
                                            borderRadius: BorderRadius.circular(20.r),
                                          ),
                                          child: CustomText(text: "Current", fontSize: 10.sp, color: Colors.black, fontWeight: FontWeight.bold),
                                        ),
                                    ],
                                  ),
                                  SizedBox(height: 8.h),

                                  Wrap(
                                    spacing: 6.w,
                                    runSpacing: 6.h,
                                    children: (data.benefits ?? []).map((benefit) {
                                      return Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.05),
                                          borderRadius: BorderRadius.circular(8.r),
                                        ),
                                        child: CustomText(
                                          text: "• ${benefit.replaceAll('_', ' ').capitalizeFirst}",
                                          fontSize: 11.sp,
                                          color: isCurrent ? AppColors.green.withOpacity(0.9) : Colors.white70,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                );
              }),
              SizedBox(height: 30,),
              GestureDetector(
                onTap: (){
                  Get.back();
                },
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  padding: EdgeInsets.all(23),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xFFF9CA3AF), Color(0xFFF7BDB87)]),
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: CustomText(text: "Start Earning Rewards", fontSize: 20, fontWeight: FontWeight.w700,)
                ),
              ),
              SizedBox(height: 60,)
            ],
          ),
        ),
      ),
    );
  }
}
