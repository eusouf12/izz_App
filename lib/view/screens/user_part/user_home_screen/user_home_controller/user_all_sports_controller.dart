import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../../service/api_client.dart';
import '../../../../../service/api_url.dart';
import '../../../../../utils/ToastMsg/toast_message.dart';
import '../model/all_sports_model.dart';

class UserAllSportsController extends GetxController{

  /// SPORTS (Single Selection er jonno String bebohar kora hoyeche)
  RxString selectedVenue = ''.obs;
  RxString selectedLocation = ''.obs;
  RxDouble minPrice = 0.0.obs;
  RxDouble maxPrice = 500.0.obs;

  RxList<String> locationsList = <String>[].obs;
  RxList<String> venuesNameList = <String>[].obs;
  // Single select korar logic
  void selectVenues(String sport) {
    if (selectedVenue.value == sport) {
      selectedVenue.value = '';
    } else {
      selectedVenue.value = sport;
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
    selectedVenue.value = '';
    selectedLocation.value = '';
    minPrice.value = 0.0;
    maxPrice.value = 500.0;
    debugPrint("Filter Reset: All values cleared");
  }

  //===================get filter location and venues name ================
  var sportsVenueGroups = <SportsVenueGroup>[].obs;
  var isLoading = false.obs;
  var isLoadMore = false.obs;
  RxInt currentPage = 1.obs;
  RxInt totalPage = 1.obs;
  var currentSliderIndex = 0.obs;
  Future<void> getAllLocVenueFilter({bool loadMore = false, String? filter}) async {
    if (isLoading.value || isLoadMore.value) return;

    try {
      if (loadMore) {
        if (currentPage >= totalPage.value) return;
        isLoadMore.value = true;
        currentPage++;
      } else {
        isLoading.value = true;
        currentPage.value = 1;
        locationsList.clear();
        venuesNameList.clear();
        sportsVenueGroups.clear();
      }

      final url = ApiUrl.getFilterLocVenueName(page: currentPage.toString(), sportsType: filter);
      final response = await ApiClient.getData(url);

      final Map<String, dynamic> jsonResponse = response.body is String ? jsonDecode(response.body) : response.body;

      if (response.statusCode == 200 || response.statusCode == 201) {
        final venueResponse = VenueResponse.fromJson(jsonResponse);

        final meta = venueResponse.data.meta;
        totalPage.value = (meta.total / (meta.limit ?? 10)).ceil();
        currentPage.value = sportsCurrentPage;

        final newGroups = venueResponse.data.data;
        final Set<String> locations = {};
        final Set<String> venues = {};

        for (var group in newGroups) {
            for (var venue in group.venues) {
              if ( venue.location.isNotEmpty) {
                locations.add(venue.location);
              }
              if ( venue.venueName.isNotEmpty) {
                venues.add(venue.venueName);
              }
            }
        }

        if (!loadMore) {
          locationsList.assignAll(locations.toList());
          venuesNameList.assignAll(venues.toList());
        } else {
          locationsList.addAll(locations.where((e) => !locationsList.contains(e)));
          venuesNameList.addAll(venues.where((e) => !venuesNameList.contains(e)));
        }
      }
    } catch (e) {
      debugPrint("FILTER ERROR => $e");
      showCustomSnackBar("Error loading filters: $e", isError: true);
    } finally {
      isLoading.value = false;
      isLoadMore.value = false;
    }
  }

//=================== Get All Venues under sport by search ================
  var allSportsVenueFilter = <SportsVenueGroup>[].obs;
  RxBool isSportsLoading = false.obs;
  RxBool isSportsLoadMore = false.obs;
  int sportsCurrentPage = 1;
  int sportsTotalPage = 1;
  Future<void> allSports({bool isLoadMoreRequest = false, String? filter,VoidCallback? onSuccess}) async {

    if (isSportsLoading.value || isSportsLoadMore.value) return;

    try {

      if (isLoadMoreRequest) {
        if (sportsCurrentPage >= sportsTotalPage) return;

        isSportsLoadMore.value = true;
        sportsCurrentPage++;
      }
      else {
        isSportsLoading.value = true;
        sportsCurrentPage = 1;
        sportsVenueGroups.clear();
      }

      final url = ApiUrl.allSports(
        page: sportsCurrentPage.toString(),
        sportsType: filter,
        minPrice: minPrice.value > 0 ? minPrice.value.toInt().toString() : null,
        maxPrice: maxPrice.value < 500 ? maxPrice.value.toInt().toString() : null,
        location: selectedLocation.value.isNotEmpty ? selectedLocation.value : null,
        searchTerm: selectedVenue.value.isNotEmpty ? selectedVenue.value : null,
      );

      debugPrint("Calling Filtered URL: $url");

      final response = await ApiClient.getData(url);

      final jsonResponse = response.body is String ? jsonDecode(response.body) : response.body;

      if (response.statusCode == 200 || response.statusCode == 201) {

        final venueResponse = VenueResponse.fromJson(jsonResponse);

        final meta = venueResponse.data.meta;
        sportsTotalPage = (meta.total / meta.limit).ceil();

        final newGroups = venueResponse.data.data;

        if (!isLoadMoreRequest) {
          allSportsVenueFilter.assignAll(newGroups);
        } else {
          allSportsVenueFilter.addAll(newGroups);
        }

        if (onSuccess != null) {
          onSuccess();
        }

      } else {
        showCustomSnackBar(
          jsonResponse['message'] ?? "Failed",
          isError: true,
        );
      }

    } catch (e) {
      showCustomSnackBar(e.toString(), isError: true);
    } finally {
      isSportsLoading.value = false;
      isSportsLoadMore.value = false;
    }
  }


  // /// Filtered venue list
  // var filteredSportsVenueGroups = <SportsVenueGroup>[].obs;
  //
  // /// Loading states
  // var isFilteringLoading = false.obs;
  // var isFilteringLoadMore = false.obs;
  //
  // /// Pagination
  // int filterCurrentPage = 1;
  // int filterTotalPage = 1;
  //
  // /// Filtering all sports venues
  // Future<void> filterSports({bool loadMore = false,}) async {
  //   if (isFilteringLoading.value || isFilteringLoadMore.value) return;
  //
  //   try {
  //     if (loadMore) {
  //       if (filterCurrentPage >= filterTotalPage) return;
  //       isFilteringLoadMore.value = true;
  //       filterCurrentPage++;
  //     } else {
  //       isFilteringLoading.value = true;
  //       filterCurrentPage = 1;
  //       filteredSportsVenueGroups.clear();
  //     }
  //
  //     final response = await ApiClient.getData(ApiUrl.filterSports(page: filterCurrentPage.toString(), filter: selectedSport.value,),);
  //
  //     final Map<String, dynamic> jsonResponse = response.body is String ? jsonDecode(response.body) : response.body;
  //
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       final venueResponse = VenueResponse.fromJson(jsonResponse);
  //
  //       final meta = venueResponse.data.meta;
  //       filterTotalPage = (meta.total / meta.limit).ceil();
  //
  //       filteredSportsVenueGroups.addAll(
  //         venueResponse.data.data,
  //       );
  //     } else {
  //       showCustomSnackBar(
  //         jsonResponse['message']?.toString() ?? "Filtering failed",
  //         isError: true,
  //       );
  //     }
  //   } catch (e) {
  //     showCustomSnackBar(e.toString(), isError: true);
  //   } finally {
  //     isFilteringLoading.value = false;
  //     isFilteringLoadMore.value = false;
  //     update();
  //   }
  // }



}
