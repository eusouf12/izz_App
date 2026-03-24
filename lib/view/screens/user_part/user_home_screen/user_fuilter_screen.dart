import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:izz_atlas_app/utils/app_colors/app_colors.dart';
import 'package:izz_atlas_app/view/components/custom_loader/custom_loader.dart';
import 'package:izz_atlas_app/view/components/custom_text/custom_text.dart';
import 'package:izz_atlas_app/view/screens/user_part/user_home_screen/user_home_controller/user_all_sports_controller.dart';

class UserFilterScreen extends StatelessWidget {
  final String sportType;

  UserFilterScreen({super.key, required this.sportType});

  final controller = Get.put(UserAllSportsController());

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getAllLocVenueFilter(filter: sportType);
    });
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),

      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
        
            /// TITLE
            const Text(
              "FILTERS",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
        
            const SizedBox(height: 16),
            Obx(() {
              if (controller.isLoading.value && controller.venuesNameList.isEmpty) {
                return const Center(child: CustomLoader());
              }
        
              return Column(
                children: [
                  /// ================= VENUES NAME =================
                  _sectionTitle("VENUES NAME"),
                  _gridCheckBox(
                    list: controller.venuesNameList,
                    selected: controller.selectedVenue,
                    onTap: (val) => controller.selectVenues(val),
                  ),
                  _loadMoreButton(),
        
                  const SizedBox(height: 16),
        
                  /// ================= LOCATION =================
                  _sectionTitle("LOCATION"),
                  _gridCheckBox(
                    list: controller.locationsList,
                    selected: controller.selectedLocation,
                    onTap: (val) => controller.selectLocation(val),
                  ),
                ],
              );
            }),
        
            const SizedBox(height: 20),
        
            /// ================= PRICE =================
            _sectionTitle("PRICE RANGE"),
        
            Obx(() => Column(
              children: [
                RangeSlider(
                  values: RangeValues(
                    controller.minPrice.value,
                    controller.maxPrice.value,
                  ),
                  min: 0,
                  max: 1000,
                  divisions: 20,
                  activeColor: AppColors.blue,
                  inactiveColor: AppColors.blue.withOpacity(0.1),
                  onChanged: (values) {
                    controller.minPrice.value = values.start;
                    controller.maxPrice.value = values.end;
                  },
                ),
        
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _priceBox(controller.minPrice.value),
                    _priceBox(controller.maxPrice.value),
                  ],
                ),
              ],
            )),
        
            const SizedBox(height: 20),
        
            /// ================= BUTTON =================
            Row(
              children: [
                /// ================= APPLY BUTTON =================
                Expanded(
                  child: Obx(() {
                    if (controller.isSportsLoading.value) {
                      return  Center(child: CustomLoader());
                    }

                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blue.withOpacity(0.1),
                      ),
                      onPressed: () {
                        controller.allSports(
                          filter: sportType,
                          onSuccess: () {
                            Get.back();
                          },
                        );
                      },
                      child: CustomText(
                        text: "APPLY",
                        color: AppColors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  }),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: controller.reset,
                    child:CustomText(text: "RESET",color: AppColors.black,fontWeight: FontWeight.w600,),
        
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// ================= COMMON WIDGETS =================

  Widget _sectionTitle(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _gridCheckBox({required List<String> list, required RxString selected, required Function(String) onTap,}) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 4,
      ),
      itemBuilder: (context, index) {
        final item = list[index];
        return Obx(() {
          final isSelected = selected.value == item;

          return GestureDetector(
            onTap: () => onTap(item),
            child: Row(
              children: [
                Checkbox(
                  value: isSelected,
                  activeColor:AppColors.blue,
                  onChanged: (_) => onTap(item),
                ),
                Expanded(
                  child: Text(
                    item,
                    style: TextStyle(
                      color: isSelected ? AppColors.blue : Colors.black,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Widget _priceBox(double value) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text("RM ${value.toInt()}"),
    );
  }
  Widget _loadMoreButton() {
    return Obx(() {
      // অবশ্যই .value ব্যবহার করতে হবে উভয় ক্ষেত্রে
      if (controller.currentPage.value < controller.totalPage.value) {
        return Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                controller.getAllLocVenueFilter(loadMore: true, filter: sportType);
              },
              child: controller.isLoadMore.value
                  ? const SizedBox(
                height: 16,
                width: 16,
                child: CustomLoader(), // আপনার কাস্টম লোডার
              )
                  : const Text("Load More",
                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
            )
        );
      }
      return const SizedBox.shrink();
    });
  }
}