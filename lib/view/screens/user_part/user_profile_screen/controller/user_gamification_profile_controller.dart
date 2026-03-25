import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../service/api_client.dart';
import '../../../../../service/api_url.dart';
import '../model/user_gamification_profile_model.dart';

class UserGamificationController extends GetxController {
  RxBool isLoading = false.obs;

  Rx<UserGamificationProfileModel?> gamificationModel = Rx<UserGamificationProfileModel?>(null);

  Future<void> fetchGamificationProfile() async {
    try {
      isLoading.value = true;

      final response = await ApiClient.getData(ApiUrl.gamificationProfile,);

      if (response.statusCode == 200) {
        gamificationModel.value =
            UserGamificationProfileModel.fromJson(response.body);
      }
    } catch (e) {
      debugPrint("Gamification Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
