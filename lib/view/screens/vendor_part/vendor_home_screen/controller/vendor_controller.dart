import 'package:get/get.dart';


class VendorHomeController extends GetxController {
  RxBool isChartVisible = false.obs;

  void toggleChart() {
    isChartVisible.value = !isChartVisible.value;
  }
}
