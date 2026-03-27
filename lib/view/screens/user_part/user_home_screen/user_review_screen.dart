import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:izz_atlas_app/view/components/custom_loader/custom_loader.dart';
import 'package:izz_atlas_app/view/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:izz_atlas_app/view/screens/user_part/user_home_screen/user_home_controller/review_controller.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../components/custom_text/custom_text.dart'; 
import 'package:izz_atlas_app/utils/app_const/app_const.dart';
import 'package:izz_atlas_app/view/components/custom_netwrok_image/custom_network_image.dart';


class UserReviewScreen extends StatelessWidget {
   UserReviewScreen({super.key});
   final UserReviewController controller = Get.put(UserReviewController());

  @override
  Widget build(BuildContext context) {
   final String? venuId = Get.arguments?.toString();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (venuId != null && venuId.isNotEmpty && venuId != "null") {
        controller.getReviews(venueId: venuId);
      }
    });
    
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomRoyelAppbar(leftIcon: true,titleName: "Reviews",),
      
      body: Obx(() {
        if (controller.isReviewLoading.value && controller.reviewList.isEmpty) {
          return Center(child: CustomLoader());
        } else if (controller.reviewList.isEmpty) {
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
                        text: "${controller.reviewList.length} REVIEWS",
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
                    itemCount: controller.reviewList.length,
                    itemBuilder: (context, index) {
                      final review = controller.reviewList[index];

                      String formattedDate = "Unknown Date";
                      if (review.createdAt != null) {
                        try {
                          final date = DateTime.parse(review.createdAt!);
                          final List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                          formattedDate = "${months[date.month - 1]} ${date.year}";
                        } catch (e) {
                          if (review.createdAt!.length >= 10) {
                            formattedDate = review.createdAt!.substring(0, 10);
                          }
                        }
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomNetworkImage(
                                imageUrl: review.user?.profileImage ?? AppConstants.profileImage,
                                height: 44.w,
                                width: 44.w,
                                boxShape: BoxShape.circle,
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: review.user?.fullName?.toUpperCase() ?? "UNKNOWN USER",
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14.sp,
                                      color: AppColors.black,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                    ),
                                    SizedBox(height: 2.h),
                                    CustomText(
                                      text: formattedDate,
                                      color: Colors.grey,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: List.generate(5, (starIndex) {
                                  return Icon(
                                    starIndex < (review.rating?.floor() ?? 0)
                                        ? Icons.star
                                        : (starIndex < (review.rating ?? 0) ? Icons.star_half : Icons.star_border),
                                    color: Colors.orange,
                                    size: 14.w,
                                  );
                                }),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          CustomText(
                            text: review.comment ?? "",
                            maxLines: 10,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            textAlign: TextAlign.left,
                            color: AppColors.black.withOpacity(0.8),
                          ),
                          SizedBox(height: 16.h),
                          const Divider(color: Colors.black12, thickness: 1),
                          SizedBox(height: 16.h),
                        ],
                      );
                    },
                  ),

                  // "Load More" button if there are more reviews to load
                  if (controller.reviewCurrentPage < controller.reviewTotalPage)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: Center(
                        child: controller.isReviewMoreLoading.value 
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: () {
                                  controller.getReviews(loadMore: true, venueId: venuId.toString()); // Trigger load more reviews
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
