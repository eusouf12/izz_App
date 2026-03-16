import 'dart:convert';
import 'package:get/get.dart';
import '../../../../../service/api_check.dart';
import '../../../../../service/api_client.dart';
import '../../../../../service/api_url.dart';
import '../../../../../utils/ToastMsg/toast_message.dart';
import '../model/user_venue_details_model.dart';

class UserVenueDetailsController extends GetxController {

  // UI Toggles
  RxBool isAmenitiesOpen = true.obs;
  RxBool isVenueInfoOpen = true.obs;

  // Data Variables
  var isLoading = false.obs;
  Rx<VenueDetails?> venueDetails = Rx<VenueDetails?>(null);

  @override
  void onInit() {
    super.onInit();
  }

  void toggleAmenities() {
    isAmenitiesOpen.value = !isAmenitiesOpen.value;
  }

  void toggleVenueInfo() {
    isVenueInfoOpen.value = !isVenueInfoOpen.value;
  }

  // API Call Function
  Future<void> getVenueDetails(String id) async {
    isLoading.value = true;
    venueDetails.value = null;

    try {
      final response = await ApiClient.getData(ApiUrl.userVenueDetails(id: id));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = response.body is String
            ? jsonDecode(response.body)
            : response.body;

        final venueResponse = VenueDetailsResponse.fromJson(jsonResponse);

        var venue = venueResponse.data;
        venue.venueAvailabilities.sort((a, b) {
          List<String> days = ["SUNDAY", "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY"];
          return days.indexOf(a.day.toUpperCase()).compareTo(days.indexOf(b.day.toUpperCase()));
        });

        venueDetails.value = venue;

      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      showCustomSnackBar(e.toString(), isError: true);
    } finally {
      isLoading.value = false;
    }
  }
}