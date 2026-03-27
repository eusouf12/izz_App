import 'package:flutter/material.dart';
import 'package:izz_atlas_app/utils/app_icons/app_icons.dart';
import 'package:izz_atlas_app/view/components/custom_image/custom_image.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../../utils/app_const/app_const.dart';
import '../../../../components/custom_button/custom_button_two.dart';
import '../../../../components/custom_netwrok_image/custom_network_image.dart';
import '../../../../components/custom_text/custom_text.dart';

class CustomUserMyBokingsContainer extends StatelessWidget {
  final String? title;
  final String? img;
  final String? address;
  final String? status;
  final String? complexName;
  final String? facilityName;
  final String? dateTime;
  final String? rating;
  final VoidCallback? onTap;
  final VoidCallback? onChatTap;
  final VoidCallback? onUserChatTap;
  final VoidCallback? onViewDetailsTap;
  final VoidCallback? onReviewTap;
  final VoidCallback? onPaymentTap;
  final VoidCallback? onAcceptTap;
  final VoidCallback? onRejectTap;

  final bool isChatOption;
  final bool isUserChatTap;
  final bool isPending;
  final bool isCompleted;
  final bool isPayment;
  final bool isAccept;
  final bool isReject;
  final bool isAcceptLoading;
  final bool isRejectLoading;

  const CustomUserMyBokingsContainer({
    super.key,
    this.title,
    this.img,
    this.status,
    this.address,
    this.complexName,
    this.facilityName,
    this.dateTime,
    this.rating,
    this.onTap,
    this.onChatTap,
    this.onViewDetailsTap,
    this.isChatOption = false,
    this.isUserChatTap = false,
    this.isPending = false,
    this.isCompleted = false,
    this.onReviewTap,
    this.onUserChatTap,
    this.onPaymentTap,
    required this.isPayment,
    this.isAccept = false,
    this.isReject = false,
    this.onAcceptTap,
    this.onRejectTap,
    this.isAcceptLoading = false,
    this.isRejectLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xff1F2937),
            borderRadius: BorderRadius.circular(17),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Image Section ---
              CustomNetworkImage(
                imageUrl: img ?? AppConstants.banner,
                height: 160,
                width: MediaQuery.sizeOf(context).width,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(17),
                  topRight: Radius.circular(17),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    // --- Title & Rating ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomText(
                            text: title ?? "",
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Row(
                          children: [
                            Row(
                              children: List.generate(5, (index) {
                                double ratingValue =
                                    double.tryParse(rating.toString()) ?? 0.0;
                                return Icon(
                                  index < ratingValue.floor()
                                      ? Icons.star
                                      : (index < ratingValue
                                            ? Icons.star_half
                                            : Icons.star_border),
                                  color: Colors.amberAccent,
                                  size: 16,
                                );
                              }),
                            ),
                            CustomText(
                              left: 4,
                              text: "($rating)",
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.white,
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    // --- status ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomText(
                            text: complexName ?? "",
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textClr,
                            bottom: 8,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: (status == "PENDING") ? Colors.green.withOpacity(0.1):  (status == "CONFIRMED") ? Colors.blue.withOpacity(0.1): (status == "COMPLETED") ? Colors.orange.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: (status == "PENDING") ? Colors.green : (status == "CONFIRMED") ? Colors.blue : (status == "COMPLETED") ? Colors.orange : Colors.red,
                              width: 1,
                            ),
                          ),
                          child: CustomText(
                            text: status ?? "PENDING",
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: (status == "PENDING") ? Colors.green : (status == "CONFIRMED") ? Colors.blue : (status == "COMPLETED") ? Colors.orange : Colors.red,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 5),

                    // --- Complex Name ---
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomImage(
                          imageSrc: AppIcons.map,
                          height: 20,
                          width: 20,
                        ),
                        Expanded(
                          child: CustomText(
                            left: 8,
                            text: address ?? "",
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textClr,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // --- Facility Name ---
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const CustomImage(
                          imageSrc: AppIcons.footboll,
                          height: 20,
                          width: 20,
                        ),
                        Expanded(
                          child: CustomText(
                            left: 8,
                            text: facilityName ?? "Football Field A",
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textClr,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // --- Date & Time ---
                    Row(
                      children: [
                        const CustomImage(
                          imageSrc: AppIcons.calender2,
                          height: 20,
                          width: 20,
                        ),
                        Expanded(
                          child: CustomText(
                            left: 8,
                            text:
                                dateTime ?? "Sep 25, 2024 • 6:00 PM - 7:00 PM",
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textClr,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // --- Buttons Logic ---
                    if (isChatOption)
                      CustomButtonTwo(
                        onTap: onChatTap ?? () {},
                        title: "CHAT WITH VENDOR",
                        textColor: AppColors.blue,
                        fillColor: Colors.transparent,
                        borderColor: AppColors.blue,
                        borderWidth: 1,
                        isBorder: true,
                      ),
                    const SizedBox(height: 10),

                    //accept and reject btn
                    if (isAccept)
                      Row(
                        children: [
                          Expanded(
                            child: isAcceptLoading
                                ? Container(
                                    height: 46,
                                    decoration: BoxDecoration(
                                      color: AppColors.blue,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: const Center(
                                      child: SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                                      ),
                                    ),
                                  )
                                : CustomButtonTwo(
                                    onTap: onAcceptTap ?? () {},
                                    title: "ACCEPT",
                                    textColor: AppColors.white,
                                    fillColor: AppColors.blue,
                                    borderColor: AppColors.blue,
                                    borderWidth: 1,
                                    isBorder: true,
                                    height: 46,
                                  ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: isRejectLoading
                                ? Container(
                                    height: 46,
                                    decoration: BoxDecoration(
                                      color: AppColors.red,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: const Center(
                                      child: SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                                      ),
                                    ),
                                  )
                                : CustomButtonTwo(
                                    onTap: onRejectTap ?? () {},
                                    title: "REJECT",
                                    textColor: AppColors.white,
                                    fillColor: AppColors.red,
                                    borderColor: AppColors.red,
                                    borderWidth: 1,
                                    isBorder: true,
                                    height: 46,
                                  ),
                          ),
                        ],
                      ),

                    // --- Buttons Logic ---
                    isPayment == true
                        ? CustomButtonTwo(
                            onTap: onChatTap ?? () {},
                            title: "PROCEED TO PAYMENT",
                            textColor: AppColors.blue,
                            fillColor: Colors.transparent,
                            borderColor: AppColors.blue,
                            borderWidth: 1,
                            isBorder: true,
                          )
                        : SizedBox.shrink(),
                    if (isUserChatTap)
                      CustomButtonTwo(
                        onTap: onChatTap ?? () {},
                        title: "CHAT WITH BUYER",
                        textColor: AppColors.blue,
                        fillColor: Colors.transparent,
                        borderColor: AppColors.blue,
                        borderWidth: 1,
                        isBorder: true,
                      ),
                    const SizedBox(height: 10),
                    if (isPending)
                      CustomButtonTwo(
                        onTap: onViewDetailsTap ?? () {},
                        title: "VIEW DETAILS",
                        textColor: AppColors.white,
                        fillColor: AppColors.grey,
                        borderColor: AppColors.primary,
                        borderWidth: 1,
                        isBorder: true,
                      ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
