import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:izz_atlas_app/view/screens/vendor_part/vendor_home_screen/controller/vendor_my_venue_controller.dart';
import '../../../../../service/api_client.dart';
import '../../../../../service/api_url.dart';
import '../../../user_part/user_home_screen/model/sports_type_model.dart';
import '../../../user_part/user_home_screen/user_home_controller/sports_type_controller.dart';

class AddVenueController extends GetxController {
  final VendorMyVenueController vendorMyVenueController = Get.put(VendorMyVenueController());
  // Text Controllers
  final TextEditingController venueNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController capacityController = TextEditingController();
  final TextEditingController courtNumberController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController newAmenityController = TextEditingController();

  // Reactive variables
  var selectedSportType = ''.obs;
  var isVenueActive = true.obs;
  var isLoading = false.obs;

  // Image selection
  var selectedImage = Rxn<File>();
  final ImagePicker _picker = ImagePicker();

  // Amenities
  var selectedAmenities = <String>[].obs;
  var customAmenities = <String>[].obs;

  // Sports list (populated from API)
  RxList<String> sportsTypeList = <String>[].obs;
  // Location suggestion list (for autocomplete)
  RxList<Map<String, dynamic>> locationSuggestions = <Map<String, dynamic>>[].obs;
  // Selected coordinates
  var selectedLatitude = 0.0.obs;
  var selectedLongitude = 0.0.obs;
  Timer? _locationDebounce;
  late final SportsTypeController sportsTypeController;

  // Schedule logic
  final List<String> daysList = [
    "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
  ];

