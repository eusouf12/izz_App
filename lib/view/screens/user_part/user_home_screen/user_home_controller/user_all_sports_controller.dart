import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../../service/api_client.dart';
import '../../../../../service/api_url.dart';
import '../../../../../utils/ToastMsg/toast_message.dart';
import '../model/all_sports_model.dart';

class UserAllSportsController extends GetxController{

  var sportsVenueGroups = <SportsVenueGroup>[].obs;
  var isLoading = false.obs;
  var isLoadMore = false.obs;
  int currentPage = 1;
  int totalPage = 1;
  var currentSliderIndex = 0.obs;

  /// SORT
  RxString selectedSort = ''.obs;

  /// SPORTS (Single Selection er jonno String bebohar kora hoyeche)
  RxString selectedSport = ''.obs;
  final List<String> sportsList = [
    "FOOTBALL", "TENNIS", "BADMINTON", "PICKLEBALL",
    "SWIMMING", "RUGBY", "PILATES", "TAKRAW"
  ];

  /// LOCATION (Single Selection er jonno String bebohar kora hoyeche)
  RxString selectedLocation = ''.obs;
  final List<String> locationsList = [
    "Petaling Jaya", "Ampang", "Subang Jaya", "Bangsar",
    "Damansara", "Shah Alam", "Klang", "Putrajaya"
  ];

  /// PRICE RANGE
  RxDouble minPrice = 0.0.obs;
  RxDouble maxPrice = 500.0.obs;

  // Single select korar logic
  void selectSport(String sport) {
    if (selectedSport.value == sport) {
      selectedSport.value = '';
    } else {
      selectedSport.value = sport;
      debugPrint("Filter $sport selected");
    }
  }

  void selectLocation(String location) {
    if (selectedLocation.value == location) {
      selectedLocation.value = '';
    } else {
      selectedLocation.value = location;
    }
  }

  void reset() {
    selectedSort.value = '';
    selectedSport.value = '';
    selectedLocation.value = '';
    minPrice.value = 0.0;
    maxPrice.value = 500.0;
    debugPrint("Filter Reset: All values cleared");
  }

  @override
  void onClose() {
    reset();
    super.onClose();
  }


  @override
  void onInit() {
    super.onInit();
    allSports();
  }

  Future<void> allSports({bool loadMore = false}) async {
    if (isLoading.value || isLoadMore.value) return;

    try {
      if (loadMore) {
        if (currentPage >= totalPage) return;
        isLoadMore.value = true;
        currentPage++;
      } else {
        isLoading.value = true;
        currentPage = 1;
        sportsVenueGroups.clear();
      }

      final response = await ApiClient.getData(ApiUrl.allSports(page: currentPage.toString()));


      final Map<String, dynamic> jsonResponse =
      response.body is String
          ? jsonDecode(response.body)
          : response.body;

      if (response.statusCode == 200 || response.statusCode == 201) {

        final venueResponse = VenueResponse.fromJson(jsonResponse);

        final meta = venueResponse.data.meta;
        totalPage = (meta.total / meta.limit).ceil();

        sportsVenueGroups.addAll(venueResponse.data.data);

      } else {
        showCustomSnackBar(
          jsonResponse['message']?.toString() ?? "Update failed",
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


  /// Filtered venue list
  var filteredSportsVenueGroups = <SportsVenueGroup>[].obs;

  /// Loading states
  var isFilteringLoading = false.obs;
  var isFilteringLoadMore = false.obs;

  /// Pagination
  int filterCurrentPage = 1;
  int filterTotalPage = 1;

  /// Filtering all sports venues
  Future<void> filterSports({bool loadMore = false,}) async {
    if (isFilteringLoading.value || isFilteringLoadMore.value) return;

    try {
      if (loadMore) {
        if (filterCurrentPage >= filterTotalPage) return;
        isFilteringLoadMore.value = true;
        filterCurrentPage++;
      } else {
        isFilteringLoading.value = true;
        filterCurrentPage = 1;
        filteredSportsVenueGroups.clear();
      }

      final response = await ApiClient.getData(ApiUrl.filterSports(page: filterCurrentPage.toString(), filter: selectedSport.value,),);

      final Map<String, dynamic> jsonResponse = response.body is String ? jsonDecode(response.body) : response.body;

      if (response.statusCode == 200 || response.statusCode == 201) {
        final venueResponse = VenueResponse.fromJson(jsonResponse);

        final meta = venueResponse.data.meta;
        filterTotalPage = (meta.total / meta.limit).ceil();

        filteredSportsVenueGroups.addAll(
          venueResponse.data.data,
        );
      } else {
        showCustomSnackBar(
          jsonResponse['message']?.toString() ?? "Filtering failed",
          isError: true,
        );
      }
    } catch (e) {
      showCustomSnackBar(e.toString(), isError: true);
    } finally {
      isFilteringLoading.value = false;
      isFilteringLoadMore.value = false;
      update();
    }
  }



}
