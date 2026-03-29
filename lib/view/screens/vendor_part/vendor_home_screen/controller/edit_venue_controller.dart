import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../service/api_client.dart';
import '../../../../../service/api_url.dart';
import '../../../../../utils/ToastMsg/toast_message.dart';
import '../../../user_part/user_home_screen/model/sports_type_model.dart';
import '../../../user_part/user_home_screen/model/user_venue_details_model.dart';
import '../../../user_part/user_home_screen/user_home_controller/sports_type_controller.dart';
import 'vendor_my_venue_controller.dart';

class EditVenueController extends GetxController {
  final venueNameController = TextEditingController();
  final priceController = TextEditingController();
  final capacityController = TextEditingController();
  final courtNumberController = TextEditingController();
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();

  var isLoading = false.obs;
  var isUpdating = false.obs;
  String venueId = "";

  var selectedImage = Rx<File?>(null);
  var networkImage = "".obs;
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var venueStatus = true.obs;

  RxList<String> sportsTypeList = <String>[].obs;
  late final SportsTypeController sportsTypeController;
  var selectedSportType = ''.obs;

  final daysList = [
    "SUNDAY", "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY",
  ];

  var amenitiesList = [].obs;
  var selectedAmenities = <String>[].obs;
  
  var scheduleList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    sportsTypeController = Get.put(SportsTypeController());
    
    ever<List<SportsType>>(sportsTypeController.sportsList, (_) {
      _populateSportsList();
    });

    if (sportsTypeController.sportsList.isEmpty) {
      sportsTypeController.getAllSports();
    } else {
      _populateSportsList();
    }

