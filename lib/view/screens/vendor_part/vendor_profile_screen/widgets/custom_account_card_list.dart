import 'package:flutter/material.dart';
import 'package:izz_atlas_app/utils/app_colors/app_colors.dart';
import '../../../../components/custom_text/custom_text.dart';

class CustomAccountCardList extends StatelessWidget {
  final String? name;
  final Function()? onTap;
  const CustomAccountCardList({super.key, this.name, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 14.0),
        child: Card(
          elevation: 0,
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: name ?? "text",
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: AppColors.black_02,
              ),
              Icon(Icons.arrow_forward_ios_outlined, size: 15,color: AppColors.black_02,),
            ],
          ),
        ),
      ),
    );
  }
}
