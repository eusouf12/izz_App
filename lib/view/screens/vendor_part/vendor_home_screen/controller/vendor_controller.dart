import 'dart:convert';

import 'package:get/get.dart';

import '../../../../../service/api_client.dart';
import '../../../../../service/api_url.dart';
import '../../../../../utils/ToastMsg/toast_message.dart';
import '../model/earning_model.dart';


class VendorHomeController extends GetxController {
  RxBool isChartVisible = false.obs;

  void toggleChart() {
    isChartVisible.value = !isChartVisible.value;
  }
 // =========== get earning  api =====================
  Rx<VendorEarningsData?> vendorEarnings = Rx<VendorEarningsData?>(null);
RxBool isVendorEarningsLoading = false.obs;

Future<void> getVendorEarnings() async {

  try {
    isVendorEarningsLoading.value = true;

    String currentYear = DateTime.now().year.toString();
    final response = await ApiClient.getData(ApiUrl.vendorEarnings(year: currentYear));

    final jsonResponse = response.body is String ? jsonDecode(response.body): response.body;

    if (response.statusCode == 200) {

      final model = VendorEarningsResponse.fromJson(jsonResponse);

      vendorEarnings.value = model.data;

    } else {

      showCustomSnackBar(jsonResponse["message"] ?? "Failed to fetch earnings", isError: true, );
    }

  } catch (e) {

    showCustomSnackBar( e.toString(),isError: true, );

  } finally {

    isVendorEarningsLoading.value = false;
  }
}
}
