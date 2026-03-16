import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:izz_atlas_app/view/components/custom_button/custom_button.dart';
import 'package:izz_atlas_app/view/components/custom_from_card/custom_from_card.dart';
import 'package:izz_atlas_app/view/components/custom_royel_appbar/custom_royel_appbar.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../components/custom_loader/custom_loader.dart';
import '../../../components/custom_text/custom_text.dart';
import '../../user_part/user_home_screen/user_home_controller/sports_type_controller.dart';
import 'controller/add_venue_controller.dart';

class AddVenueScreen extends StatelessWidget {
  const AddVenueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AddVenueController controller = Get.put(AddVenueController());
    Get.put(SportsTypeController());

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomRoyelAppbar(leftIcon: true, titleName: "Add New Venue"),
      body: Obx(() {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: controller.pickImage,
                      child: Container(
                        height: 192,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                          image: controller.selectedImage.value != null
                              ? DecorationImage(
                            image: FileImage(controller.selectedImage.value!),
                            fit: BoxFit.cover,
                          )
                              : null,
                        ),
                        child: controller.selectedImage.value == null
                            ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                            SizedBox(height: 4),
                            CustomText(text: "Tap to upload venue image", color: Colors.grey, fontSize: 14),
                          ],
                        )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Venue Name field
                    CustomFormCard(
                      title: "Venue Name",
                      hintText: "Downtown Sports Complex",
                      controller: controller.venueNameController,
                    ),

