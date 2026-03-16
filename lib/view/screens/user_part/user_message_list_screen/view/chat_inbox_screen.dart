
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import '../../../../../service/api_url.dart';
import '../../../../../utils/app_const/app_const.dart';
import '../../../../components/custom_loader/custom_loader.dart';
import '../../../../components/custom_netwrok_image/custom_network_image.dart';
import '../../../../components/custom_text/custom_text.dart';
import '../../../vendor_part/vendor_profile_screen/controller/vendor_profile_controller.dart';
import '../controller/message_controller.dart';


class ChatInboxScreen extends StatelessWidget {
  ChatInboxScreen({super.key});

  final VendorProfileController  profileController= Get.put(VendorProfileController());
  final MessageController controller = Get.put(MessageController());
  final Map<String, dynamic> args = Get.arguments;

  @override
  Widget build(BuildContext context) {
    final String channelName = args['channelName'];
    final String userName = args['userName'];
    final String userImage = args['userImage'];
    WidgetsBinding.instance.addPostFrameCallback((_)async{
      controller.getChatMessages(channelName: channelName);
      profileController.getUserProfile();
    });

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 0,
          leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
            onPressed: () async{
              await controller.getChatList();
              Get.back();
            },
          ),
          title: Row(
            children:  [
              CircleAvatar(
                backgroundImage: NetworkImage(userImage),
                radius: 20,
              ),
              SizedBox(width: 10),
              Text( userName,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Divider(thickness: 1, color: Colors.grey[300]),
              Expanded(
                child: Obx(() {
                  if (controller.rxStatus.value == Status.loading && controller.messageList.isEmpty) {
                    return const Center(child: CustomLoader());
                  }

                  if (controller.rxStatus.value == Status.completed && controller.messageList.isEmpty && controller.messages.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.chat_bubble_outline, size: 80, color: Color(0xFF4DB6AC)),
                        SizedBox(height: 15),
                        Text("Start your message", style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    );
                  }


                  return NotificationListener<ScrollNotification>(
                    onNotification: (scrollInfo) {
                      if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent && controller.rxStatus.value != Status.loading && controller.hasMore) {
                        controller.getChatMessages(loadMore: true, channelName: channelName );
                      }
                      return false;
                    },
          
                    child:
                    ListView.builder(
                      reverse: true,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      itemCount: controller.messages.length + controller.messageList.length + (controller.hasMore ? 1 : 0),
                      itemBuilder: (_, index) {
                        if (controller.hasMore && index == controller.messages.length + controller.messageList.length) {
                          return const Padding(
                            padding: EdgeInsets.all(10),
                            child: Center(child: CustomLoader()),
                          );
                        }

                        // 🔹 Local socket messages (newest)
                        if (index < controller.messages.length) {
                          return ChatBubble(
                            msg: controller.messages[index],
                          );
                        }

                        // 🔹 API messages (older)
                        final apiIndex = index - controller.messages.length;
                        final msg = controller.messageList[apiIndex];

                        return ChatBubble(
                          msg: {
                            "isMe": msg.senderId == profileController.userProfileModel.value.id,
                            "text": msg.message,
                            "imageUrl": msg.files,
                            "createdAt": msg.createdAt,
                          },
                        );
                      },
                    ),
                  );
                }),
              ),
              // ================== INPUT ==================
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border:
                          Border.all(color: const Color(0xFF4DB6AC)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: controller.messageController,
                                decoration: const InputDecoration(
                                  hintText: "Type something...",
                                  border: InputBorder.none,
                                  contentPadding:
                                  EdgeInsets.symmetric(horizontal: 15),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.image_outlined,
                                  color: Color(0xFF4DB6AC)),
                              onPressed:
                              controller.pickImagesFromGallery,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        controller.sendMessage(
                          channelName: channelName,
                          senderId: profileController.userProfileModel.value.id,
                        );

                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: const Color(0xFF4DB6AC)),
                        ),
                        child: const Icon(Icons.send_outlined,
                            color: Color(0xFF4DB6AC)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }
}


class ChatBubble extends StatelessWidget {
  final Map<String, dynamic> msg;
  const ChatBubble({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    final bool isMe = msg['isMe'] ?? false;
    final String text = msg['text'] ?? '';
    final List images = msg['imageUrl'] ?? [];
    final DateTime? time = msg['createdAt'];

    return Column(
      crossAxisAlignment:
      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        // Bubble
        Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: images.isEmpty ? const EdgeInsets.all(10) : const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:  Colors.grey[300],
              borderRadius: BorderRadius.circular(images.isEmpty ? 5 : 23),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (images.isNotEmpty)
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: images.map<Widget>((img) {
                      final imagePath = img.toString();
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  FullScreenImage(imagePath: imagePath),
                            ),
                          );
                        },
                        child: Hero(
                          tag: imagePath,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: _buildImage(context, imagePath),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                if (text.trim().isNotEmpty && images.isNotEmpty)
                  const SizedBox(height: 6),

                if (text.trim().isNotEmpty)
                  Padding(padding: images.isNotEmpty ? const EdgeInsets.all(10) : EdgeInsets.zero,
                    child: CustomText(
                      text: text,
                      fontSize: 14.sp,
                      color: Colors.black,
                      maxLines: 100,
                    ),
                  ),
              ],
            ),
          ),
        ),
        // TIME
        if (time != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Align(
              alignment:
              isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Text(
                DateFormat('hh:mm a').format(time.toLocal()),
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.black,
                ),
              ),
            ),
          ),
      ],
    );

  }

  Widget _buildImage(BuildContext context, String path) {
    //==== local cash image
    if (path.startsWith('/data') || path.startsWith('/storage')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.file(
          File(path),
          width: MediaQuery.sizeOf(context).width * 0.7,
          height: 150,
          fit: BoxFit.cover,
        ),
      );
    }

    // ==== backend img
    final fullUrl = path.startsWith('http') ? path : "${ApiUrl.baseUrl}$path";

    return CustomNetworkImage(
      imageUrl: fullUrl,
      width: MediaQuery.sizeOf(context).width * 0.7,
      height: 150,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
    );
  }

}

class FullScreenImage extends StatelessWidget {
  final String imagePath;
  const FullScreenImage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final bool isLocal =
        imagePath.startsWith('/data') || imagePath.startsWith('/storage');

    final ImageProvider imageProvider = isLocal
        ? FileImage(File(imagePath))
        : NetworkImage(
      imagePath.startsWith('http')
          ? imagePath
          : "${ApiUrl.baseUrl}$imagePath",
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Hero(
          tag: imagePath,
          child: PhotoView(
            imageProvider: imageProvider,
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
            backgroundDecoration:
            const BoxDecoration(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
