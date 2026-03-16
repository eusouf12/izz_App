import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:izz_atlas_app/view/components/custom_loader/custom_loader.dart';
import 'package:izz_atlas_app/view/screens/user_part/user_home_screen/user_home_controller/user_all_sports_controller.dart';
import '../../../../../utils/app_colors/app_colors.dart';

class SportsFilterBottomSheet extends StatelessWidget {
  SportsFilterBottomSheet({super.key});

  final UserAllSportsController controller = Get.put(UserAllSportsController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) {
          controller.reset();
        }
      },
      child: Container(
        height: MediaQuery.of(context).size.height * .9,
        padding: EdgeInsets.all(16.w),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50, height: 4,
                  margin: EdgeInsets.only(bottom: 20.h),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              _title("FILTERS"),
              SizedBox(height: 20.h),
              _searchBox(),
              SizedBox(height: 20.h),
              _title("SORT BY"),
              Obx(() => _radio("Individual sports", "individual")),
              Obx(() => _radio("Team sports", "team")),
              SizedBox(height: 20.h),

              _title("SPORTS"),
              _singleSelectGrid(controller.sportsList, controller.selectedSport, controller.selectSport),

              SizedBox(height: 20.h),
              _title("LOCATION"),
              _singleSelectGrid(controller.locationsList, controller.selectedLocation, controller.selectLocation),

              SizedBox(height: 20.h),
              _title("PRICE RANGE"),
              _priceRange(),
              SizedBox(height: 30.h),
              _buttons(),
            ],
          ),
        ),
      ),
    );
  }

  // Single Select Grid Logic
  Widget _singleSelectGrid(List<String> list, RxString selectedValue, Function(String) onSelect) {
    return Obx(() => GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 4,
      children: list.map((item) {
        return Row(
          children: [
            Checkbox(
              value: selectedValue.value == item,
              onChanged: (_) => onSelect(item),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              activeColor: AppColors.primary,
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => onSelect(item),
                child: Text(item, style: TextStyle(fontSize: 13.sp)),
              ),
            ),
          ],
        );
      }).toList(),
    ));
  }

  Widget _title(String text) => Text(text, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700));

  Widget _searchBox() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search",
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  Widget _radio(String text, String value) {
    return RadioListTile(
      value: value,
      groupValue: controller.selectedSort.value,
      onChanged: (val) => controller.selectedSort.value = val!,
      title: Text(text, style: TextStyle(fontSize: 14.sp)),
      contentPadding: EdgeInsets.zero,
      activeColor: AppColors.primary,
    );
  }

  Widget _priceRange() {
    return Obx(() => Column(
      children: [
        RangeSlider(
          min: 0, max: 500,
          activeColor: AppColors.primary,
          values: RangeValues(controller.minPrice.value, controller.maxPrice.value),
          onChanged: (value) {
            controller.minPrice.value = value.start;
            controller.maxPrice.value = value.end;
          },
        ),
        Row(
          children: [
            Expanded(child: _priceBox("RM ${controller.minPrice.value.toInt()}")),
            SizedBox(width: 10.w),
            Expanded(child: _priceBox("RM ${controller.maxPrice.value.toInt()}")),
          ],
        ),
      ],
    ));
  }

  Widget _priceBox(String text) {
    return TextField(
      readOnly: true,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: text,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
      ),
    );
  }

  Widget _buttons() {
    return Row(
      children: [
        Expanded(
          child:
          Obx(() {
            if (controller.isFilteringLoading.value) {
              return const CustomLoader();
            }

            return ElevatedButton(
              onPressed: () {
                controller.filterSports();
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "APPLY",
                style: TextStyle(color: Colors.white),
              ),
            );
          })

        ),
        SizedBox(width: 10.w),
        Expanded(
          child: ElevatedButton(
            onPressed: () => controller.reset(),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: const Text("RESET", style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}