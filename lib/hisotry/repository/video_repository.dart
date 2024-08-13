import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gooturk/common/provider/path_provider.dart';

final videoListRepositoryProvider = Provider<VideoListRepository>(
  (ref) {
    final pathString = ref.read(pathProvider).path;
    return VideoListRepository(path: pathString);
  },
);

class VideoListRepository {
  final Directory videos;
  VideoListRepository({required String path}) : videos = Directory(path) {
    if (!videos.existsSync()) {
      videos.createSync(recursive: true);
    }
  }

  Stream<FileSystemEntity> getVideos() {
    return videos.list();
  }

  List<FileSystemEntity> getVideosSync() {
    return videos.listSync();
  }

  void deleteVideo(FileSystemEntity video) {
    video.deleteSync();
  }
}
