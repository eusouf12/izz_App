import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../components/custom_loader/custom_loader.dart';
import '../../../components/custom_royel_appbar/custom_royel_appbar.dart';
import '../../../components/custom_text/custom_text.dart';
import '../../user_part/user_home_screen/user_home_controller/user_details_controller.dart';

class VenueAvailabilityScreen extends StatelessWidget {
  const VenueAvailabilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserVenueDetailsController controller = Get.put(UserVenueDetailsController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.arguments != null) {
        controller.getVenueDetails(Get.arguments);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomRoyelAppbar(
        leftIcon: true,
        titleName: "Venue Availability",
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const CustomLoader();
        }

        final venue = controller.venueDetails.value;

        if (venue == null || venue.venueAvailabilities.isEmpty) {
          return Center(
            child: CustomText(
              text: "No Schedule Found",
              color: AppColors.textClr,
              fontSize: 16,
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: venue.venueAvailabilities.length,
          itemBuilder: (context, index) {
            final availability = venue.venueAvailabilities[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Day Name
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: AppColors.black, size: 20),
                      const SizedBox(width: 8),
                      CustomText(
                        text: availability.day.toUpperCase(),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Divider(color: Colors.grey.shade200),
                  const SizedBox(height: 12),

                  // Time Slots
                  availability.scheduleSlots.isNotEmpty
                      ? Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: availability.scheduleSlots.map((slot) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.black,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CustomText(
                          text: "${slot.from} - ${slot.to}",
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white,
                        ),
                      );
                    }).toList(),
                  )
                      : Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: CustomText(
                        text: "No slots available",
                        fontSize: 12,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}