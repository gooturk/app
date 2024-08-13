import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gooturk/hisotry/model/video_model.dart';
import 'package:gooturk/hisotry/provider/video_provider.dart';

final lastestVideoProvider =
    StateNotifierProvider<LastestVideoStateNotifier, VideoModel?>((ref) {
  return LastestVideoStateNotifier(
    onVideoRecorded: ref.read(videoListProvider.notifier).appendleftVideo,
  );
});

class LastestVideoStateNotifier extends StateNotifier<VideoModel?> {
  final Function(VideoModel) onVideoRecorded;
  LastestVideoStateNotifier({required this.onVideoRecorded}) : super(null);

  void setPath(String path) {
    state = VideoModel.fromFilePath(path);
    onVideoRecorded(state!);
  }
}
