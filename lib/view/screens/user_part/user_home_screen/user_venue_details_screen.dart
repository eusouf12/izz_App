import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:izz_atlas_app/utils/app_colors/app_colors.dart';
import 'package:izz_atlas_app/utils/app_const/app_const.dart';
import 'package:izz_atlas_app/view/components/custom_button/custom_button.dart';
import 'package:izz_atlas_app/view/components/custom_netwrok_image/custom_network_image.dart';
import 'package:izz_atlas_app/view/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:izz_atlas_app/view/components/custom_text/custom_text.dart';
import 'package:izz_atlas_app/view/screens/user_part/user_home_screen/user_home_controller/user_details_controller.dart';
import 'package:izz_atlas_app/view/screens/user_part/user_message_list_screen/controller/message_controller.dart';
import '../../../../core/app_routes/app_routes.dart';
import '../../../../utils/app_icons/app_icons.dart';
import '../../../components/custom_button/custom_button_two.dart';
import '../../../components/custom_image/custom_image.dart';
import '../../../components/custom_loader/custom_loader.dart';
import '../../vendor_part/vendor_home_screen/vendor_home_screen.dart';
import '../../vendor_part/vendor_home_screen/venue_details_screen.dart' hide QuickButton;


class UserVenueDetailsScreen extends StatelessWidget {
  UserVenueDetailsScreen({super.key});

  final UserVenueDetailsController controller = Get.put(UserVenueDetailsController());
  final MessageController messageController = Get.put(MessageController());
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dynamic argument = Get.arguments;
      if (argument != null && argument is String && argument.isNotEmpty) {
        controller.getVenueDetails(argument);
      } else {
        debugPrint("Error: Venue ID not found or invalid format in arguments");
      }
    });

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomRoyelAppbar(leftIcon: true, titleName: "Venue Details"),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const CustomLoader();
        }

        if (controller.venueDetails.value == null) {
          return const Center(
              child: CustomText(text: "No venue details found."));
        }

        final venue = controller.venueDetails.value!;
        messageController.getVendorExist(id: venue.vendorId);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: venue.venueName,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),

                CustomText(
                  text: venue.location,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff6B7280),
                  bottom: 16,
                  maxLines: 3,
                ),

                CustomNetworkImage(
                  imageUrl: venue.venueImage.isNotEmpty ? venue.venueImage : AppConstants.banner,
                  height: 220,
                  width: MediaQuery.of(context).size.width,
                  borderRadius: BorderRadius.circular(17),
                ),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomText(
                      text: "OPERATION HOURS:",
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star,
                            color: Colors.amber, size: 18),
                        CustomText(
                          text: venue.venueRating.isNotEmpty
                              ? venue.venueRating
                              : "0.0",
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.amber,
                          right: 8,
                        ),
                        GestureDetector(
                          onTap: () =>
                              Get.toNamed(AppRoutes.userReviewScreen, arguments: venue.id),
                          child: CustomText(
                            text:
                            "(${venue.venueReviewCount} Review)",
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _chip(venue.sportsType, const Color(0xff111827)),
                        const SizedBox(width: 8),
                        _chip(
                          venue.venueStatus ? "Active" : "Inactive",
                          venue.venueStatus
                              ? const Color(0xff22C55E)
                              : Colors.red,
                        ),
                      ],
                    ),
                    CustomText(
                      text: "RM ${venue.pricePerHour}/hr",
                      fontSize: 20,
                    )
                  ],
                ),

                const SizedBox(height: 16),

                if (venue.venueAvailabilities.isNotEmpty)
                  ...venue.venueAvailabilities.map((availability) {
                    return Padding(
                      padding:
                      const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: availability.day,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.end,
                            children: availability
                                .scheduleSlots.isEmpty
                                ? [
                              const CustomText(
                                text: "Closed",
                                color: Colors.red,
                                fontSize: 12,
                              )
                            ]
                                : availability.scheduleSlots
                                .map(
                                  (slot) => CustomText(
                                text:
                                "${slot.from} - ${slot.to}",
                                fontSize: 12,
                              ),
                            )
                                .toList(),
                          )
                        ],
                      ),
                    );
                  }),

                const SizedBox(height: 16),

                QuickButton(
                  text: "AMENITIES",
                  onTap: controller.toggleAmenities,
                ),
                Obx(() => controller.isAmenitiesOpen.value
                    ? amenitiesWidget(venue.amenities)
                    : const SizedBox()),

                const SizedBox(height: 16),

                QuickButton(
                  text: "VENUE INFORMATION",
                  onTap: controller.toggleVenueInfo,
                ),
                Center(child: CustomImage(imageSrc: AppIcons.arrowDown)),
                //========================venue inf  ========================
                Obx(() => controller.isVenueInfoOpen.value
                    ? venueInformationWidget(venue.description)
                    : const SizedBox()),

                const SizedBox(height: 20),
                //======================== Book BUTTON  ========================
                CustomButton(
                  onTap: () => Get.toNamed(AppRoutes.bookYourSlotScreen, arguments: venue.id),
                  title: "BOOK NOW",
                  textColor: AppColors.white,
                ),
                const SizedBox(height: 16),
                //======================== CHAT BUTTON  ========================
                CustomButtonTwo(
                  onTap: () {
                    final data = messageController.channelData.value;
                    debugPrint("Vendor Exist: ${messageController.vendorExist.value}");
                    messageController.vendorExist.value ? Get.toNamed(AppRoutes.chatInboxScreen,
                      arguments: {
                        'channelName': data?.channelName,
                        'userName': data?.person2.fullName,
                        'userImage': data?.person2.profileImage,
                      },
                    ) : showChatAgendaModal(context, venue.vendorId);
                  },
                  title: "CHAT WITH VENDOR",
                  textColor: AppColors.blue,
                  fillColor: AppColors.white,
                  borderColor: AppColors.blue,
                  borderWidth: 1,
                  isBorder: true,
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      }),
    );
  }
}

