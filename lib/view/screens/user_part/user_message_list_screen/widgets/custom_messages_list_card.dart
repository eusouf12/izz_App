import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../components/custom_netwrok_image/custom_network_image.dart';
import '../../../../components/custom_text/custom_text.dart';

class CustomMessagesListCard extends StatelessWidget {
  final String profileImage;
  final String name;
  final String lastMessage;
  final DateTime? time;

  const CustomMessagesListCard({
    super.key,
    required this.profileImage,
    required this.name,
    required this.lastMessage,
    this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff111827), Color(0xff1F2937)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Left side
              Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CustomNetworkImage(
                        imageUrl: profileImage,
                        height: 60,
                        width: 60,
                        boxShape: BoxShape.circle,
                      ),

                    ],
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: name,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white,
                      ),
                      CustomText(
                        text: lastMessage,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textClr,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),

              CustomText(
                text: formatChatTime(time),
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.textClr,
                bottom: 8,
              ),


            ],
          ),
        ),
      ),
    );
  }
}
String formatChatTime(DateTime? dateTime) {
  if (dateTime == null) return '';

  final localTime = dateTime.toLocal();
  return DateFormat('hh:mm a').format(localTime);
}
