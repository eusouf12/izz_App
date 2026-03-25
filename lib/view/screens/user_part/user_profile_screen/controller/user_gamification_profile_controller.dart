import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../service/api_client.dart';
import '../../../../../service/api_url.dart';
import '../../../../../utils/ToastMsg/toast_message.dart';
import '../model/level_model.dart';
import '../model/streak_model.dart';
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
  
  // ========== UserStreak ==========
  RxList<StreakData> streakList = <StreakData>[].obs;
  RxBool isStreakLoading = false.obs;
  Future<void> getUserStreak() async {
    try {
      isStreakLoading.value = true;
      final response = await ApiClient.getData(ApiUrl.userStreak);
      final jsonResponse = response.body is String ? jsonDecode(response.body) : response.body;

      if (response.statusCode == 200) {

        final model = StreakResponse.fromJson(jsonResponse);
        streakList.assignAll(model.data ?? []);
        debugPrint("Streak Loaded: ${streakList.length}");

      } else {

        showCustomSnackBar(jsonResponse["message"] ?? "Failed to fetch streak", isError: true,);
      }

    } catch (e) {
      showCustomSnackBar(e.toString(), isError: true);
    } finally {
      isStreakLoading.value = false;
    }
  }
  // ========== get reward ==========
  final isClaimLoading = false.obs;
  Future<void> claimStreakReward() async {
    isClaimLoading.value = true;

    try {
      final body = {
        "action": "DAILY_LOGIN",
        "description": "User logged in today",
      };

      final response = await ApiClient.postData(ApiUrl.climeReward, jsonEncode(body),);
      final jsonResponse = response.body is String ? jsonDecode(response.body) : Map<String, dynamic>.from(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar(jsonResponse["message"] ?? "Reward claimed successfully", isError: false,);
      } else {
        showCustomSnackBar(jsonResponse["message"] ?? "Failed to claim reward", isError: true,);
      }

    } catch (e) {

      showCustomSnackBar(
        "Error: ${e.toString()}",
        isError: true,
      );

    } finally {
      isClaimLoading.value = false;
    }
  }

  // level controller===========
  RxList<LevelData> levelList = <LevelData>[].obs;
  RxBool isLevelLoading = false.obs;

  Future<void> getLevels() async {

    try {
      isLevelLoading.value = true;

      final response = await ApiClient.getData(ApiUrl.levelDetails);

      final jsonResponse = response.body is String ? jsonDecode(response.body) : response.body;

      if (response.statusCode == 200) {
        final model = LevelResponse.fromJson(jsonResponse);
        levelList.assignAll(model.data ?? []);
      } else {
        showCustomSnackBar(jsonResponse["message"] ?? "Failed to fetch levels", isError: true,);
      }

    } catch (e) {
      showCustomSnackBar(e.toString(), isError: true);
    } finally {
      isLevelLoading.value = false;
    }
  }


}
