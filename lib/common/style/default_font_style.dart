import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final defaultFontStyleBlack = TextStyle(
  color: Colors.black,
  fontSize: 16.sp,
  fontWeight: FontWeight.w500,
  height: 1.5,
  fontFamily: 'Pretendard',
  overflow: TextOverflow.ellipsis,
);

final defaultFontStyleWhite = defaultFontStyleBlack.copyWith(
  color: Colors.white,
);
