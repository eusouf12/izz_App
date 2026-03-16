import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../../../service/api_client.dart';
import '../../../../../service/api_url.dart';
import '../model/vendor_my_booking_model.dart';

class VendorMyBookingController extends GetxController {
  final List<String> tabNameList = ["Requested", "Ongoing", "Completed"];

  var currentIndex = 0.obs;
  var bookings = <VendorMyBookingData>[].obs;

  var isLoading = true.obs;
  var isMoreLoading = false.obs;
  var totalBookings = 0.obs;

  int currentPage = 1;
  int totalPages = 1;

  @override
  void onInit() {
    super.onInit();
    fetchInitialBookings(tabNameList[currentIndex.value]);
  }

  /// Tab change
  void changeTab(int index) {
    if (currentIndex.value != index) {
      currentIndex.value = index;
      fetchInitialBookings(tabNameList[index]);
    }
  }

  /// First page load
  Future<void> fetchInitialBookings(String status) async {
    currentPage = 1;
    totalPages = 1;
    bookings.clear();

    /// 🔥 FIX: map UI tab → backend status
    await fetchBookings(_mapStatus(status));
  }

  /// Pagination + API call
  Future<void> fetchBookings(String status) async {
    if (currentPage > totalPages) return;

    currentPage == 1
        ? isLoading.value = true
        : isMoreLoading.value = true;

    try {
      final response = await ApiClient.getData(ApiUrl.vendorBookingsByStatus(status: status),);

      if (response.statusCode == 200 && response.body != null) {
        final bookingResponse =
        MyVenueBookingResponseModel.fromJson(response.body);

        if (bookingResponse.data != null) {
          bookings.addAll(bookingResponse.data!);
        }

        totalBookings.value = bookingResponse.meta?.total ?? 0;
        final limit = bookingResponse.meta?.limit ?? 10;
        totalPages =
            ((bookingResponse.meta?.total ?? 0) / limit).ceil();

        currentPage++;
      }
    } catch (e) {
      print("Vendor booking error: $e");
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }

  /// ✅ ONLY NEW METHOD
  String _mapStatus(String uiStatus) {
    switch (uiStatus) {
      case "Requested":
        return "new_request";
      case "Ongoing":
        return "ongoing";
      case "Completed":
        return "completed";
      default:
        return "new_request";
    }
  }
}
