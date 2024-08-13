import 'dart:io';

import 'package:gooturk/hisotry/model/video_thumbnail_model.dart';
import 'package:video_player/video_player.dart';

class VideoModel {
  final String id;
  final String videoUri;
  final VideoThumbnailModel videoThumbnail;
  final String videoName;
  final Duration videoDuration;
  final int videoSize;
  final DateTime createdAt;

  VideoModel({
    required this.id,
    required this.videoUri,
    required this.videoThumbnail,
    required this.videoName,
    required this.videoDuration,
    required this.videoSize,
    required this.createdAt,
  });

  factory VideoModel.fromFileEntity(FileSystemEntity entity) {
    return VideoModel(
      id: entity.path,
      videoUri: entity.path,
      videoThumbnail: VideoThumbnailModel.fromVideoPath(entity.path),
      videoName: entity.path.split('/').last,
      videoDuration: Duration.zero,
      videoSize: entity.statSync().size,
      createdAt: entity.statSync().modified,
    );
  }

  factory VideoModel.fromFilePath(String path) {
    return VideoModel(
      id: path,
      videoUri: path,
      videoThumbnail: VideoThumbnailModel.fromVideoPath(path),
      videoName: path.split('/').last,
      videoDuration: Duration.zero,
      videoSize: File(path).statSync().size,
      createdAt: File(path).statSync().modified,
    );
  }

  readVideoBytes() {
    return File(videoUri).readAsBytesSync();
  }

  Future<VideoModel> updateDuration() async {
    final video = File(videoUri);
    final controller = VideoPlayerController.file(video);
    try {
      await controller.initialize();
    } catch (e) {
      print(e);
      return this;
    }
    return copyWith(videoDuration: controller.value.duration);
  }

  get file => File(videoUri);

  copyWith({
    String? id,
    String? videoUri,
    VideoThumbnailModel? videoThumbnail,
    String? videoName,
    Duration? videoDuration,
    int? videoSize,
    DateTime? createdAt,
  }) {
    return VideoModel(
      id: id ?? this.id,
      videoUri: videoUri ?? this.videoUri,
      videoThumbnail: videoThumbnail ?? this.videoThumbnail,
      videoName: videoName ?? this.videoName,
      videoDuration: videoDuration ?? this.videoDuration,
      videoSize: videoSize ?? this.videoSize,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
