import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:izz_atlas_app/view/screens/user_part/user_home_screen/user_fuilter_screen.dart';
import 'package:izz_atlas_app/view/screens/user_part/user_home_screen/user_home_controller/sports_type_controller.dart';
import '../../../../core/app_routes/app_routes.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../utils/app_const/app_const.dart';
import '../../../../utils/app_icons/app_icons.dart';
import '../../../components/custom_image/custom_image.dart';
import '../../../components/custom_loader/custom_loader.dart';
import '../../../components/custom_netwrok_image/custom_network_image.dart';
import '../../../components/custom_royel_appbar/custom_royel_appbar.dart';
import '../../../components/custom_text/custom_text.dart';
import '../../../components/custom_text_field/custom_text_field.dart';

class UserAllSportsScreen extends StatelessWidget {UserAllSportsScreen({super.key});

  final SportsTypeController sportsTypeController = Get.put(SportsTypeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomRoyelAppbar(leftIcon: true, titleName: "All Sports"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Search
            CustomTextField(
              fillColor: AppColors.white,
              fieldBorderColor: AppColors.greyLight,
              prefixIcon: Icon(Icons.search, color: AppColors.greyLight),
              hintText: "Search",
              hintStyle: TextStyle(color: AppColors.greyLight),
            ),

            const SizedBox(height: 20),

            /// Header + Filter
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: "ALL SPORTS",
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
                GestureDetector(
                  onTap: () {
                    Get.bottomSheet(
                      SportsFilterBottomSheet(),
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                    );
                  },
                  child: Row(
                    children: [
                      CustomImage(
                        imageSrc: AppIcons.filterIcon,
                        height: 20,
                        width: 20,
                      ),
                      const SizedBox(width: 6),
                      CustomText(
                        text: "FILTERS",
                        fontSize: 14,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            /// Sports Grid
            Expanded(
              child: Obx(() {
                if (sportsTypeController.isLoading.value) {
                  return const Center(child: CustomLoader());
                }

                /// 🔥 DEBUG VIEW
                if (sportsTypeController.sportsList.isEmpty) {
                  return const Center(
                    child: Text(
                      "No sports found (API returned empty list)",
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: sportsTypeController.sportsList.length,
                  itemBuilder: (context, index) {
                    final sport = sportsTypeController.sportsList[index];

                    return GestureDetector(
                      onTap: () {
                        Get.toNamed(
                          AppRoutes.userSearchVenueScreen,
                          arguments: sport.sportName,
                        );
                      },
                      child: Stack(
                        children: [
                          CustomNetworkImage(
                            imageUrl: sport.sportsImage?.isNotEmpty == true
                                ? sport.sportsImage!
                                : AppConstants.sports,
                            height: 190.h,
                            width: MediaQuery.sizeOf(context).width / 2.2,
                            borderRadius: const BorderRadius.all(Radius.circular(13)),
                          ),
                          Positioned(
                            bottom: 40,
                            left: 10,
                            child: CustomText(
                              text: sport.sportName ?? "",
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
              }),
            ),

          ],
        ),
      ),
    );
  }
}
