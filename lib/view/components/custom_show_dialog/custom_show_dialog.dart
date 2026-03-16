/*
// ignore_for_file: sort_child_properties_last

import 'package:counta_flutter_app/utils/app_colors/app_colors.dart';
import 'package:counta_flutter_app/view/components/custom_button/custom_button.dart';
import 'package:counta_flutter_app/view/components/custom_text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomShowDialog extends StatefulWidget {
  final String? title;
  final String? discription;
  final String? leftTextButton;
  final String? rightTextButton;
  final Function()? leftOnTap;
  final Function()? rightOnTap;
  final bool? showRowButton;
  final bool? showColumnButton;
  final bool? showCloseButton;
  final Color? textColor;
  const CustomShowDialog(
      {super.key,
      required this.title,
      required this.discription,
      this.leftOnTap,
      this.rightOnTap,
      this.leftTextButton,
      this.rightTextButton,
      this.showRowButton = false,
      this.showColumnButton = false,
      this.textColor = Colors.black, this.showCloseButton = false});

  @override
  State<CustomShowDialog> createState() => _CustomShowDialogState();
}

class _CustomShowDialogState extends State<CustomShowDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        //color: AppColors.green,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          model.showCloseButton== true ? Padding(
            padding: EdgeInsets.only(right: 10.0, top: 0.h),
            child: Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(), child: Icon(Icons.close, color: model.textColor?? AppColors.black,))),
          ): SizedBox(),
          CustomText(
            text: "${model.title}",
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: model.textColor ?? AppColors.black_80,
            bottom: 12.h,
          ),
          CustomText(
            text: "${model.discription}",
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: model.textColor ?? AppColors.black_80,
            bottom: 18.h,
          ),
          model.showRowButton == true
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      Flexible(
                        child: CustomButton(
                          onTap: model.leftOnTap ??
                              () => Navigator.of(context).pop(),
                          title: model.leftTextButton ?? "Yes",
                          height: 50.h,
                         textColor: model.textColor ?? AppColors.black_80,
                         // fillColor:  model.textColor ?? AppColors.black_80,
                        ),
                      ),
                      SizedBox(
                        width: 12.w,
                      ),
                      Flexible(
                        child: CustomButton(
                          onTap: model.rightOnTap ??
                              () => Navigator.of(context).pop(),
                          title: model.rightTextButton ?? "No",
                          height: 50.h,
                          fillColor: AppColors.white,
                          textColor: AppColors.primary,
                          isBorder: true,
                          borderWidth: 1,
                        ),
                      )
                    ],
                  ),
                )
              : SizedBox(),
          model.showColumnButton == true
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      CustomButton(
                        onTap: model.leftOnTap ??
                            () => Navigator.of(context).pop(),
                        title: model.leftTextButton ?? "Yes",
                        height: 45.h,
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      CustomButton(
                        onTap: model.rightOnTap ??
                            () => Navigator.of(context).pop(),
                        title: model.rightTextButton ?? "No",
                        height: 45.h,
                        fillColor: AppColors.white,
                        textColor: AppColors.primary,
                        isBorder: true,
                        borderWidth: 1,
                      )
                    ],
                  ),
                )
              : SizedBox(),
        ],
      ),
      padding: EdgeInsets.only(bottom: 10.0, top: 10.h),
    );
  }
}
*/
