import 'dart:convert';
import 'package:get/get.dart';
import '../../../../../service/api_client.dart';
import '../../../../../service/api_url.dart';
import '../../../../../utils/ToastMsg/toast_message.dart';
import '../model/all_sports_model.dart';

class UserReviewController extends GetxController {
  var reviews = <Review>[].obs;
  var isLoading = false.obs;
  var isLoadMore = false.obs;
  int currentPage = 1;
  int totalPage = 1;
  var venueId = ''.obs;
  var errorMessage = ''.obs;

  // Method to fetch reviews for a specific venue
  Future<void> fetchReviews({bool loadMore = false}) async {
    if (isLoading.value || isLoadMore.value) return;

    try {
      if (loadMore) {
        if (currentPage >= totalPage) return;
        isLoadMore.value = true;
        currentPage++;
      } else {
        isLoading.value = true;
        currentPage = 1;
        reviews.clear();
      }

      final response = await ApiClient.getData(ApiUrl.allSports(page: currentPage.toString()),);

      final Map<String, dynamic> jsonResponse =
      response.body is String ? jsonDecode(response.body) : response.body;

      if (response.statusCode == 200 || response.statusCode == 201) {
        final venueResponse = VenueResponse.fromJson(jsonResponse);

        final meta = venueResponse.data.meta;
        totalPage = (meta.total / meta.limit).ceil();

        // Iterate over the first venue group (or handle as needed)
        for (var group in venueResponse.data.data) {
          for (var venue in group.venues) {
            // Add reviews from each venue
            reviews.addAll(venue.reviews);
          }
        }
      } else {
        showCustomSnackBar(
          jsonResponse['message']?.toString() ?? "Failed to fetch reviews",
          isError: true,
        );
      }
    } catch (e) {
      showCustomSnackBar(e.toString(), isError: true);
    } finally {
      isLoading.value = false;
      isLoadMore.value = false;
      update();
    }
  }

  // Reset controller when closed
  @override
  void onClose() {
    reviews.clear();
    currentPage = 1;
    totalPage = 1;
    super.onClose();
  }
}