/// ================= CHAT MODAL =================
void showChatAgendaModal(BuildContext context,String id) {
  final MessageController messageController = Get.put(MessageController());

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius:
            BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomText(
                text: "CHAT AGENDA",
                fontSize: 14,
                fontWeight: FontWeight.w700,
                bottom: 8,
              ),
              _darkInput(
                  controller: messageController.agendaController,
                  hint: "Enter your agenda",
                  maxLines: 1),
              const SizedBox(height: 16),
              const CustomText(
                text: "DETAILS",
                fontSize: 14,
                fontWeight: FontWeight.w700,
                bottom: 8,
              ),
              _darkInput(
                  controller: messageController.detailsController,
                  hint: "Type here...",
                  maxLines: 4),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _actionButton(
                        text: "Cancel",
                        color: const Color(0xff9CA3AF),
                        onTap: () => Get.back()),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _actionButton(
                        text: "Send",
                        color: const Color(0xff374151),
                        onTap: () async {
                          await messageController.sendInitialText(id: id);
                          messageController.getVendorExist(id: id);
                          Get.back();
                        }),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}

/// ================= UI HELPERS =================
Widget _darkInput(
    {required TextEditingController controller,
      required String hint,
      required int maxLines}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: const Color(0xff1F2937),
      borderRadius: BorderRadius.circular(10),
    ),
    child: TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xff9CA3AF)),
      ),
    ),
  );
}

Widget _actionButton(
    {required String text,
      required Color color,
      required VoidCallback onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 48,
      decoration:
      BoxDecoration(color: color, borderRadius: BorderRadius.circular(24)),
      child: Center(
        child: CustomText(
          text: text,
          color: AppColors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

Widget _chip(String text, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration:
    BoxDecoration(color: color, borderRadius: BorderRadius.circular(30)),
    child: CustomText(text: text, color: AppColors.white, fontSize: 12),
  );
}
