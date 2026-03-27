import 'dart:convert';
import 'package:get/get.dart';
import 'package:izz_atlas_app/view/screens/user_part/user_home_screen/model/review_model.dart';
import '../../../../../service/api_client.dart';
import '../../../../../service/api_url.dart';
import '../../../../../utils/ToastMsg/toast_message.dart';

class UserReviewController extends GetxController {

  RxList<ReviewData> reviewList = <ReviewData>[].obs;

  RxBool isReviewLoading = false.obs;
  RxBool isReviewMoreLoading = false.obs;

  int reviewCurrentPage = 1;
  int reviewTotalPage = 1;

  Future<void> getReviews({bool loadMore = false, required String venueId}) async {

    if (isReviewLoading.value || isReviewMoreLoading.value) return;

    try {

      if (loadMore) {

        if (reviewCurrentPage >= reviewTotalPage) return;

        isReviewMoreLoading.value = true;
        reviewCurrentPage++;

      } else {

        isReviewLoading.value = true;
        reviewCurrentPage = 1;
        reviewList.clear();
      }

      final url = ApiUrl.getReviews(page: reviewCurrentPage.toString(), id: venueId);

      final response = await ApiClient.getData(url);

      final jsonResponse = response.body is String ? jsonDecode(response.body) : response.body;

      if (response.statusCode == 200) {

        final model = ReviewResponse.fromJson(jsonResponse);

        final newReviews = model.data ?? [];

       
        final existingIds =reviewList.map((e) => e.id).toSet();

        final uniqueReviews = newReviews.where((e) => !existingIds.contains(e.id)).toList();

        if (loadMore) {
          reviewList.addAll(uniqueReviews);
        } else {
          reviewList.assignAll(uniqueReviews);
        }
        final meta = model.meta;
        if (meta != null) {
          reviewTotalPage =
              (meta.total! / meta.limit!).ceil();
        }

      } else {

        showCustomSnackBar(jsonResponse["message"] ?? "Failed to fetch reviews",isError: true,);
      }

    } catch (e) {

      showCustomSnackBar(e.toString(), isError: true);

    } finally {

      isReviewLoading.value = false;
      isReviewMoreLoading.value = false;
    }
  }
}