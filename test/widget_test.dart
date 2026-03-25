import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:izz_atlas_app/view/screens/user_part/user_profile_screen/user_profile_screen.dart';
import 'package:izz_atlas_app/view/screens/vendor_part/vendor_profile_screen/controller/vendor_profile_controller.dart';
import 'package:izz_atlas_app/view/screens/user_part/user_profile_screen/controller/user_gamification_profile_controller.dart';

void main() {
  testWidgets('Profile Screen UI Test with ScreenUtil', (WidgetTester tester) async {
    // ১. কন্ট্রোলারগুলো ইনজেক্ট করা
    Get.put(VendorProfileController());
    Get.put(UserGamificationController());

    // ২. ScreenUtilInit দিয়ে র‍্যাপ করা যাতে LateInitializationError না আসে
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(360, 690), // আপনার অ্যাপের ডিজাইন সাইজ দিন
        minTextAdapt: true,
        builder: (context, child) => GetMaterialApp(
          home: UserProfileScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Logout'), findsOneWidget);
  });
}