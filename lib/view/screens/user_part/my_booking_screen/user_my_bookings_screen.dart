import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:izz_atlas_app/utils/app_colors/app_colors.dart';
import 'package:izz_atlas_app/view/components/custom_loader/custom_loader.dart';
import 'package:izz_atlas_app/view/components/custom_nav_bar/navbar.dart';
import 'package:izz_atlas_app/view/components/custom_tab_selected/custom_tab_bar.dart';
import 'package:izz_atlas_app/view/screens/user_part/my_booking_screen/controller/user_my_booking_controller.dart';
import 'package:izz_atlas_app/view/screens/user_part/my_booking_screen/venue_review_popup_screen.dart';
import 'package:izz_atlas_app/view/screens/user_part/user_home_screen/widgets/custom_user_my_bokings_container.dart';
import '../../../../core/app_routes/app_routes.dart';
import '../../../components/custom_royel_appbar/custom_royel_appbar.dart';

class UserMyBookingsScreen extends StatelessWidget {
  UserMyBookingsScreen({super.key});

  final UserMyBookingController controller = Get.put(UserMyBookingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomRoyelAppbar(leftIcon: false, titleName: "My Booking"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            ///================ Tabs =================
            Obx(
                  () => CustomTabBar(
                textColor: AppColors.white,
                tabs: controller.tabNameList,
                selectedIndex: controller.currentIndex.value,
                onTabSelected: (value) {
                  controller.changeTab(value);
                },
                selectedColor: AppColors.primary,
                unselectedColor: AppColors.black,
              ),
            ),
            const SizedBox(height: 20),

            ///================ Booking List =================
            Expanded(
              child: Obx(() {
                /// First loading
                if (controller.isLoading.value &&
                    controller.bookings.isEmpty) {
                  return const Center(child: CustomLoader());
                }

                /// Empty state
                if (controller.bookings.isEmpty) {
                  return Center(
                    child: Text(
                      "No ${controller.tabNameList[controller.currentIndex.value]} bookings found",
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }

                return NotificationListener<ScrollNotification>(
                  onNotification: (scrollInfo) {
                    if (!controller.isMoreLoading.value &&
                        scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                      controller.fetchBookings(
                        controller
                            .tabNameList[controller.currentIndex.value],
                      );
                    }
                    return true;
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 20),
                    itemCount: controller.bookings.length +
                        (controller.isMoreLoading.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == controller.bookings.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CustomLoader()),
                        );
                      }

                      final booking = controller.bookings[index];
                      int currentTab = controller.currentIndex.value;

                      /// Date + time format
                      String dateTime = "";
                      if (booking.date != null && booking.timeSlot != null) {
                        dateTime =
                        "${booking.date} • ${booking.timeSlot?.from} - ${booking.timeSlot?.to}";
                      }

                      ///================ Requested / Ongoing / Completed =================
                      if (currentTab == 0) {
                        /// Requested
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: CustomUserMyBokingsContainer(
                            title: booking.venue?.venueName ?? "",
                            img: booking.venue?.venueImage ?? "",
                            address: booking.venue?.location ?? "",
                            complexName: booking.sportsType ?? "",
                            facilityName: "Court ${booking.courtNumber ?? ""}",
                            dateTime: dateTime,
                            isPending:true,
                            isChatOption: false,
                            onViewDetailsTap: () {
                                Get.toNamed(AppRoutes.userVenueDetailsScreen, arguments: booking.venue?.id);
                              },

                          ),
                        );
                      }
                      else if (currentTab == 1) {
                        /// Ongoing
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: CustomUserMyBokingsContainer(
                            title: booking.venue?.venueName ?? "",
                            img: booking.venue?.venueImage ?? "",
                            address: booking.venue?.location ?? "",
                            complexName: booking.sportsType ?? "",
                            facilityName: "Court ${booking.courtNumber ?? ""}",
                            dateTime: dateTime,
                            isChatOption: false,
                          ),
                        );
                      }
                      else if (currentTab == 2) {
                        /// Completed
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: GestureDetector(
                            onTap: () {
                              Get.dialog(
                                VenueReviewPopup(venueId: booking.venue?.id??"",),
                                barrierDismissible: false,
                              );
                            },
                            child: CustomUserMyBokingsContainer(
                              title: booking.venue?.venueName ?? "",
                              img: booking.venue?.venueImage ?? "",
                              address: booking.venue?.location ?? "",
                              complexName: booking.sportsType ?? "",
                              facilityName: "Court ${booking.courtNumber ?? ""}",
                              dateTime: dateTime,
                              isChatOption: false,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Navbar(currentIndex: 1),
    );
  }
}
