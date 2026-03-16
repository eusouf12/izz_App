import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:izz_atlas_app/utils/app_colors/app_colors.dart';
import 'package:izz_atlas_app/view/screens/user_part/user_message_list_screen/widgets/custom_messages_list_card.dart';
import '../../../../../../core/app_routes/app_routes.dart';import '../../../../../service/api_url.dart';
import '../../../../components/custom_loader/custom_loader.dart';
import '../../../../components/custom_royel_appbar/custom_royel_appbar.dart';
import '../../../../components/custom_text/custom_text.dart';
import '../controller/message_controller.dart';

  class UserMessageListScreen extends StatelessWidget {
    UserMessageListScreen({super.key});

     final MessageController controller = Get.put(MessageController());

    @override
    Widget build(BuildContext context) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
         controller.getChatList(loadMore: false);
      });

      return Scaffold(
        backgroundColor: AppColors.white,
          appBar: CustomRoyelAppbar(leftIcon: true, titleName: "Messages",),

          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Obx(() {
              //========= Loader =========
              if (controller.isChatLoading.value && controller.chatList.isEmpty) {
                return const Center(child: CustomLoader());
              }

              if (controller.chatList.isEmpty) {
                return const Center(child: CustomText(text: "No chatList found",color: AppColors.black, fontSize: 16,),);
              }

              return NotificationListener<ScrollNotification>(
                onNotification: (scrollInfo) {
                  if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent && !controller.isLoading.value) {controller.getChatList(loadMore: true);}
                  return false;
                },

                child: ListView.builder(
                   itemCount: controller.chatList.length + (controller.isLoading.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < controller.chatList.length) {
                      final chat = controller.chatList[index];
                      return GestureDetector(
                        onTap: (){
                          debugPrint("${chat.channelName}");
                          debugPrint("${chat.person2.fullName}");
                          debugPrint("===============${chat.person2.profileImage}");
                          Get.toNamed(AppRoutes.chatInboxScreen,
                            arguments: {
                              'channelName': chat.channelName,
                              'userName': chat.person2.fullName,
                              'userImage': chat.person2.profileImage,
                            },
                          );
                        },
                        child: CustomMessagesListCard(
                          profileImage: chat.person2.profileImage,
                          name: chat.person2.fullName,
                          lastMessage: chat.lastMessage.message,
                          time: chat.createdAt,
                        ),
                      );
                    }

                    /// ========= Pagination Loader =========
                    return const Padding(
                      padding: EdgeInsets.all(12),
                      child: Center(child: CustomLoader()),
                    );
                  },
                ),
              );
            }),
          ),
        );
    }
  }
