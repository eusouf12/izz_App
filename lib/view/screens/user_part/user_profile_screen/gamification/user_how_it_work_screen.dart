import 'package:flutter/material.dart';
import 'package:izz_atlas_app/utils/app_colors/app_colors.dart';
import 'package:izz_atlas_app/utils/app_icons/app_icons.dart';
import 'package:izz_atlas_app/view/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:izz_atlas_app/view/components/custom_text/custom_text.dart';
import 'package:izz_atlas_app/view/screens/user_part/user_profile_screen/widgets/custom_rules_card.dart';

class UserHowItWorkScreen extends StatelessWidget {
  const UserHowItWorkScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              Container(
                padding: EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: Color(0xFFF111827),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: "Level 1-3",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.white,
                        ),
                        CustomText(
                          text: "5% off bookings",
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textClr,
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: "Level 4-6 (Current)",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.green,
                        ),
                        CustomText(
                          text: "10% off + Priority",
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.green,
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: "Level 7-10",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.white,
                        ),
                        CustomText(
                          text: "15% off + VIP Access",
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textClr,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30,),
              Container(
                width: MediaQuery.sizeOf(context).width,
                padding: EdgeInsets.all(23),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFFF9CA3AF), Color(0xFFF7BDB87)]),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: CustomText(text: "Start Earning Rewards", fontSize: 20, fontWeight: FontWeight.w700,)
              ),
              SizedBox(height: 60,)
            ],
          ),
        ),
      ),
    );
  }
}
