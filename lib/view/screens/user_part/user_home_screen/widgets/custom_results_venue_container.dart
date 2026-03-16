import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/app_routes/app_routes.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../../utils/app_const/app_const.dart';
import '../../../../components/custom_netwrok_image/custom_network_image.dart';
import '../../../../components/custom_text/custom_text.dart';

class CustomResultsVenueContainer extends StatelessWidget {
  final String? imageUrl;
  final String? venueName;
  final String? location;
  final String? sportName;
  final String? price;
  final String? rating;
  final String? status;
  final VoidCallback? onTap;
  final bool showStatus;

  const CustomResultsVenueContainer({
    super.key,
    this.imageUrl,
    this.venueName,
    this.location,
    this.sportName,
    this.price,
    this.rating,
    this.status,
    this.onTap,
    this.showStatus = true,
  });

  @override
  Widget build(BuildContext context) {
    // Convert rating string to double
    double ratingValue = 0.0;
    if (rating != null) {
      try {
        ratingValue = double.parse(rating!);
      } catch (_) {
        ratingValue = 0.0;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: GestureDetector(
        onTap: onTap ?? () {
          Get.toNamed(AppRoutes.userVenueDetailsScreen);
        },
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xff1F2937),
            borderRadius: BorderRadius.circular(17),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              CustomNetworkImage(
                imageUrl: imageUrl ?? AppConstants.banner,
                height: 160,
                width: MediaQuery.sizeOf(context).width,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(17),
                  topRight: Radius.circular(17),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    // Title and Rating Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomText(
                            text: venueName ?? "Westfield Sports Lab",
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            // ⭐ Star Row (full, half, empty)
                            Row(
                              children: List.generate(5, (index) {
                                IconData icon;
                                if (index < ratingValue.floor()) {
                                  icon = Icons.star; // full star
                                } else if (index == ratingValue.floor() && (ratingValue - ratingValue.floor()) >= 0.5) {
                                  icon = Icons.star_half; // half star
                                } else {
                                  icon = Icons.star_border; // empty star
                                }
                                return Icon(icon, color: Colors.amberAccent, size: 16);
                              }),
                            ),
                            CustomText(
                              left: 4,
                              text: rating ?? "0.0",
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.white,
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Location
                    CustomText(
                      text: location ?? "124 Lorem Ave, Dhaka",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textClr,
                      bottom: 8,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                    ),

                    // Tags, Price and Status Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xff6B7280),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                                child: CustomText(
                                  text: sportName ?? "Football",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.white,
                                )
                            ),
                            CustomText(
                              left: 10,
                              text: price ?? "RM 1,20/hr",
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                            ),
                          ],
                        ),

                        // Status Button (Condition Based)
                        if (showStatus)
                          Container(
                              decoration: BoxDecoration(
                                color: const Color(0xff6B7280),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 32),
                              child: CustomText(
                                text: status ?? "Full",
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: AppColors.white,
                              )
                          )
                      ],
                    ),
                    const SizedBox(height: 20,)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