                    // Sports Type dropdown with data populated from API
                    CustomText(
                      text: "Sports Type",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      bottom: 8,
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          // When no sport is selected, value is null and hint is shown.
                          value: controller.selectedSportType.value.isNotEmpty
                              ? controller.selectedSportType.value
                              : null,
                          hint: const Text('Select sport type'),
                          icon: const Icon(Icons.arrow_drop_down),
                          isExpanded: true,
                          items: controller.sportsTypeList.map((String type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            if (newValue != null) {
                              controller.selectedSportType.value = newValue;
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Price and Capacity fields
                    Row(
                      children: [
                        Flexible(
                          child: CustomFormCard(
                            title: "Price/Hour",
                            hintText: "1200",
                            keyboardType: TextInputType.number,
                            controller: controller.priceController,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: CustomFormCard(
                            title: "Capacity",
                            hintText: "22",
                            keyboardType: TextInputType.number,
                            controller: controller.capacityController,
                          ),
                        ),
                      ],
                    ),

                    CustomFormCard(
                      title: "Court Numbers",
                      hintText: "10",
                      keyboardType: TextInputType.number,
                      controller: controller.courtNumberController,
                    ),
                    CustomFormCard(
                      title: "Location",
                      hintText: "Dhanmondi, Dhaka",
                      controller: controller.locationController,
                    ),
                    const SizedBox(height: 16),

                    // Schedule section title
                    CustomText(
                      text: "Schedule",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      bottom: 8,
                    ),
                    Column(
                      children: List.generate(controller.scheduleList.length, (dayIndex) {
                        var dayBlock = controller.scheduleList[dayIndex];
                        List slots = dayBlock['slots'];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade100,
                                  blurRadius: 4,
                                  spreadRadius: 2,
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey.shade300),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: dayBlock['day'],
                                          icon: const Icon(Icons.arrow_drop_down),
                                          items: controller.daysList.map((String day) {
                                            return DropdownMenuItem<String>(
                                              value: day,
                                              child: Text(day),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) => controller.changeDay(dayIndex, newValue),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: dayBlock['isActive'],
                                          onChanged: (val) => controller.toggleScheduleActive(dayIndex, val),
                                          activeColor: Colors.deepPurple,
                                        ),
                                        InkWell(
                                          onTap: () => controller.removeDayBlock(dayIndex),
                                          child: Icon(Icons.delete_outline, color: Colors.grey.shade500),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Divider(height: 1, color: Colors.grey.shade200),
                                const SizedBox(height: 12),
                                // Time slots for this day
                                ...List.generate(slots.length, (slotIndex) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: _buildTimeController(
                                            time: slots[slotIndex]['start'],
                                            onDecrease: () =>
                                                controller.changeTime(dayIndex, slotIndex, "start", -30),
                                            onIncrease: () =>
                                                controller.changeTime(dayIndex, slotIndex, "start", 30),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: _buildTimeController(
                                            time: slots[slotIndex]['end'],
                                            onDecrease: () =>
                                                controller.changeTime(dayIndex, slotIndex, "end", -30),
                                            onIncrease: () =>
                                                controller.changeTime(dayIndex, slotIndex, "end", 30),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Row(
                                          children: [
                                            InkWell(
                                              onTap: () => controller.removeSlotFromDay(dayIndex, slotIndex),
                                              child: const Icon(Icons.remove_circle_outline, color: Colors.red, size: 28),
                                            ),
                                            const SizedBox(width: 8),
                                            InkWell(
                                              onTap: () => controller.addSlotToDay(dayIndex),
                                              child: const Icon(Icons.add_circle_outline, color: Colors.blue, size: 28),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: controller.addNewDayBlock,
                        icon: const Icon(Icons.calendar_today, color: Colors.white),
                        label: const Text(
                          "Add New Day Schedule",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomText(
                      text: "Venue Status",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      bottom: 8,
                    ),
                    Obx(() => Row(
                      children: [
                        Switch(
                          value: controller.isVenueActive.value,
                          onChanged: (bool value) {
                            controller.isVenueActive.value = value;
                          },
                          activeColor: Colors.black,
                          activeTrackColor: Colors.grey.shade600,
                          inactiveThumbColor: Colors.grey.shade400,
                          inactiveTrackColor: Colors.grey.shade300,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: controller.isVenueActive.value ? "Active" : "Inactive",
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            CustomText(
                              text: controller.isVenueActive.value
                                  ? "Venue is visible and bookable"
                                  : "Venue is hidden and not bookable",
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      ],
                    )),


                    const SizedBox(height: 16),

                    // Amenities section
                    Row(
                      children: [
                        CustomText(
                          text: "Amenities",
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          text: "AMENITIES TYPE",
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        const SizedBox(height: 16),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF1F2937),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: TextField(
                                            controller: controller.newAmenityController,
                                            style: const TextStyle(color: Colors.white),
                                            decoration: const InputDecoration(
                                              hintText: "Amenities name",
                                              hintStyle: TextStyle(color: Colors.white54),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius: BorderRadius.circular(30),
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: CustomText(
                                                    text: "Cancel",
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  controller.addNewAmenity();
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFF374151),
                                                    borderRadius: BorderRadius.circular(30),
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: CustomText(
                                                    text: "Save",
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.add, color: Colors.black),
                                SizedBox(width: 4),
                                CustomText(
                                  text: "Add New",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Show custom amenity chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Obx(() => Row(
                            children: controller.customAmenities.map((amenity) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: _amenitySelectableItem(controller, amenity),
                              );
                            }).toList(),
                          )),
                        ],
                      ),
                    ),
                    // Description field
                    CustomFormCard(
                      title: "Description",
                      hintText: "Type description here...",
                      maxLine: 4,
                      controller: controller.descriptionController,
                    ),
                    // Buttons row: Cancel and Save
                    Row(
                      children: [
                        Flexible(
                          child: CustomButton(
                            onTap: () => Get.back(),
                            fillColor: AppColors.black_05,
                            textColor: AppColors.white,
                            title: "Cancel",
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Obx(() {
                            return controller.isLoading.value
                                ? const Center(child: CustomLoader())
                                : CustomButton(
                              onTap: () {
                                controller.createVenue();
                              },
                              textColor: AppColors.white,
                              title: "Save",
                            );
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
            // Loading overlay
            if (controller.isLoading.value)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(child: CustomLoader()),
              ),
          ],
        );
      }),
    );
  }

  Widget _amenitySelectableItem(AddVenueController controller, String text) {
    return Obx(() {
      bool isSelected = controller.selectedAmenities.contains(text);
      return GestureDetector(
        onTap: () => controller.toggleAmenity(text),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(colors: [Color(0xff111827), Color(0xff1F2937)])
                : null,
            color: isSelected ? null : Colors.grey[200],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isSelected ? Colors.transparent : Colors.grey),
          ),
          child: CustomText(
              left: 8,
              text: text,
              fontSize: 14,
              color: isSelected ? AppColors.white : Colors.black,
              fontWeight: FontWeight.w600),
        ),
      );
    });
  }

  /// Time controller model with + and - buttons.
  Widget _buildTimeController({
    required String time,
    required VoidCallback onDecrease,
    required VoidCallback onIncrease,
  }) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: onDecrease,
            child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0), child: Icon(Icons.remove, size: 16)),
          ),
          Text(time,
              style: TextStyle(
                  color: Colors.grey.shade800, fontSize: 13, fontWeight: FontWeight.bold)),
          InkWell(
            onTap: onIncrease,
            child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0), child: Icon(Icons.add, size: 16)),
          ),
        ],
      ),
    );
  }
}
