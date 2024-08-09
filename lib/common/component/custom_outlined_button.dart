import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gooturk/common/const/color.dart';
import 'package:gooturk/common/style/default_font_style.dart';

class CustomOutlinedButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final bool isSelected;
  const CustomOutlinedButton({
    required this.text,
    required this.onPressed,
    required this.isSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        ),
        backgroundColor: MaterialStateProperty.all(
          isSelected ? PRIMARY_YELLOW : Colors.white,
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
            side: BorderSide(
              width: 0.5,
            ),
          ),
        ),
      ),
      child: Text(
        text,
        style: defaultFontStyleBlack.copyWith(
          fontSize: 14.0.sp,
          fontWeight: FontWeight.w500,
          height: 1.0,
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
