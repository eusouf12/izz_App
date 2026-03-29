import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:izz_atlas_app/core/app_routes/app_routes.dart';
import 'package:izz_atlas_app/utils/app_colors/app_colors.dart';
import 'package:izz_atlas_app/utils/app_const/app_const.dart';
import 'package:izz_atlas_app/view/components/custom_loader/custom_loader.dart';
import 'package:izz_atlas_app/view/components/custom_netwrok_image/custom_network_image.dart';
import 'package:izz_atlas_app/view/screens/user_part/user_home_screen/user_home_controller/sports_type_controller.dart';
import 'package:izz_atlas_app/view/screens/user_part/user_home_screen/widgets/custom_nearby_container.dart';
import '../../../components/custom_nav_bar/navbar.dart';
import '../../../components/custom_text/custom_text.dart';
import '../../vendor_part/vendor_profile_screen/controller/vendor_profile_controller.dart';

class UserHomeScreen extends StatelessWidget {
  UserHomeScreen({super.key});
  final page = Get.arguments;
  final SportsTypeController sportsController = Get.put(SportsTypeController());
  final VendorProfileController vendorProfileController = Get.put(
    VendorProfileController(),
  );

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (page != "guest") {
        vendorProfileController.getUserProfile();
      }
      sportsController.getAllSports();
    });
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: "ATLAS",
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
                IconButton(
                  onPressed: () {
                    if (page != "guest") {
                      Get.toNamed(AppRoutes.userNotificationScreen);
                    }
                  },
                  icon: Icon(
                    Icons.notifications,
                    color: AppColors.black,
                    size: 28,
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  //name
                  if (page != "guest")
                    Obx(() {
                      final name = vendorProfileController
                          .userProfileModel
                          .value
                          .fullName;
                      return CustomText(
                        text: "HI $name!",
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        top: 16,
                        textAlign: TextAlign.start,
                      );
                    }),

                  CustomText(
                    textAlign: TextAlign.start,
                    text: "Ready for your next adventure?",
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    bottom: 20,
                  ),
                  //banner section
                  Obx(() {
                    // final sportsController = Get.find<SportsTypeController>();

                    final displayList = sportsController.sportsList.toList()
                      ..sort((a, b) {
                        if (a.updatedAt == null || b.updatedAt == null)
                          return 0;
                        return b.updatedAt!.compareTo(a.updatedAt!);
                      });

                    final trendingList = displayList.take(3).toList();

                    if (sportsController.isSportsLoading.value) {
                      return SizedBox(
                        height: 220.h,
                        child: const Center(child: CustomLoader()),
                      );
                    }
                    if (trendingList.isEmpty) return const SizedBox.shrink();

                    return SizedBox(
                      height: 220.h,
                      child: PageView.builder(
                        itemCount: trendingList.length,
                        controller: PageController(viewportFraction: 0.95),
                        onPageChanged: (index) {},
                        itemBuilder: (context, index) {
                          final sportData = trendingList[index];

                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: GestureDetector(
                              onTap: () {
                                Get.toNamed(
                                  AppRoutes.userSearchVenueScreen,
                                  arguments: sportData.sportName,
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(13),
                                child: Stack(
                                  children: [
                                    /// Background Image
                                    CustomNetworkImage(
                                      imageUrl:
                                          sportData.sportsImage ??
                                          AppConstants.sports,
                                      height: 220.h,
                                      width: double.infinity,
                                      borderRadius: BorderRadius.circular(13),
                                    ),

                                    /// Gradient Overlay
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withOpacity(0.7),
                                          ],
                                        ),
                                      ),
                                    ),

                                    /// Badge
                                    Positioned(
                                      left: 15,
                                      top: 15,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFD700),
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                        ),
                                        child: const Text(
                                          "TRENDING SPORT",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),

                                    /// Bottom Content
                                    Positioned(
                                      left: 15,
                                      right: 15,
                                      bottom: 20,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            sportData.sportName
                                                    ?.toUpperCase() ??
                                                "",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF111827),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: const Text(
                                              "BOOK",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
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
                        },
                      ),
                    );
                  }),

                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.fullscreenMapScreenNonEvent);
                    },
                    child: CustomNearbyContainer(
                      imageUrl: AppConstants.nearbyVenuesImage,
                      title: "NEARBY VENUES",
                    ),
                  ),
                  CustomNearbyContainer(
                    imageUrl: AppConstants.allSportsImage,
                    title: "ALL SPORTS",
                    onTap: () {
                      Get.toNamed(AppRoutes.userAllSportsScreen);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Navbar(currentIndex: 0),
    );
  }
}
