import 'dart:convert';

import 'package:get/get.dart';

import '../../../../../service/api_check.dart';
import '../../../../../service/api_client.dart';
import '../../../../../service/api_url.dart';
import '../../../../../utils/ToastMsg/toast_message.dart';
import '../model/notification_model.dart';

class NotificationController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<NotificationItem> notificationList = <NotificationItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    getNotifications();
  }

  Future<void> getNotifications() async {
    isLoading.value = true;
    try {
      final response = await ApiClient.getData(ApiUrl.notification);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = response.body is String
            ? jsonDecode(response.body)
            : response.body;

        final model = NotificationModel.fromJson(jsonResponse);
        notificationList.assignAll(model.data);
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      showCustomSnackBar("Error fetching notifications: $e", isError: true);
    } finally {
      isLoading.value = false;
    }
  }
}
