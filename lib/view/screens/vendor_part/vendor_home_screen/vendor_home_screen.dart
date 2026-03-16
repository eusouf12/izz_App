import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:izz_atlas_app/utils/app_colors/app_colors.dart';
import 'package:izz_atlas_app/utils/app_icons/app_icons.dart';
import 'package:izz_atlas_app/view/components/custom_image/custom_image.dart';
import 'package:izz_atlas_app/view/components/custom_nav_bar/vendor_navbar.dart';
import '../../../../core/app_routes/app_routes.dart';
import '../../../components/custom_text/custom_text.dart';
import '../vendor_profile_screen/controller/vendor_profile_controller.dart';
import 'controller/vendor_controller.dart';

class VendorHomeScreen extends StatefulWidget {
  const VendorHomeScreen({super.key});

  @override
  State<VendorHomeScreen> createState() => _VendorHomeScreenState();
}

class _VendorHomeScreenState extends State<VendorHomeScreen> {
  final VendorHomeController controller = Get.put(VendorHomeController());
  final VendorProfileController vendorProfileController =
  Get.put(VendorProfileController());

  bool isBookingChartVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      vendorProfileController.getUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 60, right: 16, left: 18),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: "Dashboard",
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                  IconButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.userNotificationScreen);
                    },
                    icon: Icon(
                      Icons.notifications,
                      color: AppColors.black,
                      size: 28,
                    ),
                  ),
                ],
              ),

              /// Welcome
              Obx(() {
                final name = vendorProfileController
                    .userProfileModel.value.fullName ??
                    "";
                return CustomText(
                  text: "Welcome Back, $name",
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  bottom: 20,
                );
              }),

              /// Dashboard Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildDashboardCard(
                      "Total Bookings", "128", "This month"),
                  _buildDashboardCard(
                      "Total Earnings", "85,200", "This month"),
                ],
              ),

              CustomText(
                text: "Quick Actions",
                fontSize: 18,
                fontWeight: FontWeight.w700,
                top: 20,
                bottom: 20,
              ),

              QuickButton(
                text: "+ADD VENUE",
                onTap: () {
                  Get.toNamed(AppRoutes.addVenueScreen);
                },
              ),
              const SizedBox(height: 20),

              QuickButton(
                text: "MY VENUES",
                onTap: () {
                  Get.toNamed(AppRoutes.vendorMyVenuesScreen);
                },
              ),
              const SizedBox(height: 20),

              /// BOOKINGS TREND
              QuickButton(
                text: "BOOKINGS TREND",
                onTap: () {
                  setState(() {
                    isBookingChartVisible = !isBookingChartVisible;
                  });
                },
              ),

              if (isBookingChartVisible)
                _buildBookingsTrendChart(screenWidth),

              Center(child: CustomImage(imageSrc: AppIcons.arrowDown)),
              const SizedBox(height: 30),

              CustomText(
                text: "Recent Activity",
                fontSize: 18,
                fontWeight: FontWeight.w700,
                bottom: 20,
              ),

              _buildRecentActivity(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const VendorNavbar(currentIndex: 0),
    );
  }

  /// ================= Dashboard Card =================
  Widget _buildDashboardCard(
      String title, String value, String subtitle) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 26),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff111827), Color(0xff1F2937)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: title,
            fontSize: 14,
            color: AppColors.textClr,
          ),
          CustomText(
            text: value,
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.white,
          ),
          CustomText(
            text: subtitle,
            fontSize: 14,
            color: AppColors.textClr,
          ),
        ],
      ),
    );
  }

  /// ================= RESPONSIVE BOOKINGS TREND CHART =================
  Widget _buildBookingsTrendChart(double screenWidth) {
    final chartHeight = MediaQuery.of(context).size.height * 0.28;

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [
            Color(0xff0F172A),
            Color(0xff020617),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: "Earnings Trend",
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CustomText(
                  text: "This Week",
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// Chart Bars
          SizedBox(
            height: chartHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _responsiveBar("Mon", 0.3, chartHeight, screenWidth),
                _responsiveBar("Tue", 0.45, chartHeight, screenWidth),
                _responsiveBar("Wed", 0.6, chartHeight, screenWidth),
                _responsiveBar("Thu", 0.75, chartHeight, screenWidth),
                _responsiveBar("Fri", 0.9, chartHeight, screenWidth),
                _responsiveBar("Sat", 0.6, chartHeight, screenWidth),
                _responsiveBar("Sun", 0.7, chartHeight, screenWidth),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _responsiveBar(
      String day,
      double percentage,
      double chartHeight,
      double screenWidth,
      ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: screenWidth * 0.035,
          height: chartHeight * percentage,
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 6),
        CustomText(
          text: day,
          fontSize: 12,
          color: AppColors.white,
        ),
      ],
    );
  }

  /// ================= Recent Activity =================
  Widget _buildRecentActivity() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff111827), Color(0xff1F2937)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "Football Ground A",
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
              CustomText(
                text: "10:00 AM - 12:00 PM",
                fontSize: 14,
                color: AppColors.textClr,
              ),
              CustomText(
                text: "John Smith",
                fontSize: 14,
                color: AppColors.textClr,
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.green2.withValues(alpha: .2),
              borderRadius: BorderRadius.circular(30),
            ),
            child: CustomText(
              text: "CONFIRMED",
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.green2,
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= Quick Button =================
class QuickButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onTap;

  const QuickButton({super.key, this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.greyLight,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: CustomText(
            text: text ?? "",
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
      ),
    );
  }
}
