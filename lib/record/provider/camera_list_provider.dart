import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cameraListProvider =
    StateNotifierProvider<CameraListProvider, List<CameraDescription>>((ref) {
  return CameraListProvider();
});

class CameraListProvider extends StateNotifier<List<CameraDescription>> {
  CameraListProvider() : super([]);

  Future<List<CameraDescription>> fetch() async {
    final cameras = await availableCameras();
    state = cameras;
    return cameras;
  }

  initalize(List<CameraDescription> cameras) {
    state = cameras;
  }
}
