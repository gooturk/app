import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gooturk/hisotry/model/video_model.dart';
import 'package:gooturk/hisotry/repository/video_repository.dart';

final videoListProvider =
    StateNotifierProvider<VideoListStateNotifier, List<VideoModel>>(
  (ref) {
    final repository = ref.read(videoListRepositoryProvider);
    return VideoListStateNotifier(repository: repository);
  },
);

class VideoListStateNotifier extends StateNotifier<List<VideoModel>> {
  final VideoListRepository repository;
  VideoListStateNotifier({required this.repository}) : super([]) {
    getVideos();
  }

  appendleftVideo(VideoModel video) {
    state = [video, ...state];
    updateVideoDuration(video, true);
  }

  void getVideos() {
    state = repository.getVideosSync().map((e) {
      return VideoModel.fromFileEntity(e);
    }).toList();
    state.map((e) => updateVideoDuration(e, e == state.last)).toList();
  }

  getVideoByName(String name) {
    return state.firstWhere((element) => element.videoName == name);
  }

  updateVideoDuration(VideoModel video, bool? isLast) async {
    final video2 = await video.updateDuration();
    replace(video, video2);
    if (isLast == true) {
      sortVideos(isAscending: false);
    }
  }

  replace(VideoModel video1, VideoModel video2) {
    final index = state.indexOf(video1);
    state[index] = video2;
  }

  sortVideos({bool isAscending = true}) {
    state = [...state]..sort(
        (a, b) => isAscending
            ? a.createdAt.compareTo(b.createdAt)
            : b.createdAt.compareTo(a.createdAt),
      );
  }

  deleteVideo(VideoModel video) {
    repository.deleteVideo(video.file);
    state = state.where((element) => element != video).toList();
  }
}
