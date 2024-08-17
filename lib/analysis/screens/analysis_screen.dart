import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
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

  double progress = 0;
  double loadingStackSize = 135;
  double playbackSpeed = 1.0;
  Color loadingBarColor = Color.fromRGBO(22, 22, 22, 0.643);
  Duration currentDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    model =
        ref.read(videoListProvider.notifier).getVideoByName(widget.videoName);
    _controller = VideoPlayerController.file(File(model.videoUri))
      ..initialize().then((_) {
        _controller.setPlaybackSpeed(playbackSpeed);
        _controller.play();
        _controller.setLooping(false);
        setState(() {});
      });

    _controller.addListener(() async {
      int max = _controller.value.duration.inMilliseconds;
      setState(() {
        currentDuration = _controller.value.position;
        progress = (currentDuration.inMilliseconds / max * 100).isNaN
            ? 0
            : (currentDuration.inMilliseconds / max) * 100;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Stack loadingStack() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 135,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: loadingBarColor,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: backwardButton(),
                ),
                Spacer(flex: 1),
                Expanded(
                  flex: 1,
                  child: playingButton(),
                ),
                Spacer(flex: 1),
                Expanded(
                  flex: 1,
                  child: forwardButton(),
                ),
              ],
            ),
            SizedBox(
              height: loadingStackSize * 0.15,
            ),
            loadingBar(),
            Padding(padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0)),
          ],
        ),
      ],
    );
  }

  Column loadingBar() {
    return Column(
      children: [
        Stack(
          children: [
            Padding(padding: const EdgeInsets.only(bottom: 10.0)),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 6,
              width: (MediaQuery.of(context).size.width) * 0.80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width:
                  (MediaQuery.of(context).size.width) * 0.80 * (progress / 100),
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: const Color.fromRGBO(215, 215, 215, 1),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 28.0),
              child: Text(
                currentDuration.toString().split('.')[0].substring(2),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 28.0),
              child: Text(
                _controller.value.duration
                    .toString()
                    .split('.')[0]
                    .substring(2),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  RawMaterialButton backwardButton() {
    return RawMaterialButton(
      elevation: 0.0,
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onPressed: () {
        setState(() {
          _controller.seekTo(
            Duration(seconds: currentDuration.inSeconds - 3),
          );
        });
      },
      padding: EdgeInsets.fromLTRB(40.0, 16.0, 16.0, 16.0),
      child:
          Icon(size: 25.0, CupertinoIcons.backward_fill, color: Colors.white),
    );
  }

  RawMaterialButton forwardButton() {
    return RawMaterialButton(
      elevation: 0.0,
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onPressed: () {
        setState(() {
          _controller.seekTo(
            Duration(seconds: currentDuration.inSeconds + 3),
          );
        });
      },
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 40.0, 16.0),
      child: Icon(size: 25.0, CupertinoIcons.forward_fill, color: Colors.white),
    );
  }

  RawMaterialButton playingButton() {
    return RawMaterialButton(
      constraints: BoxConstraints.tightFor(
        width: 150.0,
        height: 50.0,
      ),
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onPressed: () {
        setState(() {
          _controller.value.isPlaying
              ? _controller.pause()
              : _controller.play();
        });
      },
      child: Icon(
        color: Colors.white,
        size: 53.0,
        _controller.value.isPlaying
            ? CupertinoIcons.pause_solid
            : CupertinoIcons.play_arrow_solid,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Stack(
          children: [
            _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : Container(),
            Positioned(
              bottom: 16.0,
              left: 10,
              right: 10,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: loadingStackSize,
                child: loadingStack(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
