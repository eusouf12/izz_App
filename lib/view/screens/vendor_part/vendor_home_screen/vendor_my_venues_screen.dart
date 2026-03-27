import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:izz_atlas_app/utils/app_colors/app_colors.dart';
import 'package:izz_atlas_app/view/components/custom_button/custom_button.dart';
import 'package:izz_atlas_app/view/components/custom_loader/custom_loader.dart';
import 'package:izz_atlas_app/view/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:izz_atlas_app/view/components/custom_text/custom_text.dart';
import 'package:izz_atlas_app/view/screens/vendor_part/vendor_home_screen/widgets/custom_my_venues_main_card.dart';
import '../../../../core/app_routes/app_routes.dart';
import 'controller/vendor_my_venue_controller.dart';

class VendorMyVenuesScreen extends StatelessWidget {
  VendorMyVenuesScreen({super.key});

  final VendorMyVenueController controller = Get.put(VendorMyVenueController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomRoyelAppbar(leftIcon: true, titleName: "Venues"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 2,
                  child: CustomText(
                    text: "My Venues",
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: CustomButton(
                    onTap: () {
                      Get.toNamed(AppRoutes.addVenueScreen);
                    },
                    height: 40,
                    fontSize: 14,
                    textColor: AppColors.white,
                    title: "+  ADD NEW",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CustomLoader());
                }

                if (controller.myVenueList.isEmpty) {
                  return Center(
                    child: CustomText(
                      text: "No Venues Found",
                      color: AppColors.greyLight,
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: controller.myVenueList.length,
                  padding: const EdgeInsets.only(bottom: 20),
                  itemBuilder: (context, index) {
                    final venue = controller.myVenueList[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: CustomMyVenuesMainCard(
                        title: venue.venueName,
                        subTitle: venue.location,
                        buttonText: venue.venueStatus ? "Active" : "Inactive",

                        onTapEdit: () {
                          Get.toNamed(
                            AppRoutes.editVenueScreen,
                            arguments: venue.id,
                          );
                        },

                        onTapAvailability: () {
                          Get.toNamed(
                            AppRoutes.venueAvailabilityScreen,
                            arguments: venue.id,
                          );
                        },

                        onTapDetails: () {
                          Get.toNamed(
                            AppRoutes.venueDetailsScreen,
                            arguments: venue.id,
                          );
                        },
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
