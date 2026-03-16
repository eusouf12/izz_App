import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:izz_atlas_app/view/screens/user_part/user_message_list_screen/controller/web_socket_service.dart';
import '../../../../../service/api_client.dart';
import '../../../../../service/api_url.dart';
import '../../../../../utils/ToastMsg/toast_message.dart';
import '../../../../../utils/app_const/app_const.dart';
import '../../../vendor_part/vendor_profile_screen/controller/vendor_profile_controller.dart';
import '../../user_home_screen/model/is_existance_model.dart';
import '../model/chat_list_model.dart';
import '../model/inbox_model.dart';

class MessageController extends GetxController {
  // ============== initial text ==========
  final TextEditingController agendaController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  RxBool initialLoading = false.obs;

  Future<void> sendInitialText({required String id}) async {
    if (agendaController.text.trim().isEmpty || detailsController.text.trim().isEmpty) {
      showCustomSnackBar("Subject and Message are required", isError: true);
      return;
    }
    initialLoading.value = true;

    try {
      Map<String, dynamic> body = {
        "subject": agendaController.text.trim(),
        "message": detailsController.text.trim(),
      };


      var response = await ApiClient.postData(ApiUrl.initialSendText(id: id),jsonEncode(body),);

      if (response.statusCode == 200 || response.statusCode == 201) {
        agendaController.clear();
        detailsController.clear();
        showCustomSnackBar("Message sent successfully!", isError: false);
        update();
      } else {
        String errorMsg = response.body['message'] ?? "Something went wrong";
        showCustomSnackBar(errorMsg, isError: true);
      }
    } catch (e) {
      debugPrint("Error: $e");
      showCustomSnackBar("An error occurred. Please try again.", isError: true);
    } finally {
      initialLoading.value = false;
    }
  }

  //============= . vendor exist or not ==============
  Rx<ChannelData?> channelData = Rx<ChannelData?>(null);
  RxBool vendorExist = false.obs;
  RxBool isLoading = false.obs;

  Future<void> getVendorExist({required String id}) async {
    try {
      isLoading.value = true;

      final response = await ApiClient.getData(ApiUrl.initialText(id: id));

      final Map<String, dynamic> jsonResponse = response is Map<String, dynamic> ? response : response.body;
      final model = ChannelResponse.fromJson(jsonResponse);
      vendorExist.value = model.success;
      channelData.value = model.data;

      debugPrint("VENDOR EXIST STATUS => ${vendorExist.value}");
    } catch (e) {
      vendorExist.value = false;
    } finally {
      isLoading.value = false;
    }
  }

//================== get chat list ============================
  final isChatLoading = false.obs;
  int currentPage = 1;
  int totalPages = 1;
  final RxList<ChannelModel> chatList = <ChannelModel>[].obs;

  Future<void> getChatList({bool loadMore = false}) async {
    if (loadMore) {
      if (currentPage >= totalPages) return;
      currentPage++;
    } else {
      currentPage = 1;
      chatList.clear();
      isChatLoading.value = true;
    }

    try {
      final response =
      await ApiClient.getData(ApiUrl.chatList(page: currentPage.toString()));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse =
        response.body is String ? jsonDecode(response.body) : response.body;

        final chatResponse = ChatListResponse.fromJson(jsonResponse);

        totalPages = (chatResponse.data.meta.total / chatResponse.data.meta.limit).ceil();

        chatList.addAll(chatResponse.data.channels);
      }
    } catch (e) {
      debugPrint(' Conversation API Error: $e');
    } finally {
      isChatLoading.value = false;
    }
  }
  final rxStatus = Status.loading.obs;
  void setStatus(Status status) => rxStatus.value = status;

  RxList<MessageModel> messageList = <MessageModel>[].obs;
  Rx<MetaInbox?> pagination = Rx<MetaInbox?>(null);

  int currentInboxPage = 1;
  bool hasMore = true;

  Future<void> getChatMessages({bool loadMore = false, required String channelName,}) async {
    if (loadMore && !hasMore) return;

    if (loadMore) {
      currentInboxPage++;
    } else {
      currentInboxPage = 1;
      messageList.clear();
      hasMore = true;
      setStatus(Status.loading);
    }

    try {
      final response = await ApiClient.getData(ApiUrl.getAllChat(channelName: channelName, page: currentInboxPage.toString(),),);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = response.body is String ? jsonDecode(response.body) : response.body;

        final model = ChatMessagesResponse.fromJson(jsonResponse);

        final List<MessageModel> fetchedMessages = model.data.data;

        messageList.addAll(fetchedMessages);

        pagination.value = model.data.meta;

        hasMore = model.data.meta.page < (model.data.meta.total / model.data.meta.limit).ceil();

        setStatus(Status.completed);
      } else {
        setStatus(Status.error);
      }
    } catch (e) {
      debugPrint(' Chat Message Error: $e');
      setStatus(Status.error);
    }
  }


//=============== socket connection =======================
  final TextEditingController messageController = TextEditingController();
  final VendorProfileController  profileController= Get.put(VendorProfileController());


  RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;

  // ================== PICK IMAGE ==================
  final ImagePicker _imagePicker = ImagePicker();
  Future<void> pickImagesFromGallery() async {
    final List<XFile>? images = await _imagePicker.pickMultiImage(imageQuality: 80);

    if (images != null && images.isNotEmpty) {
      messages.insert(0, {
        "isMe": true,
        "text": "",
        "imageUrl": images.map((e) => e.path).toList(),
        "createdAt": DateTime.now(),
      });
    }
  }

  // ============= listenMessage ============

  @override
  void onInit() {
    super.onInit();
    initSocket();
  }

  void initSocket() {
    WebSocketService.connect(ApiUrl.websocket);
    listenMessage();
  }
//================ listenMessage=============
  void listenMessage() {
    WebSocketService.stream?.listen((event) {
        final data = jsonDecode(event);
        print("📩 Received: $data");

        if (data['type'] == 'message') {
          messages.insert(0, {
            "isMe": false,
            "text": data['message'] ?? '',
            "imageUrl": data['files'] ?? [],
            "createdAt": DateTime.now(),
          });
        }
      },
      onError: (error) {print("❌ Stream Error: $error");
      },
      onDone: () {
        print("🔌 WebSocket Closed");
      },
    );
  }
  // =========== send message =========
  Future<void> sendMessage({required String channelName, required String senderId}) async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    if (!WebSocketService.isConnected) {
      print("🔄 Reconnecting before send...");
      WebSocketService.connect(ApiUrl.websocket);
      await Future.delayed(const Duration(seconds: 2));
    }

    final body = {
      "type": "message",
      "channelName": channelName,
      "senderId": senderId,
      "message": text,
    };

    try {
      WebSocketService.send(body);
      messages.insert(0, {
        "isMe": true,
        "text": text,
        "imageUrl": <String>[],
        "createdAt": DateTime.now(),
      });
      messageController.clear();
    } catch (e) {
      print("❌ Failed to send after retry: $e");
    }
  }


}
