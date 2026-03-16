import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:izz_atlas_app/view/components/custom_loader/custom_loader.dart';
import 'package:izz_atlas_app/utils/app_colors/app_colors.dart';

import 'controller/venue_rewier_controller.dart';

class VenueReviewPopup extends StatelessWidget {
  final String venueId;
  VenueReviewPopup({super.key, required this.venueId});

  final VenueReviewController controller = Get.put(VenueReviewController());

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Write a Review",
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Icon(Icons.close),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              /// Rating
              Text(
                "Rating",
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8.h),

              /// ⭐ Star Row
              Obx(() => Row(
                children: List.generate(5, (index) {
                  final int fullStars = controller.rating.value.floor();
                  final bool hasHalfStar = (controller.rating.value - fullStars) >= 0.5;

                  IconData icon;
                  if (index < fullStars) {
                    icon = Icons.star;
                  } else if (index == fullStars && hasHalfStar) {
                    icon = Icons.star_half;
                  } else {
                    icon = Icons.star_border;
                  }

                  return IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => controller.setRating(index + 1.0),
                    icon: Icon(
                      icon,
                      color: Colors.amber,
                      size: 28.sp,
                    ),
                  );
                }),
              )),
              SizedBox(height: 12.h),

              /// Comment
              Text(
                "Comment",
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 6.h),
              TextField(
                controller: controller.commentController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Write your experience...",
                  hintStyle: TextStyle(fontSize: 12.sp),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              /// Action Buttons
              Obx(() => Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: controller.isLoading.value ? null : () => Get.back(),
                      child: const Text("Cancel"),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () => controller.submitReview(venueId),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        disabledBackgroundColor: Colors.grey.shade300,
                      ),
                      child: controller.isLoading.value
                          ? const CustomLoader()
                          : const Text("Submit", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
