import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gooturk/common/layout/default_card_layout.dart';
import 'package:gooturk/common/style/default_font_style.dart';
import 'package:gooturk/hisotry/provider/video_provider.dart';

class HistoryScreen extends ConsumerWidget {
  static String get routerName => '/history';
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videos = ref.watch(videoListProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: 365.w,
        child: videos.isEmpty
            ? Center(
                child: Text(
                  '촬영된 영상이 없어요 :(',
                  style: defaultFontStyleBlack.copyWith(fontSize: 14.sp),
                ),
              )
            : ListView.separated(
                itemCount: videos.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final model = videos[index];
                  return DefaultCardLayout.fromVideoModel(model);
                },
              ),
      ),
    );
  }
}
