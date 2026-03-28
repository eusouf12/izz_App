import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../service/api_check.dart';
import '../../../../../service/api_client.dart';
import '../../../../../service/api_url.dart';
import '../../../../../utils/ToastMsg/toast_message.dart';
import '../../../user_part/user_home_screen/model/sports_type_model.dart';
import '../../../user_part/user_home_screen/model/user_venue_details_model.dart';
import '../../../user_part/user_home_screen/user_home_controller/sports_type_controller.dart';
import 'vendor_my_venue_controller.dart';

class EditVenueController extends GetxController {
  // ================= TEXT CONTROLLERS =================
  final venueNameController = TextEditingController();
  final priceController = TextEditingController();
  final capacityController = TextEditingController();
  final courtNumberController = TextEditingController();
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();

  // ================= VARIABLES =================
  var isLoading = false.obs;
  var isUpdating = false.obs;
  String venueId = "";

  var selectedImage = Rx<File?>(null);
  var networkImage = "".obs;

  // Sports list (populated from API)
  RxList<String> sportsTypeList = <String>[].obs;
  late final SportsTypeController sportsTypeController;
  var selectedSportType = ''.obs;

  final daysList = [
    "SUNDAY",
    "MONDAY",
    "TUESDAY",
    "WEDNESDAY",
    "THURSDAY",
    "FRIDAY",
    "SATURDAY",
  ];

  var amenitiesList = [].obs;
  var selectedAmenities = <String>[].obs;

