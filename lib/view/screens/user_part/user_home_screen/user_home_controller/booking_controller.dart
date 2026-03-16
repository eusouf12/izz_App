import 'dart:convert';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../service/api_client.dart';
import '../../../../../service/api_url.dart';
import '../../../../../utils/ToastMsg/toast_message.dart';
import '../../../../../core/app_routes/app_routes.dart';
import '../model/user_venue_details_model.dart';
import 'user_details_controller.dart';

class BookingController extends GetxController {
  final UserVenueDetailsController detailsController = Get.find<UserVenueDetailsController>();

  // ================= VARIABLES =================
  var isLoading = false.obs;

  var selectedDate = DateTime.now().obs;
  var focusedDay = DateTime.now().obs;
  var selectedTime = "".obs;

  var selectedCourts = <String>[].obs;

  var bookedCourts = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    selectedDate.value = DateTime.now();
    focusedDay.value = DateTime.now();
  }

  // ================= UI METHODS =================

  void onDateSelected(DateTime selected, DateTime focused) {
    selectedDate.value = selected;
    focusedDay.value = focused;
    selectedTime.value = "";
    selectedCourts.clear();
    bookedCourts.clear();
  }

  void selectTime(String time) {
    selectedTime.value = time;
    selectedCourts.clear();

    _checkBookedCourtsForTime(time);
  }

  void toggleCourt(String court) {
    if (bookedCourts.contains(court)) {
      showCustomSnackBar("This court is already booked for this time slot.", isError: true);
      return;
    }

    if (selectedCourts.contains(court)) {
      selectedCourts.remove(court);
    } else {
      // selectedCourts.clear();
      selectedCourts.add(court);
    }
  }

  bool isCourtBooked(String court) {
    return bookedCourts.contains(court);
  }

  // ================= HELPER METHODS =================

  List<String> getDynamicCourts() {
    if (detailsController.venueDetails.value == null) return [];
    int totalCourts = detailsController.venueDetails.value!.courtNumbers;
    return List.generate(totalCourts, (index) => (index + 1).toString().padLeft(2, '0'));
  }

  void _checkBookedCourtsForTime(String time) {
    bookedCourts.clear();

    if (detailsController.venueDetails.value == null) return;


    String dayName = DateFormat('EEEE').format(selectedDate.value);

    // var availability = detailsController.venueDetails.value!.venueAvailabilities...
    // if (availability.bookedCourts.contains(court)) { bookedCourts.add(court); }

    // bookedCourts.addAll(['02', '04']);
  }

  List<String> getAvailableSlots() {
    if (detailsController.venueDetails.value == null) return [];

    String dayName = DateFormat('EEEE').format(selectedDate.value);

    VenueAvailability availability = detailsController.venueDetails.value!.venueAvailabilities.firstWhere(
          (element) => element.day.toLowerCase() == dayName.toLowerCase(),
      orElse: () => VenueAvailability(day: dayName, scheduleSlots: []),
    );

    return availability.scheduleSlots.map((slot) => slot.from).toList();
  }

  String _getEndTime(String startTime) {
    if (detailsController.venueDetails.value == null) return "";
    String dayName = DateFormat('EEEE').format(selectedDate.value);

    var availability = detailsController.venueDetails.value!.venueAvailabilities.firstWhere(
          (element) => element.day.toLowerCase() == dayName.toLowerCase(),
      orElse: () => VenueAvailability(day: dayName, scheduleSlots: []),
    );

    var slot = availability.scheduleSlots.firstWhere(
            (s) => s.from == startTime,
        orElse: () => ScheduleSlot(from: "", to: "")
    );

    return slot.to;
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

  // ================= API CALL =================

  Future<void> bookSlot() async {
    if (selectedTime.value.isEmpty) {
      showCustomSnackBar("Please select a time slot", isError: true);
      return;
    }
    if (selectedCourts.isEmpty) {
      showCustomSnackBar("Please select a court", isError: true);
      return;
    }

    isLoading.value = true;

    try {
      var venue = detailsController.venueDetails.value!;
      String venueId = venue.id;

      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate.value);
      String dayName = DateFormat('EEEE').format(selectedDate.value);

      String startTime = selectedTime.value;
      String endTime = _getEndTime(startTime);

      int courtNum = int.tryParse(selectedCourts.first) ?? 0;

      double pricePerHour = venue.pricePerHour;
      int startMin = _timeToMinutes(startTime);
      int endMin = _timeToMinutes(endTime);

      if (endMin < startMin) endMin += (24 * 60);

      double durationHours = (endMin - startMin) / 60.0;
      double totalPrice = durationHours * pricePerHour;

      if(totalPrice < 0) totalPrice = 0;

      Map<String, dynamic> body = {
        "date": formattedDate,
        "day": dayName,
        "timeSlot": {
          "from": startTime,
          "to": endTime
        },
        "courtNumber": courtNum,
        "sportsType": venue.sportsType,
        "totalPrice": totalPrice.toInt()
      };

      Response response = await ApiClient.postData(
          ApiUrl.bookSlot(id: venueId),
          jsonEncode(body)
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar("Booking Successful!", isError: false);

        bookedCourts.add(selectedCourts.first);
        selectedCourts.clear();

        Get.offAllNamed(AppRoutes.userHomeScreen);
      } else {
        String msg = "Booking Failed";
        if(response.body != null && response.body is Map && response.body['message'] != null) {
          msg = response.body['message'];
        } else if (response.body is String) {
          try {
            var jsonBody = jsonDecode(response.body);
            if(jsonBody['message'] != null) msg = jsonBody['message'];
          } catch(e) {}
        }
        showCustomSnackBar(msg, isError: true);
      }
    } catch (e) {
      showCustomSnackBar("Something went wrong: $e", isError: true);
      print("Booking Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}