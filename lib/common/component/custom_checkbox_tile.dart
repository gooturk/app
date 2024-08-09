import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gooturk/common/const/color.dart';
import 'package:gooturk/common/icons/gooturk_icon_pack_icons.dart';
import 'package:gooturk/common/style/default_font_style.dart';

class CustomCheckboxTile extends StatelessWidget {
  final bool isChecked;
  final String title;
  final String url;
  final Function(bool?) onChanged;
  const CustomCheckboxTile({
    super.key,
    required this.isChecked,
    required this.title,
    required this.url,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 18.w,
          height: 18.w,
          child: Checkbox(
            value: isChecked,
            onChanged: onChanged,
            activeColor: PRIMARY_ORANGE,
          ),
        ),
        SizedBox(
          width: 8.w,
        ),
        TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            alignment: Alignment.center,
          ),
          onPressed: () => onChanged(!isChecked),
          child: Text(
            title,
            style: defaultFontStyleBlack.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              height: 1.0,
            ),
          ),
        ),
        IconButton(
          alignment: Alignment.centerLeft,
          icon: Icon(
            GooturkIconPack.arrow_right,
            size: 24.sp,
            color: PRIMARY_ORANGE,
          ),
          onPressed: () async {
            // Uri url = Uri.parse(this.url);
            // if (!await launchUrl(url)) {
            //   throw Exception('Could not launch $url');
            // }
          },
        ),
      ],
    );
  }
}
