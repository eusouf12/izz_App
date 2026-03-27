import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:izz_atlas_app/core/app_routes/app_routes.dart';
import 'package:izz_atlas_app/utils/app_icons/app_icons.dart';
import 'package:izz_atlas_app/view/components/custom_image/custom_image.dart';
import 'package:izz_atlas_app/view/components/custom_loader/custom_loader.dart';
import 'package:izz_atlas_app/view/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:izz_atlas_app/view/components/custom_text/custom_text.dart';
import 'package:izz_atlas_app/view/screens/user_part/user_home_screen/user_fuilter_screen.dart';
import 'package:izz_atlas_app/view/screens/user_part/user_home_screen/user_home_controller/user_all_sports_controller.dart';
import 'package:izz_atlas_app/view/screens/user_part/user_home_screen/widgets/custom_results_venue_container.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../components/custom_text_field/custom_text_field.dart';

class UserSearchVenueScreen extends StatelessWidget {
  UserSearchVenueScreen({super.key});
  final UserAllSportsController userAllSportsController = Get.put(UserAllSportsController());
  final  selectedSportsType = Get.arguments;
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      userAllSportsController.allSports(filter: selectedSportsType);
    });

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomRoyelAppbar(leftIcon: true, titleName: "Search"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [

            /// SEARCH FIELD
            CustomTextField(
              fillColor: AppColors.white,
              fieldBorderColor: AppColors.greyLight,
              prefixIcon: Icon(Icons.search, color: AppColors.greyLight),
              hintText: "Search",
              hintStyle: TextStyle(color: AppColors.greyLight),
              textEditingController: searchController,
              onChanged: (value) {
                userAllSportsController.selectedVenue.value = value;
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (searchController.text == value) {
                    userAllSportsController.allSports(filter: selectedSportsType);
                  }
                });
              },
            ),

            const SizedBox(height: 20),

            /// TITLE + FILTER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text:
                  "RESULTS FOR '${selectedSportsType.isNotEmpty ? selectedSportsType : 'VENUE'}'",
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
                GestureDetector(
                  onTap: () {
                    Get.bottomSheet(
                      UserFilterScreen(
                        sportType: selectedSportsType,
                      ),
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

            const SizedBox(height: 10),

            /// VENUE LIST
            Expanded(
              child: Obx(() {
                if (userAllSportsController.isSportsLoading.value && userAllSportsController.allSportsVenueFilter.isEmpty) {
                  return const Center(child: CustomLoader());
                }
                if (userAllSportsController.allSportsVenueFilter.isEmpty) {
                  return const Center(child: Text("No venues found"));
                }
                final venuesList = userAllSportsController.allSportsVenueFilter.expand((group) => group.venues).toList();

                return NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent && !userAllSportsController.isSportsLoadMore.value) {
                      userAllSportsController.allSports(isLoadMoreRequest: true);
                    }
                    return false;
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 20),
                    itemCount: venuesList.length + (userAllSportsController.isSportsLoadMore.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == venuesList.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(child: CustomLoader()),
                        );
                      }

                      final venue = venuesList[index];

                      return CustomResultsVenueContainer(
                        venueName: venue.venueName,
                        sportName: venue.sportsType,
                        location: venue.location,
                        price: "RM ${venue.pricePerHour}/hr",
                        status: venue.venueStatus ? "Active" : "Booked",
                        rating: venue.venueRating.toString(),
                        imageUrl: venue.venueImage,
                        onTap: () {
                          Get.toNamed(
                            AppRoutes.userVenueDetailsScreen,
                            arguments: {"venueId":venue.id , "page": "booking"},
                          );
                        },
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