  var scheduleList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    sportsTypeController = Get.put(SportsTypeController());
    ever<List<SportsType>>(sportsTypeController.sportsList, (_) {
      final names = sportsTypeController.sportsList
          .where((e) => e.sportName != null && e.sportName!.trim().isNotEmpty)
          .map((e) => e.sportName!.trim())
          .toList();
      sportsTypeList.assignAll(names);
      // If venue data already loaded, sync selectedSportType against the new list
      if (sportsTypeList.isNotEmpty && selectedSportType.value.isEmpty) {
        selectedSportType.value = sportsTypeList.first;
      }
    });
    if (sportsTypeController.sportsList.isEmpty) {
      sportsTypeController.getAllSports();
    } else {
      // Sports already cached — populate immediately
      final names = sportsTypeController.sportsList
          .where((e) => e.sportName != null && e.sportName!.trim().isNotEmpty)
          .map((e) => e.sportName!.trim())
          .toList();
      sportsTypeList.assignAll(names);
    }
    if (Get.arguments != null) {
      venueId = Get.arguments;
      getVenueDetails(venueId);
    }
  }

  Future<void> getVenueDetails(String id) async {
    isLoading.value = true;
    try {
      final response = await ApiClient.getData(ApiUrl.userVenueDetails(id: id));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = response.body is String
            ? jsonDecode(response.body)
            : response.body;

        final venueResponse = VenueDetailsResponse.fromJson(jsonResponse);
        final venue = venueResponse.data;

        venueNameController.text = venue.venueName;
        priceController.text = venue.pricePerHour.toString();
        capacityController.text = venue.capacity.toString();
        courtNumberController.text = venue.courtNumbers.toString();
        locationController.text = venue.location;
        descriptionController.text = venue.description;

        final venueSport = venue.sportsType.trim();
        // Match against the API list (case-insensitive); fall back to raw value
        final matched = sportsTypeList.firstWhereOrNull(
          (s) => s.toLowerCase() == venueSport.toLowerCase(),
        );
        selectedSportType.value = matched ?? venueSport;

        networkImage.value = venue.venueImage;

        selectedAmenities.clear();
        for (var element in venue.amenities) {
          selectedAmenities.add(element.amenityName);
          if (!amenitiesList.contains(element.amenityName)) {
            amenitiesList.add(element.amenityName);
          }
        }

        scheduleList.clear();
        for (var availability in venue.venueAvailabilities) {
          List<Map<String, String>> slots = [];
          for (var slot in availability.scheduleSlots) {
            slots.add({"start": slot.from, "end": slot.to});
          }

          String apiDay = availability.day.toUpperCase();
          if (!daysList.contains(apiDay)) {
            apiDay = daysList.firstWhere(
              (d) => d.toUpperCase() == apiDay,
              orElse: () => "SUNDAY",
            );
          }

          scheduleList.add({"day": apiDay, "isActive": true, "slots": slots});
        }

        if (scheduleList.isEmpty) {
          addNewDayBlock();
        }
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      showCustomSnackBar("Error fetching data: $e", isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  int _timeToMinutes(String timeString) {
    try {
      final format = RegExp(r"(\d+):(\d+)\s(AM|PM)");
      final match = format.firstMatch(timeString);
      if (match == null) return 0;

      int hour = int.parse(match.group(1)!);
      int minute = int.parse(match.group(2)!);
      String period = match.group(3)!;

      if (period == 'PM' && hour != 12) hour += 12;
      if (period == 'AM' && hour == 12) hour = 0;

      return (hour * 60) + minute;
    } catch (e) {
      return 0;
    }
  }

  bool validateScheduleOverlap() {
    for (var dayBlock in scheduleList) {
      if (dayBlock['isActive'] == true) {
        List slots = dayBlock['slots'];
        String dayName = dayBlock['day'];

        for (int i = 0; i < slots.length; i++) {
          int startA = _timeToMinutes(slots[i]['start']);
          int endA = _timeToMinutes(slots[i]['end']);

          if (startA >= endA) {
            showCustomSnackBar(
              "$dayName: Start time cannot be greater or equal to End time.",
              isError: true,
            );
            return false;
          }

          for (int j = i + 1; j < slots.length; j++) {
            int startB = _timeToMinutes(slots[j]['start']);
            int endB = _timeToMinutes(slots[j]['end']);

            if (startA < endB && endA > startB) {
              showCustomSnackBar(
                "Time conflict detected on $dayName.\n(${slots[i]['start']}-${slots[i]['end']}) overlaps with (${slots[j]['start']}-${slots[j]['end']})",
                isError: true,
              );
              return false;
            }
          }
        }
      }
    }
    return true;
  }

  // ===================== update =========================================
  Future<void> updateVenue() async {
    isUpdating.value = true;

    String priceInput = priceController.text.trim();
    String capacityInput = capacityController.text.trim();
    String courtInput = courtNumberController.text.trim();

    if (priceInput.isEmpty || capacityInput.isEmpty || courtInput.isEmpty) {
      showCustomSnackBar("All numeric fields are required!", isError: true);
      isUpdating.value = false;
      return;
    }

    double? price = double.tryParse(priceInput);
    int? capacity = int.tryParse(capacityInput);
    int? courtNumbers = int.tryParse(courtInput);

    if (price == null || capacity == null || courtNumbers == null) {
      showCustomSnackBar("Invalid number format!", isError: true);
      isUpdating.value = false;
      return;
    }

    if (price < 0 || capacity < 0 || courtNumbers < 0) {
      showCustomSnackBar("Values cannot be negative!", isError: true);
      isUpdating.value = false;
      return;
    }

    if (!validateScheduleOverlap()) {
      isUpdating.value = false;
      return;
    }

    try {
      Map<String, String> fields = {
        "venueName": venueNameController.text,
        "sportsType": selectedSportType.value,
        "pricePerHour": price.toString(),
        "capacity": capacity.toString(),
        "courtNumbers": courtNumbers.toString(),
        "location": locationController.text,
        "description": descriptionController.text,
      };

      for (int i = 0; i < selectedAmenities.length; i++) {
        fields["amenities[$i][amenityName]"] = selectedAmenities[i];
      }

      int dayIndex = 0;
      for (var dayBlock in scheduleList) {
        if (dayBlock['isActive'] == true) {
          fields["venueAvailabilities[$dayIndex][day]"] = dayBlock['day'];

          List slots = dayBlock['slots'];
          for (int slotIndex = 0; slotIndex < slots.length; slotIndex++) {
            fields["venueAvailabilities[$dayIndex][scheduleSlots][$slotIndex][from]"] =
                slots[slotIndex]['start'];
            fields["venueAvailabilities[$dayIndex][scheduleSlots][$slotIndex][to]"] =
                slots[slotIndex]['end'];
          }
          dayIndex++;
        }
      }

      List<MultipartBody> multipartBody = [];
      if (selectedImage.value != null) {
        multipartBody.add(MultipartBody("venueImage", selectedImage.value!));
      }

      // Call the API with the reconstructed fields
      final response = await ApiClient.patchMultipartData(
        ApiUrl.updateVenue(id: venueId),
        fields,
        multipartBody: multipartBody,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        showCustomSnackBar("Venue updated successfully!", isError: false);

        if (Get.isRegistered<VendorMyVenueController>()) {
          Get.find<VendorMyVenueController>().getMyVenues();
        }
      } else {
        String msg = response.statusText ?? "Update failed";
        try {
          if (response.body is String) {
            var json = jsonDecode(response.body);
            if (json['message'] != null) msg = json['message'];
          } else if (response.body is Map && response.body['message'] != null) {
            msg = response.body['message'];
          }
        } catch (e) {
          debugPrint("Error parsing error msg: $e");
        }
        showCustomSnackBar(msg, isError: true);
      }
    } catch (e) {
      showCustomSnackBar("Something went wrong: $e", isError: true);
      debugPrint("Update Exception: $e");
    } finally {
      isUpdating.value = false;
    }
  }

  // ================= 3. HELPER FUNCTIONS =================

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  void toggleAmenity(String amenity) {
    if (selectedAmenities.contains(amenity)) {
      selectedAmenities.remove(amenity);
    } else {
      selectedAmenities.add(amenity);
    }
  }

  void addCustomAmenity(String name) {
    if (name.isNotEmpty && !amenitiesList.contains(name)) {
      amenitiesList.add(name);
      Get.back();
    }
  }

  // Schedule Logic
  void addNewDayBlock() {
    scheduleList.add({
      "day": "SUNDAY",
      "isActive": true,
      "slots": [
        {"start": "09:00 AM", "end": "10:00 AM"},
      ],
    });
  }

  void removeDayBlock(int index) {
    if (scheduleList.length > 1) {
      scheduleList.removeAt(index);
    } else {
      showCustomSnackBar(
        "At least one day schedule is required",
        isError: true,
      );
    }
  }

  void changeDay(int index, String? newDay) {
    if (newDay != null) {
      var item = scheduleList[index];
      item['day'] = newDay;
      scheduleList[index] = item;
      scheduleList.refresh();
    }
  }

  void toggleScheduleActive(int index, bool? val) {
    var item = scheduleList[index];
    item['isActive'] = val ?? false;
    scheduleList[index] = item;
    scheduleList.refresh();
  }

  void addSlotToDay(int dayIndex) {
    final dayBlock = Map<String, dynamic>.from(scheduleList[dayIndex]);
    final slots = List<Map<String, dynamic>>.from(
      (dayBlock['slots'] as List).map((s) => Map<String, dynamic>.from(s)),
    );
    slots.add({"start": "12:00 PM", "end": "01:00 PM"});
    dayBlock['slots'] = slots;
    scheduleList[dayIndex] = dayBlock;
  }

  void removeSlotFromDay(int dayIndex, int slotIndex) {
    final dayBlock = Map<String, dynamic>.from(scheduleList[dayIndex]);
    final slots = List<Map<String, dynamic>>.from(
      (dayBlock['slots'] as List).map((s) => Map<String, dynamic>.from(s)),
    );
    if (slots.length > 1) {
      slots.removeAt(slotIndex);
      dayBlock['slots'] = slots;
      scheduleList[dayIndex] = dayBlock;
    } else {
      showCustomSnackBar("At least one slot required", isError: true);
    }
  }

  void changeTime(int dayIndex, int slotIndex, String key, int minutes) {
    final dayBlock = Map<String, dynamic>.from(scheduleList[dayIndex]);
    final slots = List<Map<String, dynamic>>.from(
      (dayBlock['slots'] as List).map((s) => Map<String, dynamic>.from(s)),
    );
    final currentTime = slots[slotIndex][key] as String;
    slots[slotIndex][key] = _adjustTime(currentTime, minutes);
    dayBlock['slots'] = slots;
    scheduleList[dayIndex] = dayBlock;
  }

  String _adjustTime(String currentTime, int minutesToAdd) {
    try {
      final format = RegExp(r"(\d+):(\d+)\s(AM|PM)");
      final match = format.firstMatch(currentTime);
      if (match == null) return currentTime;
      int hour = int.parse(match.group(1)!);
      int minute = int.parse(match.group(2)!);
      String period = match.group(3)!;
      if (period == 'PM' && hour != 12) hour += 12;
      if (period == 'AM' && hour == 12) hour = 0;
      final now = DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, hour, minute);
      final newDt = dt.add(Duration(minutes: minutesToAdd));
      final newTimeOfDay = TimeOfDay.fromDateTime(newDt);
      final h = newTimeOfDay.hourOfPeriod == 0 ? 12 : newTimeOfDay.hourOfPeriod;
      final m = newTimeOfDay.minute.toString().padLeft(2, '0');
      final p = newTimeOfDay.period == DayPeriod.am ? 'AM' : 'PM';
      return "$h:$m $p";
    } catch (e) {
      return currentTime;
    }
  }
}
