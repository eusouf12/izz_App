import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:izz_atlas_app/utils/app_colors/app_colors.dart';
import 'package:izz_atlas_app/view/components/custom_loader/custom_loader.dart';
import 'package:izz_atlas_app/view/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:izz_atlas_app/view/components/custom_text/custom_text.dart';
import 'controller/vendor_profile_controller.dart';

class VendorAboutUsScreen extends StatelessWidget {
  VendorAboutUsScreen({super.key});

  final VendorProfileController controller = Get.put(VendorProfileController());

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getAboutUsData();
    });

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomRoyelAppbar(
        leftIcon: true,
        titleName: "About Us",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20.0),
        child: Obx(() {
          // Show Loader
          if (controller.isLoadingAbout.value) {
            return const CustomLoader();
          }

          // Show message if no content
          if (controller.aboutResponse.value.data!.description!.isEmpty) {
            return const Center(
              child: CustomText(
                text: "No About Us content found.",
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            );
          }

          // Show Content

          return SingleChildScrollView(
            child: HtmlWidget(
              controller.aboutResponse.value.data?.description?.isNotEmpty == true
                  ? controller.aboutResponse.value.data!.description!
                  : 'About Us data not found',
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
