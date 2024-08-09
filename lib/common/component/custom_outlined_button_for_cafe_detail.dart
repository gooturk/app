import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gooturk/common/const/color.dart';
import 'package:gooturk/common/style/default_font_style.dart';

class CustomOutlinedButtonForCafeDetail extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final bool isDisabled;
  const CustomOutlinedButtonForCafeDetail({
    required this.text,
    required this.onPressed,
    this.isDisabled = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        ),
        backgroundColor:
            MaterialStateProperty.all(isDisabled ? GRAY_2 : PRIMARY_ORANGE),
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
        style: defaultFontStyleWhite.copyWith(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          height: 1.0,
        ),
      ),
    );
  }
}
