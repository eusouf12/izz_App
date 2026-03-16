import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:izz_atlas_app/utils/app_colors/app_colors.dart';
import 'package:izz_atlas_app/view/components/custom_loader/custom_loader.dart';
import 'package:izz_atlas_app/view/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:izz_atlas_app/view/components/custom_text/custom_text.dart';
import 'controller/vendor_profile_controller.dart'; // কন্ট্রোলার ইম্পোর্ট করুন

class VendorPrivacyScreen extends StatefulWidget {
  const VendorPrivacyScreen({super.key});

  @override
  State<VendorPrivacyScreen> createState() => _VendorPrivacyScreenState();
}

class _VendorPrivacyScreenState extends State<VendorPrivacyScreen> {
  // কন্ট্রোলার ইনিশিলাইজ
  final VendorProfileController controller = Get.put(VendorProfileController());

  @override
  void initState() {
    super.initState();
    // স্ক্রিন ওপেন হওয়ার সাথে সাথে ডাটা ফেচ করবে
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getPrivacyPolicy();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomRoyelAppbar(
        leftIcon: true,
        titleName: "Privacy Policy",
        color: AppColors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20.0),
        child: Obx(() {
          // ১. লোডিং অবস্থা চেক
          if (controller.isLoading.value) {
            return const CustomLoader();
          }

          // ২. ডাটা না থাকলে মেসেজ দেখানো
          if (controller.privacyContent.value.isEmpty) {
            return const Center(
              child: CustomText(
                text: "No Privacy Policy found.",
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            );
          }

          // ৩. ডাটা থাকলে দেখানো
          return SingleChildScrollView(
            child: HtmlWidget(
              controller.privacyContent.value.isNotEmpty
                  ? controller.privacyContent.value
                  : 'Terms & Conditions data not found',
              textStyle: TextStyle(
                color: AppColors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          );
        }),
      ),
    );
  }
}