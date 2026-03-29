import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:izz_atlas_app/view/components/custom_button/custom_button.dart';
import 'package:izz_atlas_app/view/components/custom_from_card/custom_from_card.dart';
import 'package:izz_atlas_app/view/components/custom_loader/custom_loader.dart';
import 'package:izz_atlas_app/view/components/custom_netwrok_image/custom_network_image.dart';
import 'package:izz_atlas_app/view/components/custom_royel_appbar/custom_royel_appbar.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../components/custom_text/custom_text.dart';
import '../../../components/custom_text_field/custom_text_field.dart';
import 'controller/edit_venue_controller.dart';

class EditVenueScreen extends StatelessWidget {
  const EditVenueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final EditVenueController controller = Get.put(EditVenueController());

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomRoyelAppbar(leftIcon: true, titleName: "Edit Venue"),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CustomLoader());
        }

        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ============= Image Picker Section =============
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
                                  image: FileImage(
                                    controller.selectedImage.value!,
                                  ),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: controller.selectedImage.value == null
                            ? (controller.networkImage.value.isNotEmpty
                                  ? CustomNetworkImage(
                                      imageUrl: controller.networkImage.value,
                                      height: 192,
                                      width: double.infinity,
                                      borderRadius: BorderRadius.circular(12),
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_a_photo,
                                          size: 40,
                                          color: Colors.grey,
                                        ),
                                        Text("Tap to upload venue image"),
                                      ],
                                    ))
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ============= Form Fields =============
                    CustomFormCard(
                      title: "Venue Name",
                      hintText: "Venue Name",
                      controller: controller.venueNameController,
                    ),

                    // ========== Sports Type Dropdown ==========
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
                          value: controller.selectedSportType.value,
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
                        SizedBox(width: 8),
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

                    // ✅ Added Court Number Field
                    CustomFormCard(
                      title: "Court Numbers",
                      hintText: "e.g. 5",
                      keyboardType: TextInputType.number,
                      controller: controller.courtNumberController,
                    ),

                    CustomFormCard(
                      title: "Location",
                      hintText: "Location",
                      controller: controller.locationController,
                    ),

                    const SizedBox(height: 16),

                    // ============= Schedule Section =============
                    CustomText(
                      text: "Schedule",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      bottom: 8,
                    ),

                    Column(
                      children: List.generate(controller.scheduleList.length, (
                        dayIndex,
                      ) {
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
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Day Row
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: dayBlock['day'],
                                          icon: Icon(Icons.arrow_drop_down),
                                          items: controller.daysList.map((
                                            String day,
                                          ) {
                                            return DropdownMenuItem<String>(
                                              value: day,
                                              child: Text(day),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) => controller
                                              .changeDay(dayIndex, newValue),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: dayBlock['isActive'],
                                          onChanged: (val) =>
                                              controller.toggleScheduleActive(
                                                dayIndex,
                                                val,
                                              ),
                                          activeColor: Colors.black,
                                        ),
                                        InkWell(
                                          onTap: () => controller
                                              .removeDayBlock(dayIndex),
                                          child: Icon(
                                            Icons.delete_outline,
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Divider(height: 1, color: Colors.grey.shade200),
                                const SizedBox(height: 12),
                                // Slots Loop
                                ...List.generate(slots.length, (slotIndex) {
                                  var slot = slots[slotIndex];
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 12.0,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: _buildTimeController(
                                            time: slot['start'].toString(),
                                            onDecrease: () =>
                                                controller.changeTime(
                                                  dayIndex,
                                                  slotIndex,
                                                  "start",
                                                  -30,
                                                ),
                                            onIncrease: () =>
                                                controller.changeTime(
                                                  dayIndex,
                                                  slotIndex,
                                                  "start",
                                                  30,
                                                ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: _buildTimeController(
                                            time: slot['end'].toString(),
                                            onDecrease: () =>
                                                controller.changeTime(
                                                  dayIndex,
                                                  slotIndex,
                                                  "end",
                                                  -30,
                                                ),
                                            onIncrease: () =>
                                                controller.changeTime(
                                                  dayIndex,
                                                  slotIndex,
                                                  "end",
                                                  30,
                                                ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        InkWell(
                                          onTap: () =>
                                              controller.removeSlotFromDay(
                                                dayIndex,
                                                slotIndex,
                                              ),
                                          child: const Icon(
                                            Icons.remove_circle_outline,
                                            color: Colors.red,
                                            size: 28,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                                const SizedBox(height: 8),
                                // ✅ Single Add Slot Button per day
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: InkWell(
                                    onTap: () =>
                                        controller.addSlotToDay(dayIndex),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.1),
                                        borderRadius:
                                            BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Icon(
                                            Icons.add_circle_outline,
                                            color: Colors.blue,
                                            size: 20,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            "Add Slot",
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
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
                        icon: const Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "Add New Day Schedule",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ============= Amenities Section =============
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
                            _showAddAmenityDialog(context, controller);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.add, color: Colors.black),
                                const SizedBox(width: 4),
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
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Obx(
                        () => Row(
                          children: controller.amenitiesList.map((amenity) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: _amenitySelectableItem(
                                controller,
                                amenity,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomFormCard(
                      title: "Description",
                      hintText: "Description",
                      maxLine: 4,
                      controller: controller.descriptionController,
                    ),

                    const SizedBox(height: 20),

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
                          child: controller.isUpdating.value
                              ? const Center(child: CustomLoader())
                              : CustomButton(
                                  onTap: controller.updateVenue,
                                  textColor: AppColors.white,
                                  title: "Update",
                                ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  // Helper Widgets
  Widget _amenitySelectableItem(EditVenueController controller, String text) {
    return Obx(() {
      bool isSelected = controller.selectedAmenities.contains(text);
      return GestureDetector(
        onTap: () => controller.toggleAmenity(text),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: [Color(0xff111827), Color(0xff1F2937)],
                  )
                : null,
            color: isSelected ? null : Colors.grey[200],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? Colors.transparent : Colors.grey,
            ),
          ),
          child: CustomText(
            text: text,
            fontSize: 14,
            color: isSelected ? AppColors.white : Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    });
  }

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
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: Icon(Icons.remove, size: 16),
            ),
          ),
          Text(
            time,
            style: TextStyle(
              color: Colors.grey.shade800,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          InkWell(
            onTap: onIncrease,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: Icon(Icons.add, size: 16),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddAmenityDialog(
    BuildContext context,
    EditVenueController controller,
  ) {
    final TextEditingController textController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CustomText(
                    text: "Add New Amenity",
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),
                CustomText(
                  text: "Amenity Name",
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  bottom: 8,
                ),
                CustomTextField(
                  textEditingController: textController,
                  hintText: "Ex: AC, Locker, CCTV",
                  fieldBorderColor: Colors.grey.shade300,
                  fillColor: Colors.white,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        onTap: () => Get.back(),
                        title: "Cancel",
                        fillColor: Colors.grey.shade200,
                        textColor: Colors.white,
                        height: 45,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomButton(
                        onTap: () {
                          controller.addCustomAmenity(
                            textController.text.trim(),
                          );
                        },
                        title: "Add",
                        textColor: Colors.white,
                        height: 45,
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
  }
}
