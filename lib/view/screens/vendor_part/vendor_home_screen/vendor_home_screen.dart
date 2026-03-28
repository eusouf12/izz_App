import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:izz_atlas_app/utils/app_colors/app_colors.dart';
import 'package:izz_atlas_app/utils/app_icons/app_icons.dart';
import 'package:izz_atlas_app/view/components/custom_image/custom_image.dart';
import 'package:izz_atlas_app/view/components/custom_loader/custom_loader.dart';
import 'package:izz_atlas_app/view/components/custom_nav_bar/vendor_navbar.dart';
import 'package:izz_atlas_app/view/screens/vendor_part/vendor_home_screen/controller/vendor_my_booking_controller.dart';
import '../../../../core/app_routes/app_routes.dart';
import '../../../components/custom_text/custom_text.dart';
import '../vendor_profile_screen/controller/vendor_profile_controller.dart';
import 'controller/vendor_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'model/earning_model.dart';

// ignore: must_be_immutable
class VendorHomeScreen extends StatelessWidget {
   VendorHomeScreen({super.key});
  final VendorHomeController controller = Get.put(VendorHomeController());
  final VendorProfileController vendorProfileController =Get.put(VendorProfileController());
  final VendorMyBookingController vendorMyBookingController = Get.put(VendorMyBookingController());
  final RxBool isBookingChartVisible = false.obs;
  final RxBool isEarningsChartVisible = false.obs;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      vendorProfileController.getUserProfile();
      vendorMyBookingController.fetchInitialBookings("Requested");
      controller.getVendorEarnings();
    });

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 60, right: 16, left: 18),
        child: Obx(() {
          if (controller.isVendorEarningsLoading.value) {
            return const Center(child: CustomLoader());
          }
          return SingleChildScrollView(
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
                    .userProfileModel.value.fullName ;
                return CustomText(
                  text: "Welcome Back, $name",
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  bottom: 20,
                );
              }),

              /// Dashboard Cards
              Obx(() {
                 final earningData = controller.vendorEarnings.value;
                 return Row(
                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                   children: [
                     _buildDashboardCard(
                         "Total Bookings", "${earningData?.currentMonthBookings ?? 0}", "This month"),
                     _buildDashboardCard(
                         "Total Earnings", "\$${earningData?.currentMonthEarnings ?? 0}", "This month"),
                   ],
                 );
              }),

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
              // my create venue
              QuickButton(
                text: "MY VENUES",
                onTap: () {
                  Get.toNamed(AppRoutes.vendorMyVenuesScreen);
                },
              ),
              const SizedBox(height: 20),

              /// EARNINGS TREND
              QuickButton(
                text: "EARNINGS TREND",
                onTap: () {
                  isEarningsChartVisible.toggle();
                  if (isEarningsChartVisible.value) isBookingChartVisible.value = false;
                },
              ),

              Obx(() {
                if (isEarningsChartVisible.value) {
                  return _buildEarningsTrendChart(context);
                } else {
                  return const SizedBox.shrink();
                }
              }),
              const SizedBox(height: 20),

              /// BOOKINGS TREND
              QuickButton(
                text: "BOOKINGS TREND",
                onTap: () {
                  isBookingChartVisible.toggle();
                  if (isBookingChartVisible.value) isEarningsChartVisible.value = false;
                },
              ),

              Obx(() {
                if (isBookingChartVisible.value) {
                  return _buildBookingsTrendChart(context);
                } else {
                  return const SizedBox.shrink();
                }
              }),

              Center(child: CustomImage(imageSrc: AppIcons.arrowDown)),
              const SizedBox(height: 30),
             // ===== Recent Activity =======
              CustomText(
                text: "Recent Activity",
                fontSize: 18,
                fontWeight: FontWeight.w700,
                bottom: 20,
              ),
              Obx(() {
                if (vendorMyBookingController.isLoading.value) {
                  return const Center(child: CustomLoader());
                }
                var bookings = vendorMyBookingController.bookings;
                if (bookings.isEmpty) {
                  return Center(
                    child: CustomText(
                      text: "No recent activities found",
                      color: AppColors.textClr,
                    ),
                  );
                }
                int count = bookings.length > 5 ? 5 : bookings.length;
                return Column(
                  children: List.generate(count, (index) {
                    final booking = bookings[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: _buildRecentActivity(booking),
                    );
                  }),
                );
              }),
            ],
          ), // closes Column
        ); // closes SingleChildScrollView
      }), // closes Obx
      ), // closes Padding
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

  Widget _buildEarningsTrendChart(BuildContext context) {
    final earningsData = controller.vendorEarnings.value;
    final List<EarningsTrend> trend = earningsData?.earningsTrend ?? [];
    
    if (trend.isEmpty) {
       return const Padding(
         padding: EdgeInsets.all(16.0),
         child: Center(child: Text("No earnings data available for this year", style: TextStyle(color: Colors.grey))),
       );
    }

    final double maxEarning = trend.fold(0.0, (m, t) => (t.earnings ?? 0) > m ? (t.earnings ?? 0).toDouble() : m);
    final double maxY = maxEarning == 0 ? 10 : maxEarning * 1.2;

    return Container(
      height: 280,
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xff0F172A), Color(0xff020617)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(text: "Earnings Trend", fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.white),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(20)),
                child: CustomText(text: "This Year", fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: BarChart(
              BarChartData(
                maxY: maxY,
                barGroups: trend.asMap().entries.map((e) {
                  return BarChartGroupData(
                    x: e.key,
                    barRods: [
                      BarChartRodData(
                        toY: (e.value.earnings ?? 0).toDouble(),
                        color: Colors.amber,
                        width: 14,
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                      )
                    ],
                  );
                }).toList(),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                           padding: const EdgeInsets.only(right: 8),
                           child: Text(
                             value >= 1000 ? "\$${(value / 1000).toStringAsFixed(0)}k" : "\$${value.toStringAsFixed(0)}",
                             style: const TextStyle(color: Colors.grey, fontSize: 10),
                             textAlign: TextAlign.right,
                           ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < 0 || value.toInt() >= trend.length) return const SizedBox();
                        String month = trend[value.toInt()].month ?? "";
                        if (month.length > 3) month = month.substring(0, 3);
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(month, style: const TextStyle(color: Colors.grey, fontSize: 10)),
                        );
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsTrendChart(BuildContext context) {
    final earningsData = controller.vendorEarnings.value;
    final List<BookingsTrend> trend = earningsData?.bookingsTrend ?? [];
    
    if (trend.isEmpty) {
       return const Padding(
         padding: EdgeInsets.all(16.0),
         child: Center(child: Text("No booking data available for this year", style: TextStyle(color: Colors.grey))),
       );
    }

    final double maxBooking = trend.fold(0.0, (m, t) => (t.bookings ?? 0) > m ? (t.bookings ?? 0).toDouble() : m);
    final double maxY = maxBooking == 0 ? 10 : maxBooking * 1.2;

    return Container(
      height: 280,
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xff0F172A), Color(0xff020617)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(text: "Bookings Trend", fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.white),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(20)),
                child: CustomText(text: "This Year", fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: LineChart(
              LineChartData(
                maxY: maxY,
                minY: 0,
                lineBarsData: [
                  LineChartBarData(
                    spots: trend.asMap().entries.map((e) => FlSpot(e.key.toDouble(), (e.value.bookings ?? 0).toDouble())).toList(),
                    isCurved: false,
                    color: Colors.blue,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: true, getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(radius: 4, color: Colors.blue, strokeWidth: 2, strokeColor: Colors.white)),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                           padding: const EdgeInsets.only(right: 8),
                           child: Text(
                             value.toStringAsFixed(0),
                             style: const TextStyle(color: Colors.grey, fontSize: 10),
                             textAlign: TextAlign.right,
                           ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < 0 || value.toInt() >= trend.length) return const SizedBox();
                        String month = trend[value.toInt()].month ?? "";
                        if (month.length > 3) month = month.substring(0, 3);
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(month, style: const TextStyle(color: Colors.grey, fontSize: 10)),
                        );
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= Recent Activity =================
  Widget _buildRecentActivity(dynamic booking) {
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: booking.venue?.venueName ?? "Unknown Venue",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                CustomText(
                  text: "${booking.timeSlot?.from ?? ''} - ${booking.timeSlot?.to ?? ''}",
                  fontSize: 14,
                  color: AppColors.textClr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                CustomText(
                  text: booking.user?.fullName ?? "Unknown User",
                  fontSize: 14,
                  color: AppColors.textClr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: booking.bookingStatus == "PENDING"  ? AppColors.green2.withOpacity(0.2) : booking.bookingStatus == "CONFIRMED" ? AppColors.blue.withOpacity(0.2) : booking.bookingStatus == "CANCELLED" ? AppColors.red.withOpacity(0.2)   : Colors.deepOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: CustomText(
              text: booking.bookingStatus ?? "N/A",
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: booking.bookingStatus == "PENDING"  ? AppColors.green2: booking.bookingStatus == "CONFIRMED" ? AppColors.blue: booking.bookingStatus == "CANCELLED" ? AppColors.red: Colors.deepOrange,
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
