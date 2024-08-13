import 'dart:typed_data';

import 'package:video_thumbnail/video_thumbnail.dart';

class VideoThumbnailModel {
  final String videoId;
  final Future<Uint8List?> thumbnailData;

  VideoThumbnailModel({required this.videoId, required this.thumbnailData});

  factory VideoThumbnailModel.fromVideoPath(String videoPath) {
    final bytes = VideoThumbnail.thumbnailData(
      video: videoPath,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 0,
      quality: 25,
    );

    return VideoThumbnailModel(
      videoId: videoPath,
      thumbnailData: bytes,
    );
  }
}
