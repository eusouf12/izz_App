import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:izz_atlas_app/view/screens/user_part/user_home_screen/user_home_controller/sports_type_controller.dart';
import '../../../../core/app_routes/app_routes.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../utils/app_const/app_const.dart';
import '../../../components/custom_guest_login_dialog/custom_guest_login_dialog.dart';
import '../../../components/custom_loader/custom_loader.dart';
import '../../../components/custom_netwrok_image/custom_network_image.dart';
import '../../../components/custom_royel_appbar/custom_royel_appbar.dart';
import '../../../components/custom_text/custom_text.dart';
import '../../../components/custom_text_field/custom_text_field.dart';

class UserAllSportsScreen extends StatelessWidget {
  UserAllSportsScreen({super.key});
  final SportsTypeController sportsTypeController = Get.put(
    SportsTypeController(),
  );
  final TextEditingController searchController = TextEditingController();
  final page = Get.arguments;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      sportsTypeController.getAllSports();
    });
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
              textEditingController: searchController,
              fillColor: AppColors.white,
              fieldBorderColor: AppColors.greyLight,
              prefixIcon: Icon(Icons.search, color: AppColors.greyLight),
              hintText: "Search",
              hintStyle: TextStyle(color: AppColors.greyLight),

              onChanged: (value) {
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (searchController.text == value) {
                    sportsTypeController.getAllSports(search: value);
                  }
                });
              },
            ),

            const SizedBox(height: 20),

            /// Header + Filter
            CustomText(
              text: "ALL SPORTS",
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),

            /// Sports Grid
            Expanded(
              child: Obx(() {
                if (sportsTypeController.isSportsLoading.value) {
                  return const Center(child: CustomLoader());
                }
                if (sportsTypeController.sportsList.isEmpty) {
                  return const Center(
                    child: Text(
                      "No sports found (API returned empty list)",
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }

                return NotificationListener<ScrollNotification>(
                  onNotification: (scrollInfo) {
                    if (!sportsTypeController.isSportsLoadMore.value &&
                        scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent &&
                        sportsTypeController.currentPage <
                            sportsTypeController.totalPages) {
                      sportsTypeController.getAllSports(
                        loadMore: true,
                        search: searchController.text,
                      );
                    }

                    return true;
                  },

                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 10),

                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),

                    itemCount: sportsTypeController.sportsList.length + 1,

                    itemBuilder: (context, index) {
                      if (index == sportsTypeController.sportsList.length) {
                        return sportsTypeController.isSportsLoadMore.value
                            ? const Center(child: CustomLoader())
                            : const SizedBox();
                      }

                      final sport = sportsTypeController.sportsList[index];

                      return GestureDetector(
                        onTap: () {
                          Get.toNamed(
                            AppRoutes.userSearchVenueScreen,
                            arguments: {"sportName": sport.sportName, "page": page},
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
                              borderRadius: const BorderRadius.all(
                                Radius.circular(13),
                              ),
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
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
