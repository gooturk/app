import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gooturk/common/component/custom_button.dart';
import 'package:gooturk/common/model/custom_dialog_model.dart';
import 'package:gooturk/common/style/default_font_style.dart';

class CustomDialog extends ConsumerWidget {
  static String get routerName => '/custom_dialog';
  final String title;
  final String description;
  final Widget child;
  const CustomDialog({
    required this.title,
    required this.description,
    required this.child,
    super.key,
  });

  factory CustomDialog.fromModel(CustomDialogModel model) {
    if (model is CustomDialogWithTwoButtonsModel) {
      return CustomDialog(
        title: model.title,
        description: model.description,
        child: Row(
          children: [
            Expanded(
              child: CustomButton.fromModel(model: model.customButtonModel),
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: CustomButton.fromModel(
                model: model.customButtonModelSecond,
              ),
            ),
          ],
        ),
      );
    }
    return CustomDialog(
      title: model.title,
      description: model.description,
      child: CustomButton.fromModel(model: model.customButtonModel),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 20.h,
            ),
            Text(
              title,
              style: defaultFontStyleBlack.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              description,
              textAlign: TextAlign.center,
              style: defaultFontStyleBlack.copyWith(
                overflow: TextOverflow.clip,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 28.h),
            child,
          ],
        ),
      ),
    );
  }
}

Function() showCustomDialog({
  required BuildContext context,
  required CustomDialogModel model,
}) {
  return () => showDialog(
        context: context,
        builder: (context) => CustomDialog.fromModel(
          model,
        ),
      );
}
