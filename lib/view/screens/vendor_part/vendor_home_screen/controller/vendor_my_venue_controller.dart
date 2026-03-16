import 'dart:convert';
import 'package:get/get.dart';
import '../../../../../service/api_client.dart';
import '../../../../../service/api_url.dart';
import '../../../../../utils/ToastMsg/toast_message.dart';
import '../model/vendor_my_venue_model.dart';

class VendorMyVenueController extends GetxController {

  var myVenueList = <Venue>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getMyVenues();
  }

  Future<void> getMyVenues() async {
    isLoading.value = true;

    try {
      final response = await ApiClient.getData(ApiUrl.vendorMyVenues);

      final Map<String, dynamic> jsonResponse =
      response.body is String ? jsonDecode(response.body) : response.body;

      if (response.statusCode == 200 || response.statusCode == 201) {

        final vendorMyVenueResponse = VendorMyVenueModel.fromJson(jsonResponse);

        myVenueList.assignAll(vendorMyVenueResponse.data);

      } else {
        showCustomSnackBar(
          jsonResponse['message']?.toString() ?? "Failed to fetch venues",
          isError: true,
        );
      }
    } catch (e) {
      showCustomSnackBar("Something went wrong: $e", isError: true);
    } finally {
      isLoading.value = false;
    }
  }
}