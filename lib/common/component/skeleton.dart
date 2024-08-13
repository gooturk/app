import 'package:flutter/material.dart';
import 'package:gooturk/common/const/color.dart';
import 'package:shimmer/shimmer.dart';

class Skeleton extends StatelessWidget {
  final double height;
  final double width;
  const Skeleton({
    super.key,
    this.height = 100,
    this.width = 100,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Shimmer.fromColors(
        baseColor: GRAY_1,
        highlightColor: GRAY_2,
        child: Container(
          decoration: BoxDecoration(
            color: GRAY_1,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
