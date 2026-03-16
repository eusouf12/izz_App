import 'package:flutter/material.dart';

import '../../../utils/app_colors/app_colors.dart';
import '../custom_text/custom_text.dart';

class CustomRowContainer extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final Color selectedColor;
  //final Color unselectedColor;
  final Color? textColor;
  final bool? isTextColorActive;
  final bool? isPadding;


  const CustomRowContainer({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.selectedColor,
    //required this.unselectedColor,
    this.textColor,
    this.isTextColorActive = false,
    this.isPadding = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        /*border: Border(
          bottom: BorderSide(
            width: 0,
            color: unselectedColor,
          ),
        ),*/
      ),
      padding: isPadding!
          ? const EdgeInsets.only(left: 6,right: 6,bottom: 8)
          : const EdgeInsets.symmetric(horizontal: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(tabs.length, (index) {
          return GestureDetector(
            onTap: () => onTabSelected(index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: selectedIndex == index ? selectedColor : AppColors.white,
                /*      border: Border(
                  bottom: BorderSide(
                    color: selectedIndex == index
                        ? selectedColor
                        : Colors.transparent,
                    width: 2.0,
                  ),
                ),*/
              ),
              child: CustomText(
                  text: tabs[index],
                  color: selectedIndex == index ? AppColors.white
                      : AppColors.black_80,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
          );
        }),
      ),
    );
  }
}
