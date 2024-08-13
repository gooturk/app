import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gooturk/record/provider/camera_list_provider.dart';
import 'package:gooturk/record/provider/lastest_video_provider.dart';
import 'package:gooturk/record/provider/record_status_provider.dart';

class RecordScreen extends ConsumerWidget {
  static String get routerName => '/record';
  const RecordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CameraScreen();
  }
}

class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen>
    with WidgetsBindingObserver {
  CameraController? controller;
  late List<CameraDescription> _cameras;
  bool enableAudio = true;
  bool isControllerDisposed = false;
  bool isPreviewing = false;
  String videoPath = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _cameras = ref.read(cameraListProvider);
    _initializeCameraController(_cameras[0]);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      print('return');
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
      isControllerDisposed = true;
      print('dispose');
    } else if (state == AppLifecycleState.resumed && mounted) {
      _initializeCameraController(cameraController.description);
      isControllerDisposed = false;
      print('resume');
    }
  }

  Future<void> _initializeCameraController(
    CameraDescription cameraDescription,
  ) async {
    final CameraController cameraController = CameraController(
      cameraDescription,
      // kIsWeb ? ResolutionPreset.max : ResolutionPreset.medium,
      ResolutionPreset.high,
      // enableAudio: enableAudio,
      // imageFormatGroup: ImageFormatGroup.jpeg,
    );

    controller = cameraController;

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (cameraController.value.hasError) {
        print('Camera error ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      print('Camera error ${e.description}');
    }
  }

  Future<void> startVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (cameraController.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return;
    }

    try {
      await cameraController.startVideoRecording();
      ref.read(recordStatusProvider.notifier).state = true;
    } on CameraException catch (e) {
      print('Camera error ${e.description}');
      return;
    }
  }

  Future<void> stopVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return;
    }

    try {
      final file = await cameraController.stopVideoRecording();
      ref.read(recordStatusProvider.notifier).state = false;
      ref.read(lastestVideoProvider.notifier).setPath(file.path);
    } on CameraException catch (e) {
      print('Camera error ${e.description}');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)?.isCurrent != true) {
      controller?.pausePreview();
    } else {
      controller?.resumePreview();
    }

    isPreviewing = true;
    if (controller == null ||
        !controller!.value.isInitialized ||
        isControllerDisposed) {
      isPreviewing = false;
    }

    return Container(
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Center(
              child: ModalRoute.of(context)?.isCurrent == true && isPreviewing
                  ? CameraPreview(controller!)
                  : AspectRatio(
                      aspectRatio: 3 / 4,
                      child: Container(
                        color: Colors.black,
                      ),
                    ),
            ),
          ),
          Column(
            children: [
              _buildRecordingButton(),
              SizedBox(height: 40.h),
            ],
          ),
        ],
      ),
    );
  }

  GestureDetector _buildRecordingButton() {
    final isRecording = ref.watch(recordStatusProvider);
    return GestureDetector(
      onTap: () {
        if (isRecording) {
          stopVideoRecording();
        } else {
          startVideoRecording();
        }
      },
      child: Center(
        child: AnimatedCrossFade(
          firstChild: _buildStartButton(),
          secondChild: _buildStopButton(),
          crossFadeState: isRecording
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 150),
          sizeCurve: Curves.easeInOut,
        ),
      ),
    );
  }

  Stack _buildStopButton() {
    return Stack(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        Positioned(
          top: 8,
          left: 8,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(50),
            ),
          ),
        ),
        Positioned(
          top: 16,
          left: 16,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
      ],
    );
  }

  Container _buildStartButton() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }
}
