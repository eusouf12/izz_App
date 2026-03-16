import 'package:flutter/material.dart';
import 'package:izz_atlas_app/utils/app_colors/app_colors.dart';
import 'package:izz_atlas_app/view/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:izz_atlas_app/view/screens/user_part/user_message_list_screen/widgets/custom_messages_list_card.dart';


class VendorMessageListScreen extends StatelessWidget {
  const VendorMessageListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomRoyelAppbar(leftIcon: true, titleName: "Messages"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: List.generate(6, (value) {
            return CustomMessagesListCard(profileImage: '', name: '', lastMessage: '',);
          }),
        ),
      ),
    );
  }
}
