import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:izz_atlas_app/view/components/custom_loader/custom_loader.dart';
import 'package:izz_atlas_app/view/screens/user_part/user_home_screen/user_home_controller/review_controller.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../components/custom_text/custom_text.dart';  // Import your controller

class UserReviewScreen extends StatelessWidget {
  final String venueId;

  const UserReviewScreen({super.key, required this.venueId});

  @override
  Widget build(BuildContext context) {
    final UserReviewController controller = Get.put(UserReviewController());

    // Set the venueId to trigger fetching the reviews
    controller.venueId.value = venueId;

    // Fetch reviews when the screen is initialized
    controller.fetchReviews();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Get.back(),
        ),
        title: CustomText(
          text: "Reviews",
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.reviews.isEmpty) {
          return Center(child: CustomLoader());
        } else if (controller.reviews.isEmpty) {
          return Center(child: Text("No reviews yet", style: TextStyle(fontSize: 16.sp)));
        } else {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rating Summary (you can update this based on your logic)
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 20),
                      SizedBox(width: 6.w),
                      CustomText(
                        text: "${controller.reviews.length} REVIEWS",
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  const Divider(),
                  SizedBox(height: 16.h),

                  // Reviews List
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.reviews.length,
                    itemBuilder: (context, index) {
                      final review = controller.reviews[index];

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // You can add an image here if needed
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: review.userId, // You can use the user name if you have it
                                  fontWeight: FontWeight.bold,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4.h),
                                CustomText(
                                  text: review.comment,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  // "Load More" button if there are more reviews to load
                  if (controller.isLoadMore.value)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            controller.fetchReviews(loadMore: true); // Trigger load more reviews
                          },
                          child: CustomText(text: "Load More"),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        }
      }),
    );
  }
}
