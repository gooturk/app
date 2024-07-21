import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ultralytics_yolo/predict/detect/detected_object.dart';
import 'dart:io';

import 'package:ultralytics_yolo/predict/detect/object_detector.dart';
import 'package:ultralytics_yolo/yolo_model.dart';

class PlaygroundWidget extends StatefulWidget {
  const PlaygroundWidget({super.key});

  @override
  State<PlaygroundWidget> createState() => _PlaygroundWidgetState();
}

class _PlaygroundWidgetState extends State<PlaygroundWidget> {
  File? _image;
  ObjectDetector? detector;
  List<Map<String, dynamic>> detect_results = [];
  int? elpased_time;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<String> _copy(String assetPath) async {
    final path = '${(await getApplicationSupportDirectory()).path}/$assetPath';
    await Directory(dirname(path)).create(recursive: true);
    final file = File(path);
    if (!await file.exists()) {
      final byteData = await rootBundle.load(assetPath);
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    }
    return file.path;
  }

  Future<ObjectDetector> _initObjectDetectorWithLocalModel() async {
    final modelPath = await _copy('assets/yolov8n.mlmodel');
    final model = LocalYoloModel(
      id: 'yolov8n.mlmodel',
      task: Task.detect,
      format: Format.coreml,
      modelPath: modelPath,
    );

    return ObjectDetector(model: model);
  }

  void _loadModel() async {
    detector = await _initObjectDetectorWithLocalModel();
    detector!.loadModel(useGpu: true);
    setState(() {
      detector;
    });
  }

  void _inferenceModel() async {
    if (_image == null || detector == null) return;

    final start = DateTime.now();
    List<DetectedObject?>? res =
        await detector!.detect(imagePath: _image!.path);
    final end = DateTime.now();
    final elapsed = end.difference(start);
    if (res == null) return;

    elpased_time = elapsed.inMilliseconds;
    detect_results.clear();
    for (final detectedObject in res as List<DetectedObject>) {
      final left = detectedObject.boundingBox.left;
      final top = detectedObject.boundingBox.top;
      final right = detectedObject.boundingBox.right;
      final bottom = detectedObject.boundingBox.bottom;
      final width = detectedObject.boundingBox.width;
      final height = detectedObject.boundingBox.height;
      final conf = (detectedObject.confidence * 100).toStringAsFixed(1);
      final label = detectedObject.label;
      detect_results.add({
        "left": left,
        "right": right,
        "top": top,
        "bottom": bottom,
        "width": width,
        "height": height,
        "conf": conf,
        "label": label
      });
    }
    setState(() {
      detect_results;
    });
  }

  Widget buildResultDetailTile(context, int idx, String opt) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;

    return Container(
      height: height * 0.03,
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Row(
          children: [
            SizedBox(
              width: 60,
              child: Text(
                opt,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ),
            Text(
              '${detect_results[idx][opt]}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Object Detector'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Pick Image'),
              ),
              const SizedBox(height: 20),
              _image != null
                  ? Image.file(
                      _image!,
                      height: 200,
                      width: 200,
                    )
                  : const Text('No image selected'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loadModel,
                child: const Text('Load model'),
              ),
              const SizedBox(
                height: 20,
              ),
              detector != null
                  ? Text('Model : ${detector!.model.id}')
                  : const Text('Model not loaded'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  print("Model : $detector");
                },
                child: const Text('Debug'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _inferenceModel();
                },
                child: const Text('Run'),
              ),
              const SizedBox(height: 20),
              elpased_time != null
                  ? Text(
                      "Inference time: $elpased_time ms\n #${detect_results.length} Found",
                      style: const TextStyle(fontSize: 15),
                    )
                  : Text("Pick img & Run for results"),
              SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: detect_results.length,
                  itemBuilder: (context, idx) {
                    final result = detect_results[idx];
                    return ExpansionTile(
                      title: Text('${result["label"]}'),
                      subtitle: Text('Confidence: ${result["conf"]}%'),
                      initiallyExpanded: false,
                      // trailing: Text(
                      //     'LTRB: ${detect_results[idx]["left"]}/${detect_results[idx]["top"]}/${detect_results[idx]["right"]}/${detect_results[idx]["bottom"]}'),
                      leading: CircleAvatar(
                        backgroundColor:
                            const Color.fromARGB(255, 111, 121, 125),
                        child: Text(
                          "${idx + 1}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      children: <Widget>[
                        const Divider(
                          height: 3,
                          color: Colors.white,
                        ),
                        buildResultDetailTile(context, idx, "left"),
                        const Divider(
                          height: 3,
                          color: Colors.white,
                        ),
                        buildResultDetailTile(context, idx, "right"),
                        const Divider(
                          height: 3,
                          color: Colors.white,
                        ),
                        buildResultDetailTile(context, idx, "top"),
                        const Divider(
                          height: 3,
                          color: Colors.white,
                        ),
                        buildResultDetailTile(context, idx, "bottom"),
                        const Divider(
                          height: 3,
                          color: Colors.white,
                        ),
                        buildResultDetailTile(context, idx, "width"),
                        const Divider(
                          height: 3,
                          color: Colors.white,
                        ),
                        buildResultDetailTile(context, idx, "height"),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
