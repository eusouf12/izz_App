import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:izz_atlas_app/utils/app_colors/app_colors.dart';
import 'package:izz_atlas_app/utils/app_const/app_const.dart';
import 'package:izz_atlas_app/view/components/custom_loader/custom_loader.dart';
import 'package:izz_atlas_app/view/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:izz_atlas_app/view/components/general_error.dart';
import 'controller/vendor_profile_controller.dart';

class VendorTermsScreen extends StatelessWidget {
  VendorTermsScreen({super.key});

  final VendorProfileController controller = Get.put(VendorProfileController());

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getTermsConditions();
    });

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomRoyelAppbar(
          leftIcon: true,
          titleName: "Terms & Conditions",
          color: AppColors.black,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Obx(() {
            switch (controller.rxTermsStatus.value) {
              case Status.loading:
                return const Center(
                  child: CustomLoader(),
                );

              case Status.internetError:
                return GeneralErrorScreen(
                  onTap: () => controller.getTermsConditions(),
                );

              case Status.error:
                return GeneralErrorScreen(
                  onTap: () => controller.getTermsConditions(),
                );

              case Status.completed:
                return SingleChildScrollView(
                  child: HtmlWidget(
                    controller.termsResponse.value.data != null &&
                        controller.termsResponse.value.data!.isNotEmpty
                        ? controller.termsResponse.value.data!.first.description ?? ''
                        : 'Terms & Conditions data not found',
                    textStyle: TextStyle(
                      color: AppColors.black,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                );

            }
          }),
        ),
      );
  }
}
