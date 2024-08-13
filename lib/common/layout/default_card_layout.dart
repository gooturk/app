import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gooturk/common/component/skeleton.dart';
import 'package:gooturk/common/const/color.dart';
import 'package:gooturk/common/const/data.dart';
import 'package:gooturk/common/style/default_font_style.dart';
import 'package:gooturk/common/utils/utils.dart';
import 'package:gooturk/hisotry/model/video_model.dart';
import 'package:gooturk/hisotry/provider/video_provider.dart';

class DefaultCardLayout extends StatelessWidget {
  final String id;
  final String name;
  final String? imgUrl;
  final Widget? thumbnail;
  final Widget child;
  final Color borderColor;
  final bool isShadowVisible;
  final VoidCallback? onTap;
  final String? routerPath;
  final bool isDisabled;
  const DefaultCardLayout({
    required this.id,
    required this.name,
    required this.child,
    this.thumbnail,
    this.imgUrl,
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

  factory DefaultCardLayout.fromVideoModel(VideoModel videoModel) {
    return DefaultCardLayout(
      id: videoModel.id,
      name: videoModel.videoName,
      borderColor: Colors.transparent,
      isShadowVisible: true,
      routerPath: '/analysis/${videoModel.videoName}',
      thumbnail: FutureBuilder(
        future: videoModel.videoThumbnail.thumbnailData,
        builder: (context, snapshot) {
          final data = snapshot.data;
          if (snapshot.hasData && data != null) {
            return Container(
              width: 84.w,
              height: 84.w,
              color: Colors.black,
              child: Image.memory(
                width: 84.w,
                height: 84.w,
                data,
                frameBuilder: ((context, child, frame, wasSynchronouslyLoaded) {
                  if (wasSynchronouslyLoaded) return child;
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: frame != null
                        ? child
                        : SizedBox(
                            height: 84.w,
                            width: 84.w,
                            child: Skeleton(
                              width: 84.w,
                              height: 84.w,
                            ),
                          ),
                  );
                }),
              ),
            );
          }
          return Skeleton(
            width: 84.w,
            height: 84.w,
          );
        },
      ),
      child: SizedBox(
        width: 200.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              videoModel.videoName,
              style: defaultFontStyleBlack.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                height: 1.5,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              Utils.getYYYYMMDDHHMMfromDateTimeWithKorean(
                videoModel.createdAt,
                showHHMM: true,
              ),
              style: defaultFontStyleBlack.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: TEXT_SUBTITLE_COLOR,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getHHMMSSAmountfromDuration(
                        videoModel.videoDuration,
                      ),
                      style: defaultFontStyleBlack.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: TEXT_SUBTITLE_COLOR,
                      ),
                    ),
                    Text(
                      Utils.getFileSizeString(videoModel.videoSize),
                      style: defaultFontStyleBlack.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: TEXT_SUBTITLE_COLOR,
                      ),
                    ),
                  ],
                ),
                DeleteButton(
                  model: videoModel,
                ),
              ],
            ),
          ],
        ),
      ),
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
    return GestureDetector(
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
                child: thumbnail ??
                    Image.network(
                      imgUrl ?? defaultImg,
                      width: 84.w,
                      height: 84.w,
                      fit: BoxFit.cover,
                      frameBuilder:
                          (context, child, frame, wasSynchronouslyLoaded) {
                        return child;
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
    );
  }
}

Widget buildSkeleton() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Skeleton(
        height: 16.h,
        width: 200.w,
      ),
      SizedBox(
        height: 8.h,
      ),
      Skeleton(
        height: 16.h,
        width: 100.w,
      ),
    ],
  );
}

class DeleteButton extends ConsumerWidget {
  final VideoModel model;
  const DeleteButton({super.key, required this.model});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () {
        ref.read(videoListProvider.notifier).deleteVideo(model);
      },
      icon: Icon(
        Icons.delete,
        color: Colors.red,
      ),
    );
  }
}
