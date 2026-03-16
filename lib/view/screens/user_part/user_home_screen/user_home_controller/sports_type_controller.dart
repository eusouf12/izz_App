import 'package:get/get.dart';
import '../../../../../service/api_client.dart';
import '../../../../../service/api_url.dart';
import '../../../../../utils/ToastMsg/toast_message.dart';
import '../model/sports_type_model.dart';

class SportsTypeController extends GetxController {

  RxList<SportsType> sportsList = <SportsType>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getAllSports();
  }

  Future<void> getAllSports() async {
    try {
      isLoading.value = true;

      final response = await ApiClient.getData(ApiUrl.getSportsTypes);

      /// 🔥 IMPORTANT FIX
      final Map<String, dynamic> jsonResponse =
      response is Map<String, dynamic>
          ? response
          : response.body;

      print("SPORT API RESPONSE => $jsonResponse");

      final model = SportsTypeResponseModel.fromJson(jsonResponse);

      sportsList.assignAll(model.data?.data ?? []);

      print("SPORT LIST COUNT => ${sportsList.length}");
    } catch (e) {
      print("SPORT ERROR => $e");
      showCustomSnackBar(e.toString(), isError: true);
    } finally {
      isLoading.value = false;
    }
  }
}
