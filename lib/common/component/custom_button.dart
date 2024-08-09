import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gooturk/common/const/color.dart';
import 'package:gooturk/common/model/custom_button_model.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final bool isDisabled;
  final bool isDismiss;
  final Function()? onPressed;
  const CustomButton({
    required this.text,
    this.onPressed,
    this.isDisabled = false,
    this.isDismiss = false,
    Key? key,
  }) : super(key: key);

  factory CustomButton.fromModel({
    required CustomButtonModel model,
  }) {
    return CustomButton(
      text: model.title,
      onPressed: model.onPressed,
      isDisabled: model.isDisabled ?? false,
      isDismiss: model.isDismiss ?? false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isDisabled
          ? null
          : onPressed ??
              () {
                Navigator.pop(context);
              },
      style: ElevatedButton.styleFrom(
        backgroundColor: isDisabled == true
            ? GRAY_2
            : isDismiss
                ? GRAY_2
                : PRIMARY_YELLOW,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.r),
        ),
        fixedSize: Size(
          335.w,
          56.h,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: TEXTFIELD_INNER,
          fontSize: 16.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
