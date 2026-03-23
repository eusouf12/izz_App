import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:izz_atlas_app/view/components/custom_loader/custom_loader.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:izz_atlas_app/view/components/custom_button/custom_button.dart';
import 'package:izz_atlas_app/view/components/custom_button/custom_button_two.dart';
import 'package:izz_atlas_app/view/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:izz_atlas_app/view/components/custom_text/custom_text.dart';
import '../../../../utils/app_colors/app_colors.dart';
import 'user_home_controller/booking_controller.dart';

class BookYourSlotScreen extends StatelessWidget {
  BookYourSlotScreen({super.key});
  final BookingController controller = Get.put(BookingController());
  final  venueId = Get.arguments;

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((_) {

    });

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomRoyelAppbar(leftIcon: true, titleName: "Booking"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "BOOK YOUR SLOT",
              fontSize: 18,
              fontWeight: FontWeight.bold,
              bottom: 16,
            ),

            // --- CALENDAR SECTION ---
            Container(
              decoration: BoxDecoration(
                color: const Color(0xff111827),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Obx(() => TableCalendar(
                locale: "en_US",
                rowHeight: 43,
                headerStyle: HeaderStyle(
                  titleTextStyle: TextStyle(color: Colors.white, fontSize: 20.w),
                  formatButtonVisible: false,
                  titleCentered: true,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    color: Color(0xff111827),
                  ),
                  leftChevronIcon: const Icon(Icons.arrow_left, color: Colors.white),
                  rightChevronIcon: const Icon(Icons.arrow_right, color: Colors.white),
                ),
                calendarStyle: CalendarStyle(
                  defaultTextStyle: TextStyle(color: AppColors.white),
                  todayDecoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle: TextStyle(color: AppColors.blue),
                  selectedDecoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: TextStyle(color: AppColors.white),
                ),
                availableGestures: AvailableGestures.all,

                // Controller Variables Binding
                focusedDay: controller.focusedDay.value,
                firstDay: DateTime.now(),
                lastDay: DateTime.utc(2030, 10, 16),

                selectedDayPredicate: (day) => isSameDay(controller.selectedDate.value, day),
                onDaySelected: controller.onDateSelected,
              )),
            ),
            const SizedBox(height: 20),

            // --- AVAILABILITY SECTION ---
            CustomText(
              text: "AVAILABILITY",
              fontSize: 18,
              fontWeight: FontWeight.bold,
              bottom: 20,
            ),

            Obx(() {
              // এখন এটি ম্যাপের লিস্ট পাবে
              List<Map<String, String>> currentSlots = controller.getAvailableSlots();

              if (controller.detailsController.isLoading.value) {
                return const Center(child: CustomLoader());
              }

              if (currentSlots.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text("No slots available", style: TextStyle(color: Colors.grey)),
                );
              }

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: currentSlots.map((slot) {
                    // শুরুতে এবং শেষের সময় মিলিয়ে স্ট্রিং তৈরি
                    String startTime = slot["from"] ?? "";
                    String endTime = slot["to"] ?? "";
                    String displayTime = "$startTime - $endTime";

                    // সিলেকশন চেক করার জন্য শুধু শুরুর সময় (startTime) ব্যবহার করুন
                    bool isSelected = controller.selectedTime.value == startTime;

                    return GestureDetector(
                      onTap: () => controller.selectTime(startTime),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.black : Colors.white,
                          border: Border.all(color: isSelected ? Colors.black : Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          displayTime, // এখানে "9:00 AM - 10:00 AM" দেখাবে
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }),

            const SizedBox(height: 20),

            // --- COURT NUMBER SECTION ---
            CustomText(
              text: "COURT NUMBER",
              fontSize: 18,
              fontWeight: FontWeight.bold,
              bottom: 20,
            ),

            Obx(() {
              List<String> dynamicCourts = controller.getDynamicCourts();

              if (controller.detailsController.isLoading.value) {
                return const Center(child: CustomLoader());
              }

              if (dynamicCourts.isEmpty) {
                return const Text("No courts information available");
              }

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: dynamicCourts.map((court) {
                    bool isSelected = controller.selectedCourts.contains(court);

                    return GestureDetector(
                      onTap: () => controller.toggleCourt(court),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 12.w),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.black : Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          court,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }),

            const SizedBox(height: 30),

            // --- BOOK BUTTON ---
            Obx(
                  () => controller.isLoading.value
                  ? const Center(child: CustomLoader())
                  : CustomButton(
                onTap: controller.bookSlot,
                title: "BOOK NOW",
                textColor: AppColors.white,
              ),
            ),

          ],
        ),
      ),
    );
  }
}