    if (Get.arguments != null) {
      venueId = Get.arguments;
      getVenueDetails(venueId);
    }
  }

  void _populateSportsList() {
    final names = sportsTypeController.sportsList
        .where((e) => e.sportName != null && e.sportName!.trim().isNotEmpty)
        .map((e) => e.sportName!.trim())
        .toList();
    sportsTypeList.assignAll(names);
    if (sportsTypeList.isNotEmpty && selectedSportType.value.isEmpty) {
      selectedSportType.value = sportsTypeList.first;
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
        courtNumberController.text = venue.courtNumbers.length.toString();
        locationController.text = venue.location;
        descriptionController.text = venue.description;
        venueStatus.value = venue.venueStatus;
        networkImage.value = venue.venueImage;

        selectedSportType.value = venue.sportsType;

        selectedAmenities.assignAll(venue.amenities.map((e) => e.amenityName));
        for (var a in venue.amenities) {
          if (!amenitiesList.contains(a.amenityName)) amenitiesList.add(a.amenityName);
        }

        scheduleList.clear();
        for (var availability in venue.venueAvailabilities) {
          List<Map<String, dynamic>> slots = [];
          for (var slot in availability.scheduleSlots) {
            slots.add({
              "id": slot.id, 
              "start": slot.from, 
              "end": slot.to
            });
          }

          scheduleList.add({
            "id": availability.id,
            "day": availability.day.toUpperCase(),
            "isActive": true,
            "slots": slots,
          });
        }

        if (scheduleList.isEmpty) addNewDayBlock();
      }
    } catch (e) {
      debugPrint("Fetch Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ===================== UPDATE VENUE (FINAL LOGIC) =====================
  Future<void> updateVenue() async {
    if (isUpdating.value) return;
    isUpdating.value = true;

    try {
      if (!validateScheduleOverlap()) {
        isUpdating.value = false;
        return;
      }

      final Map<String, List<Map<String, String>>> mergedDays = {};
      for (var dayBlock in scheduleList) {
        if (dayBlock['isActive'] == true) {
          String dayKey = dayBlock['day'].toString().toUpperCase();
          if (!mergedDays.containsKey(dayKey)) {
            mergedDays[dayKey] = [];
          }
          for (var slot in (dayBlock['slots'] as List)) {
            mergedDays[dayKey]!.add({
              "from": slot['start'].toString(),
              "to": slot['end'].toString()
            });
          }
        }
      }

      // ২. Merged Map কে List এ রূপান্তর (পোস্টম্যান ফরম্যাট)
      final List<Map<String, dynamic>> availabilitiesData = mergedDays.entries.map((e) {
        // "MONDAY" -> "Monday" (as per Postman example)
        String capitalizedDay = e.key.toLowerCase().capitalizeFirst ?? e.key;
        return {
          "day": capitalizedDay,
          "scheduleSlots": e.value,
        };
      }).toList();

  
      int count = int.tryParse(courtNumberController.text) ?? 1;
      List<int> courtList = List.generate(count, (index) => index + 1);


      final Map<String, dynamic> venueData = {
        "venueName": venueNameController.text.trim(),
        "sportsType": selectedSportType.value,
        
        "pricePerHour": (double.tryParse(priceController.text) ?? 0.0).toString(),
        "capacity": (int.tryParse(capacityController.text) ?? 0).toString(),
        
        "courtNumbers": courtList, 
        "location": locationController.text.trim(),
        "latitude": latitude.value,
        "longitude": longitude.value,
        "description": descriptionController.text.trim(),
        "venueStatus": venueStatus.value,
        "amenities": selectedAmenities.map((a) => {"amenityName": a}).toList(),
        "venueAvailabilities": availabilitiesData,
      };

      debugPrint("====> Venue Availabilities Payload: ${jsonEncode({"venueAvailabilities": availabilitiesData})}");
      debugPrint("====> Full Data Body: ${jsonEncode(venueData)}");
      final response = await ApiClient.patchMultipartData(
        ApiUrl.updateVenue(id: venueId),
        {"data": jsonEncode(venueData)},
        multipartBody: selectedImage.value != null 
            ? [MultipartBody("venueImage", selectedImage.value!)] 
            : [],
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        showCustomSnackBar("Venue updated successfully!", isError: false);
        if (Get.isRegistered<VendorMyVenueController>()) {
          Get.find<VendorMyVenueController>().getMyVenues();
        }
      } else {
        showCustomSnackBar(response.statusText ?? "Update failed", isError: true);
      }
    } catch (e) {
      showCustomSnackBar("Error: $e", isError: true);
    } finally {
      isUpdating.value = false;
    }
  }

  // ===================== HELPER FUNCTIONS =====================

  void addNewDayBlock() {
    scheduleList.add({
      "day": "SUNDAY",
      "isActive": true,
      "slots": [
        {"start": "09:00 AM", "end": "10:00 AM"},
      ],
    });
    scheduleList.refresh(); 
  }

  void removeDayBlock(int index) {
    if (scheduleList.length > 1) {
      scheduleList.removeAt(index);
      scheduleList.refresh();
    }
  }

  void addSlotToDay(int dayIndex) {
    var day = scheduleList[dayIndex];
    (day['slots'] as List).add({"start": "10:00 AM", "end": "11:00 AM"});
    scheduleList[dayIndex] = day;
    scheduleList.refresh();
  }

  void removeSlotFromDay(int dayIndex, int slotIndex) {
    var day = scheduleList[dayIndex];
    if ((day['slots'] as List).length > 1) {
      (day['slots'] as List).removeAt(slotIndex);
      scheduleList[dayIndex] = day;
      scheduleList.refresh();
    }
  }

  void changeDay(int index, String? newDay) {
    if (newDay != null) {
      scheduleList[index]['day'] = newDay;
      scheduleList.refresh();
    }
  }

  void toggleScheduleActive(int index, bool? val) {
    scheduleList[index]['isActive'] = val ?? false;
    scheduleList.refresh();
  }

  bool validateScheduleOverlap() {
    for (var dayBlock in scheduleList) {
      if (dayBlock['isActive'] == true) {
        List slots = dayBlock['slots'];
        for (int i = 0; i < slots.length; i++) {
          int startA = _timeToMinutes(slots[i]['start']);
          int endA = _timeToMinutes(slots[i]['end']);
          if (startA >= endA) {
            showCustomSnackBar("${dayBlock['day']}: Invalid Time", isError: true);
            return false;
          }
        }
      }
    }
    return true;
  }

  int _timeToMinutes(String timeString) {
    try {
      final format = RegExp(r"(\d+):(\d+)\s(AM|PM)");
      final match = format.firstMatch(timeString);
      if (match == null) return 0;
      int hour = int.parse(match.group(1)!);
      int minute = int.parse(match.group(2)!);
      if (match.group(3) == 'PM' && hour != 12) hour += 12;
      if (match.group(3) == 'AM' && hour == 12) hour = 0;
      return (hour * 60) + minute;
    } catch (_) { return 0; }
  }

  void changeTime(int dayIndex, int slotIndex, String key, int minutes) {
    var day = scheduleList[dayIndex];
    var slots = day['slots'] as List;
    slots[slotIndex][key] = _adjustTime(slots[slotIndex][key], minutes);
    scheduleList[dayIndex] = day;
    scheduleList.refresh();
  }

  String _adjustTime(String currentTime, int minutesToAdd) {
    try {
      final format = RegExp(r"(\d+):(\d+)\s(AM|PM)");
      final match = format.firstMatch(currentTime);
      if (match == null) return currentTime;
      int hour = int.parse(match.group(1)!);
      int minute = int.parse(match.group(2)!);
      if (match.group(3) == 'PM' && hour != 12) hour += 12;
      if (match.group(3) == 'AM' && hour == 12) hour = 0;
      final dt = DateTime(2024, 1, 1, hour, minute).add(Duration(minutes: minutesToAdd));
      final h = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
      final p = dt.hour >= 12 ? 'PM' : 'AM';
      return "$h:${dt.minute.toString().padLeft(2, '0')} $p";
    } catch (e) { return currentTime; }
  }

  Future<void> pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) selectedImage.value = File(image.path);
  }

  void toggleAmenity(String amenity) {
    selectedAmenities.contains(amenity) ? selectedAmenities.remove(amenity) : selectedAmenities.add(amenity);
  }
  final customAmenityController = TextEditingController(); 
  void addCustomAmenity(String name) {
    String cleanName = name.trim();
    if (cleanName.isNotEmpty) {
      // যদি আগে থেকে লিস্টে না থাকে তবে অ্যাড হবে
      if (!amenitiesList.contains(cleanName)) {
        amenitiesList.add(cleanName);
      }
      
      // অটোমেটিক সিলেক্ট করে দেওয়া
      if (!selectedAmenities.contains(cleanName)) {
        selectedAmenities.add(cleanName);
      }
      
      customAmenityController.clear();
      Get.back(); 
    } else {
      showCustomSnackBar("Amenity name cannot be empty", isError: true);
    }
  }
}