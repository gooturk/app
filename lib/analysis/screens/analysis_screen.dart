import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gooturk/hisotry/model/video_model.dart';
import 'package:gooturk/hisotry/provider/video_provider.dart';
import 'package:video_player/video_player.dart';

class AnalysisScreen extends ConsumerStatefulWidget {
  final String videoName;
  const AnalysisScreen({
    super.key,
    required this.videoName,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends ConsumerState<AnalysisScreen> {
  late VideoPlayerController _controller;
  late final VideoModel model;

  @override
  void initState() {
    super.initState();
    model =
        ref.read(videoListProvider.notifier).getVideoByName(widget.videoName);
    _controller = VideoPlayerController.file(File(model.videoUri))
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : Container();
  }
}
