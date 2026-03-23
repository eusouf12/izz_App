import 'dart:convert';

import 'package:get/get.dart';
import '../../../../../service/api_client.dart';
import '../../../../../service/api_url.dart';
import '../../../../../utils/ToastMsg/toast_message.dart';
import '../model/sports_type_model.dart';

class SportsTypeController extends GetxController {

  RxList<SportsType> sportsList = <SportsType>[].obs;
  final isSportsLoading = false.obs;
  final isSportsLoadMore = false.obs;
  int currentPage = 1;
  int totalPages = 1;

  Future<void> getAllSports({bool loadMore = false, String? search,}) async {

    if (loadMore) {
      if (isSportsLoadMore.value || currentPage >= totalPages) return;

      isSportsLoadMore.value = true;
      currentPage++;

    }
    else {
      isSportsLoading.value = true;
      currentPage = 1;
      sportsList.clear();
    }

    try {
      final response = await ApiClient.getData(
        ApiUrl.getSportsTypes(page: currentPage.toString(), search: search,),);

      final Map<String, dynamic> jsonResponse = response.body is String ? jsonDecode(response.body) : Map<String, dynamic>.from(response.body);

      final model = SportsTypeResponseModel.fromJson(jsonResponse);

      totalPages = model.data?.meta?.total ?? 1;

      final newData = model.data?.data ?? [];

      /// 🔥 duplicate remove
      final existingIds = sportsList.map((e) => e.id).toSet();

      for (final item in newData) {
        if (!existingIds.contains(item.id)) {
          sportsList.add(item);
        }
      }

    } catch (e) {
      showCustomSnackBar(e.toString(), isError: true);
      print("SPORT ERROR => $e");

    } finally {
      isSportsLoading.value = false;
      isSportsLoadMore.value = false;
    }
  }
}
