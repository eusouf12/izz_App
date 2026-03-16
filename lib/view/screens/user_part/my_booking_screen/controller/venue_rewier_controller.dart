import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../service/api_check.dart';
import '../../../../../service/api_client.dart';
import '../../../../../service/api_url.dart';
import '../../../../../utils/ToastMsg/toast_message.dart';

class VenueReviewController extends GetxController {
  var rating = 0.0.obs;
  final TextEditingController commentController = TextEditingController();
  var isLoading = false.obs;

  /// Tap to set rating (integer)
  void setRating(double value) {
    rating.value = value;
  }

  /// ================= Submit Review =================
  Future<void> submitReview(String venueId) async {
    if (rating.value == 0) {
      showCustomSnackBar("Please select a rating", isError: true);
      return;
    }

    isLoading.value = true;
    update();

    Map<String, dynamic> body = {
      "venueId": venueId,
      "rating": rating.value,
      "comment": commentController.text.trim(),
    };

    try {
      var response = await ApiClient.postData(ApiUrl.reviews, jsonEncode(body));

      if (response.statusCode == 200 || response.statusCode == 201) {
        isLoading.value = false;

        Map<String, dynamic> jsonResponse;
        if (response.body is String) {
          jsonResponse = jsonDecode(response.body);
        } else {
          jsonResponse = response.body as Map<String, dynamic>;
        }

        showCustomSnackBar(
          jsonResponse['message'] ?? "Review submitted successfully!",
          isError: false,
        );

        rating.value = 0.0;
        commentController.clear();
        Get.back();
      } else {
        isLoading.value = false;
        if (response.statusText == ApiClient.somethingWentWrong) {
          showCustomSnackBar("Check your network connection", isError: true);
        } else {
          ApiChecker.checkApi(response);
        }
      }
    } catch (e) {
      isLoading.value = false;
      showCustomSnackBar("An error occurred. Please try again.", isError: true);
      debugPrint("Review Submission Error: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }
}
