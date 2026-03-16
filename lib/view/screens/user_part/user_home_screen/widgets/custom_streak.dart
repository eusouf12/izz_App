import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StreakTrackerCard extends StatelessWidget {
  final int streakDays;
  final int totalDays;

  const StreakTrackerCard({
    super.key,
    this.streakDays = 4,
    this.totalDays = 7,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 116.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Streak Tracker",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.local_fire_department,
                    color: Colors.orange,
                    size: 16.sp,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    "$streakDays Days",
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 16.h),

          /// ✅ Fixed Progress Row (No Overflow)
          LayoutBuilder(
            builder: (context, constraints) {
              // distribute total width evenly among bars
              final availableWidth = constraints.maxWidth;
              final barSpacing = 6.w;
              final totalSpacing = barSpacing * (totalDays - 1);
              final barWidth = (availableWidth - totalSpacing) / totalDays;

              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(totalDays, (index) {
                  bool isActive = index < streakDays;
                  return Padding(
                    padding: EdgeInsets.only(right: index == totalDays - 1 ? 0 : barSpacing),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 8.h,
                      width: barWidth,
                      decoration: BoxDecoration(
                        color: isActive
                            ? const Color(0xFF22C55E)
                            : const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  );
                }),
              );
            },
          ),

          SizedBox(height: 14.h),

          Text(
            "Keep your streak alive for bonus XP!",
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}