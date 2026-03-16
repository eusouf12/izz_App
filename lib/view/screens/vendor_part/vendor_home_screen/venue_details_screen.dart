import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:izz_atlas_app/view/components/custom_text/custom_text.dart';
import '../../../../core/app_routes/app_routes.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../utils/app_const/app_const.dart';
import '../../../../utils/app_icons/app_icons.dart';
import '../../../components/custom_image/custom_image.dart';
import '../../../components/custom_loader/custom_loader.dart';
import '../../../components/custom_netwrok_image/custom_network_image.dart';
import '../../../components/custom_royel_appbar/custom_royel_appbar.dart';
import '../../user_part/user_home_screen/user_home_controller/user_details_controller.dart';
import '../../user_part/user_home_screen/model/user_venue_details_model.dart';

class VenueDetailsScreen extends StatelessWidget {
  VenueDetailsScreen({super.key});

  final UserVenueDetailsController controller = Get.put(UserVenueDetailsController());

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dynamic argument = Get.arguments;
      if (argument != null && argument is String && argument.isNotEmpty) {
        controller.getVenueDetails(argument);
      } else {
        debugPrint("Error: Venue ID not found or invalid format in arguments");
      }
    });

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomRoyelAppbar(leftIcon: true, titleName: "Venue Details"),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const CustomLoader();
        }

        if (controller.venueDetails.value == null) {
          return const Center(child: CustomText(text: "No venue details found."));
        }

        final venue = controller.venueDetails.value!;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Venue Name
                CustomText(
                  text: venue.venueName,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),

                // Location
                CustomText(
                  text: venue.location,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff6B7280),
                  bottom: 16,
                  maxLines: 3,
                  textAlign: TextAlign.start,
                ),

                // Venue Image
                CustomNetworkImage(
                  imageUrl: (venue.venueImage.isNotEmpty) ? venue.venueImage : AppConstants.banner,
                  height: 220,
                  width: MediaQuery.sizeOf(context).width,
                  borderRadius: BorderRadius.circular(17),
                ),

                const SizedBox(height: 16),

                // Rating & Reviews
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: "OPERATION HOURS: ",
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                        CustomText(
                          text: venue.venueRating.isNotEmpty ? venue.venueRating : "0.0",
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.amber,
                          right: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.userReviewScreen);
                          },
                          child: CustomText(
                            text: "(${venue.venueReviewCount} Review)",
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Type, Status, Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xff111827),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: CustomText(
                            text: venue.sportsType,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: venue.venueStatus ? const Color(0xff22C55E) : Colors.red,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: CustomText(
                            text: venue.venueStatus ? "Active" : "Inactive",
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                    CustomText(
                      text: "RM ${venue.pricePerHour}/hr",
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Operation Hours
                if (venue.venueAvailabilities.isNotEmpty)
                  ...venue.venueAvailabilities.map((availability) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: availability.day,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: availability.scheduleSlots.isEmpty
                                  ? [
                                const CustomText(
                                  text: "Closed",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red,
                                )
                              ]
                                  : availability.scheduleSlots.map((slot) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: CustomText(
                                    text: "${slot.from} - ${slot.to}",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                const SizedBox(height: 16),

                // AMENITIES
                QuickButton(
                  text: "AMENITIES",
                  onTap: controller.toggleAmenities,
                ),
                const SizedBox(height: 6),
                Center(child: CustomImage(imageSrc: AppIcons.arrowDown)),
                Obx(() => controller.isAmenitiesOpen.value
                    ? amenitiesWidget(venue.amenities)
                    : const SizedBox()),

                const SizedBox(height: 16),

                // VENUE INFO
                QuickButton(
                  text: "VENUE INFORMATION",
                  onTap: controller.toggleVenueInfo,
                ),
                const SizedBox(height: 6),
                Center(child: CustomImage(imageSrc: AppIcons.arrowDown)),
                Obx(() => controller.isVenueInfoOpen.value
                    ? venueInformationWidget(venue.description)
                    : const SizedBox()),

                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      }),
    );
  }
}

/// ================= Helper Widgets =================
Widget amenitiesWidget(List<Amenity> amenities) {
  if (amenities.isEmpty) {
    return const Padding(
      padding: EdgeInsets.only(top: 10),
      child: CustomText(text: "No amenities listed"),
    );
  }
  return Column(
    children: [
      const SizedBox(height: 16),
      Wrap(
        spacing: 12,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        children: amenities.map((amenity) => _amenityItem(amenity.amenityName)).toList(),
      ),
    ],
  );
}

Widget _amenityItem(String title) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xff111827), Color(0xff1F2937)],
      ),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.check_circle_outline, color: AppColors.white, size: 18),
        CustomText(
          left: 8,
          text: title,
          fontSize: 14,
          color: AppColors.white,
          fontWeight: FontWeight.w600,
        ),
      ],
    ),
  );
}

Widget venueInformationWidget(String description) {
  return Column(
    children: [
      const SizedBox(height: 16),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xff1F2937),
          borderRadius: BorderRadius.circular(16),
        ),
        child: CustomText(
          text: description,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.white,
          maxLines: 10,
          textAlign: TextAlign.start,
        ),
      ),
    ],
  );
}

class QuickButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const QuickButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.greyLight,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: CustomText(
            text: text,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