  var scheduleList = <Map<String, dynamic>>[{
    "day": "Sunday",
    "isActive": true,
    "slots": [
      {"start": "09:00 AM", "end": "10:00 AM"}
    ]
  }].obs;

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
      if (sportsTypeList.isNotEmpty && selectedSportType.value == '') {
        selectedSportType.value = sportsTypeList.first;
      }
    });
    if (sportsTypeController.sportsList.isEmpty) {
      sportsTypeController.getAllSports();
    }
  }

  @override
  void onClose() {
    _locationDebounce?.cancel();
    super.onClose();
  }

  // Search locations using Nominatim (OpenStreetMap) with a short debounce
  void searchLocations(String query) {
  if (_locationDebounce?.isActive ?? false) _locationDebounce!.cancel();

  _locationDebounce = Timer(const Duration(milliseconds: 500), () async {
    final q = query.trim();
    if (q.isEmpty) {
      locationSuggestions.clear();
      return;
    }

    try {
      // Google Places Autocomplete API URL
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json'
        '?input=${Uri.encodeComponent(q)}'
        '&key=${ApiUrl.mapKey}' 
        '&language=en'
      );

      final resp = await http.get(url);
      
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        final predictions = data['predictions'] as List;

        final suggestions = predictions.map<Map<String, dynamic>>((e) {
          return {
            'name': e['structured_formatting']['main_text'],
            'address': e['description'],
            'place_id': e['place_id'],
          };
        }).toList();
        
        locationSuggestions.assignAll(suggestions);
        
      }
    } catch (e) {
      debugPrint("Google Search Error: $e");
      locationSuggestions.clear();
    }
  });
}

  // When user taps a suggestion
  void selectLocation(Map<String, dynamic> suggestion) {
    locationController.text = suggestion['address'] ?? '';
    selectedLatitude.value = suggestion['lat'] ?? 0.0;
    selectedLongitude.value = suggestion['lon'] ?? 0.0;
    locationSuggestions.clear();
  }

  // Methods for picking image
  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  // Amenity toggle
  void toggleAmenity(String amenity) {
    if (selectedAmenities.contains(amenity)) {
      selectedAmenities.remove(amenity);
    } else {
      selectedAmenities.add(amenity);
    }
  }

  // Add new amenity and automatically select it
  void addNewAmenity() {
    if (newAmenityController.text.trim().isNotEmpty) {
      String name = newAmenityController.text.trim();

      // If it's not already in the custom amenities list, add it
      if (!customAmenities.contains(name)) {
        customAmenities.add(name);
      }

      // Automatically select the new amenity after adding it
      if (!selectedAmenities.contains(name)) {
        selectedAmenities.add(name);
      }

      newAmenityController.clear(); // Clear the input field
      Get.back(); // Close the dialog
    }
  }

  // Schedule methods
  void addNewDayBlock() {
    scheduleList.add({
      "day": "Sunday",
      "isActive": true,
      "slots": [
        {"start": "09:00 AM", "end": "10:00 AM"}
      ]
    });
  }

  void removeDayBlock(int index) {
    if (scheduleList.length > 1) {
      scheduleList.removeAt(index);
    } else {
      Get.snackbar("Alert", "At least one day schedule is required",
          backgroundColor: Colors.orange, colorText: Colors.white);
    }
  }

  void addSlotToDay(int dayIndex) {
    List<Map<String, String>> slots = scheduleList[dayIndex]['slots'];
    slots.add({"start": "10:00 AM", "end": "11:00 AM"});
    scheduleList.refresh();
  }

  void removeSlotFromDay(int dayIndex, int slotIndex) {
    List<Map<String, String>> slots = scheduleList[dayIndex]['slots'];
    if (slots.length > 1) {
      slots.removeAt(slotIndex);
      scheduleList.refresh();
    } else {
      Get.snackbar("Alert", "At least one time slot is required",
          backgroundColor: Colors.orange, colorText: Colors.white);
    }
  }

  void changeDay(int index, String? newDay) {
    if (newDay != null) {
      scheduleList[index]['day'] = newDay;
      scheduleList.refresh();
    }
  }

  void toggleScheduleActive(int index, bool? val) {
    scheduleList[index]['isActive'] = val ?? true;
    scheduleList.refresh();
  }

  // Change the start or end time of a given slot
  void changeTime(int dayIndex, int slotIndex, String key, int minutesToAdd) {
    List<Map<String, String>> slots = scheduleList[dayIndex]['slots'];
    String currentTime = slots[slotIndex][key]!; // "start" or "end"
    slots[slotIndex][key] = _adjustTime(currentTime, minutesToAdd);  // Adjust time based on minutes to add
    scheduleList.refresh();  // Refresh the schedule list
  }

  // Adjust the time by a specified number of minutes
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

  // Convert time to minutes for comparison
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

  // **New Method**: Check if there is already a venue booked for the same day and time
  bool checkForScheduleConflict() {
    for (var dayBlock in scheduleList) {
      if (dayBlock['isActive'] == true) {
        List slots = dayBlock['slots'];
        String dayName = dayBlock['day'];
        for (int i = 0; i < slots.length; i++) {
          int startA = _timeToMinutes(slots[i]['start']);
          int endA = _timeToMinutes(slots[i]['end']);
          if (startA >= endA) {
            Get.snackbar(
              "Time Error",
              "$dayName: Start time cannot be greater or equal to End time.",
              backgroundColor: Colors.red,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
              margin: const EdgeInsets.all(10),
            );
            return false;
          }
          for (int j = i + 1; j < slots.length; j++) {
            int startB = _timeToMinutes(slots[j]['start']);
            int endB = _timeToMinutes(slots[j]['end']);
            if (startA < endB && endA > startB) {
              Get.snackbar(
                "Conflict Detected",
                "$dayName: The time slots ${slots[i]['start']}-${slots[i]['end']} overlap with ${slots[j]['start']}-${slots[j]['end']}. Please select a different time.",
                backgroundColor: Colors.red,
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
                margin: const EdgeInsets.all(10),
              );
              return false;
            }
          }
        }
      }
    }
    return true;
  }

  // Create venue and check for overlaps
  Future<void> createVenue() async {
    if (venueNameController.text.isEmpty || selectedImage.value == null) {
      Get.snackbar(
        "Required",
        "Please fill all fields and select an image",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(10),
      );
      return;
    }

    // Validate schedule overlap before creating the venue
    if (!checkForScheduleConflict()) return;

    try {
      isLoading.value = true;
      List<Map<String, dynamic>> venueAvailabilities = [];
      for (var dayBlock in scheduleList) {
        if (dayBlock['isActive'] == true) {
          List<Map<String, String>> slots = dayBlock['slots'];
          venueAvailabilities.add({
            "day": dayBlock['day'],
            "scheduleSlots": slots.map((s) => {"from": s['start'], "to": s['end']}).toList()
          });
        }
      }

      Map<String, dynamic> venueDataObj = {
        "venueName": venueNameController.text.trim(),
        "sportsType": selectedSportType.value,
        "pricePerHour": int.tryParse(priceController.text.trim()) ?? 0,
        "capacity": int.tryParse(capacityController.text.trim()) ?? 0,
        "location": locationController.text.trim(),
        "description": descriptionController.text.trim(),
        "amenities": selectedAmenities.map((e) => {"amenityName": e}).toList(),
        "courtNumbers": int.tryParse(courtNumberController.text.trim()) ?? 1,
        "venueStatus": isVenueActive.value,
        "venueAvailabilities": venueAvailabilities,
        "latitude": selectedLatitude.value,
        "longitude": selectedLongitude.value,
      };

      Map<String, String> body = {
        'data': jsonEncode(venueDataObj),
      };

      List<MultipartBody> multipartList = [];
      if (selectedImage.value != null) {
        multipartList.add(MultipartBody('venueImage', selectedImage.value!));
      }

      var response = await ApiClient.postMultipartData(
        ApiUrl.createVenue,
        body,
        multipartBody: multipartList,
      );

      isLoading.value = false;
      if (response.statusCode == 200 || response.statusCode == 201) {
        _clearFields();
        vendorMyVenueController.getMyVenues();
        Get.back();
        Get.snackbar(
          "Success",
          "Venue Created Successfully!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(10),
          borderRadius: 8,
          duration: const Duration(seconds: 2),
        );
        return;
      }

      String errorMessage = "Failed to create venue";
      try {
        final decoded = response.body is String ? jsonDecode(response.body) : response.body;
        if (decoded != null && decoded['message'] != null) {
          errorMessage = decoded['message'];
        }
      } catch (_) {}
      Get.snackbar(
        "Error",
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(10),
      );
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        "Error",
        "Something went wrong",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(10),
      );
    }
  }

  // Clear all form fields and reset state
  void _clearFields() {
    venueNameController.clear();
    priceController.clear();
    capacityController.clear();
    courtNumberController.clear();
    locationController.clear();
    descriptionController.clear();
    newAmenityController.clear();
    selectedImage.value = null;
    selectedAmenities.clear();
    customAmenities.clear();
    selectedSportType.value = '';
    sportsTypeList.clear();
    scheduleList.assignAll([{
      "day": "Sunday",
      "isActive": true,
      "slots": [
        {"start": "09:00 AM", "end": "10:00 AM"}
      ]
    }]);
  }
}
