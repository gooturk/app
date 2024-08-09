import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gooturk/common/const/color.dart';
import 'package:gooturk/common/const/data.dart';
import 'package:gooturk/common/provider/go_router_provider.dart';
import 'package:gooturk/common/style/default_font_style.dart';
import 'package:skeletons/skeletons.dart';

class DefaultCardLayout extends StatelessWidget {
  final String id;
  final String name;
  final String? imgUrl;
  final Widget child;
  final Color borderColor;
  final bool isShadowVisible;
  final VoidCallback? onTap;
  final String? routerPath;
  final bool isDisabled;
  const DefaultCardLayout({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.child,
    this.borderColor = PRIMARY_ORANGE,
    this.isShadowVisible = false,
    this.onTap,
    this.routerPath,
    this.isDisabled = false,
    super.key,
  });

  factory DefaultCardLayout.loading() {
    return DefaultCardLayout(
      id: 'loading',
      name: 'loading',
      imgUrl: null,
      borderColor: Colors.transparent,
      isShadowVisible: true,
      child: buildSkeleton(),
    );
  }

  factory DefaultCardLayout.basic() {
    return DefaultCardLayout(
      id: 'basic',
      name: 'basic',
      imgUrl: null,
      borderColor: Colors.transparent,
      isShadowVisible: true,
      child: buildBasic(),
    );
  }

  copyWith({
    String? id,
    String? name,
    String? imgUrl,
    Widget? child,
    Color? borderColor,
    bool? isShadowVisible,
    VoidCallback? onTap,
    String? routerPath,
    bool? isDisabled,
  }) {
    return DefaultCardLayout(
      id: id ?? this.id,
      name: name ?? this.name,
      imgUrl: imgUrl ?? this.imgUrl,
      borderColor: borderColor ?? this.borderColor,
      isShadowVisible: isShadowVisible ?? this.isShadowVisible,
      onTap: onTap ?? this.onTap,
      routerPath: routerPath ?? this.routerPath,
      isDisabled: isDisabled ?? this.isDisabled,
      child: child ?? this.child,
    );
  }

  @override
  Widget build(BuildContext context) {
    late final Function() onTap;
    if (routerPath == null) {
      onTap = this.onTap ?? () => {};
    } else {
      onTap = () => {context.push(routerPath!)};
    }
    return Center(
      child: GestureDetector(
        onTap: this.onTap ?? onTap,
        child: Padding(
          padding: EdgeInsets.only(top: 8.h),
          child: Container(
            padding: EdgeInsets.all(16.w),
            width: 335.w,
            foregroundDecoration: isDisabled
                ? BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    backgroundBlendMode: BlendMode.saturation,
                  )
                : null,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1.w, color: borderColor),
                borderRadius: BorderRadius.circular(8),
              ),
              color: Colors.white,
              shadows: [
                if (isShadowVisible)
                  const BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 10,
                    offset: Offset(3, 3),
                    spreadRadius: 0,
                  ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(imgUrl != null ? 8 : 20),
                  child: Image.network(
                    imgUrl ?? defaultImg,
                    width: 84.w,
                    height: 84.w,
                    fit: BoxFit.cover,
                    frameBuilder:
                        (context, child, frame, wasSynchronouslyLoaded) {
                      return Skeleton(
                        isLoading: frame == null,
                        skeleton: SkeletonAvatar(
                          style: SkeletonAvatarStyle(
                            width: 84.w,
                            height: 84.w,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: child,
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: 16.w,
                ),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildCafeInfo() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        '12123',
        style: defaultFontStyleBlack.copyWith(
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
          height: 1.5,
        ),
      ),
      Text(
        '서울시 강남구 역삼동',
        style: defaultFontStyleBlack.copyWith(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: TEXT_SUBTITLE_COLOR,
        ),
      ),
    ],
  );
}

Widget buildSkeleton() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SkeletonLine(
        style: SkeletonLineStyle(
          height: 16.h,
          width: 200.w,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      SizedBox(
        height: 8.h,
      ),
      SkeletonLine(
        style: SkeletonLineStyle(
          height: 16.h,
          width: 100.w,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      SizedBox(
        height: 12.h,
      ),
      SkeletonLine(
        style: SkeletonLineStyle(
          height: 24.h,
          width: 100.w,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ],
  );
}

Widget buildBasic() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        '다가오는 예약이 없어요 :(',
        style: defaultFontStyleBlack.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      SizedBox(
        height: 16.h,
      ),
      FilledButton(
        onPressed: () {
          rootNavigatorKey.currentContext!.push('/search');
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            PRIMARY_YELLOW,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: 6.h,
          ),
          child: Text(
            '예약하러 가기!',
            style: defaultFontStyleWhite,
          ),
        ),
      ),
    ],
  );
}
