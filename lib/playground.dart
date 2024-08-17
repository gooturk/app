import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gooturk/common/provider/method_channel_provider.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class GDetectedObject {
  GDetectedObject({
    required this.confidence,
    required this.boundingBox,
    required this.label,
  });

  factory GDetectedObject.fromJson(Map<dynamic, dynamic> json) {
    return GDetectedObject(
      confidence: json['confidence'] as double,
      boundingBox: Rect.fromLTWH(
        json['x'] as double,
        json['y'] as double,
        json['width'] as double,
        json['height'] as double,
      ),
      label: json['label'] as String,
    );
  }
  final double confidence;
  final Rect boundingBox;
  final String label;
}

class PlaygroundWidget extends ConsumerStatefulWidget {
  static String get routerName => '/playground';
  const PlaygroundWidget({super.key});

  @override
  ConsumerState<PlaygroundWidget> createState() => _PlaygroundWidgetState();
}

class _PlaygroundWidgetState extends ConsumerState<PlaygroundWidget> {
  File? _image;
  List<Map<String, dynamic>> detect_results = [];
  int? elapsed_time;
  bool is_new_model = false;
  late final MethodChannel methodChannel;
  String modell_path = 'assets/yolov8x-worldv2.mlmodel';

  @override
  void initState() {
    super.initState();
    methodChannel = ref.read(methodChannelProvider);
  }

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
    // if (!await file.exists()) {
    final byteData = await rootBundle.load(assetPath);
    await file.writeAsBytes(
      byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
    );
    // }
    return file.path;
  }

  void loadModel() async {
    final modelPath = await _copy(modell_path);
    print('calling switft.. with path: $modell_path');
    final res = await methodChannel.invokeMethod<bool>("loadModel", {
      "model": modelPath,
    });
    print('from switft: $res');
  }

  void debugg() async {
    print('calling switft.. bar');
    final res = await methodChannel.invokeMethod<bool>("debug");
    print('from switft: Done $res');
  }

  Future<List<GDetectedObject>> inference() async {
    final start = DateTime.now();
    final res =
        await methodChannel.invokeMethod<List<Object?>>("inferenceImage", {
      'imagePath': _image!.path,
    }).catchError((_) {
      return <GDetectedObject?>[];
    });

    final objects = <GDetectedObject>[];

    res?.forEach((json) {
      json = Map<String, dynamic>.from(json as Map);
      objects.add(GDetectedObject.fromJson(json));
    });
    final end = DateTime.now();
    final elapsed = end.difference(start);
    elapsed_time = elapsed.inMilliseconds;

    detect_results.clear();
    for (final obj in objects) {
      final left = obj.boundingBox.left;
      final top = obj.boundingBox.top;
      final right = obj.boundingBox.right;
      final bottom = obj.boundingBox.bottom;
      final width = obj.boundingBox.width;
      final height = obj.boundingBox.height;
      final conf = (obj.confidence * 100).toStringAsFixed(1);
      final label = obj.label;
      detect_results.add({
        "left": left,
        "right": right,
        "top": top,
        "bottom": bottom,
        "width": width,
        "height": height,
        "conf": conf,
        "label": label,
      });
    }
    setState(() {
      detect_results;
    });
    return objects;
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
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Model: '$modell_path'"),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          is_new_model = !is_new_model;
                          if (is_new_model) {
                            modell_path = 'assets/yolov8x-worldv2.mlmodel';
                          } else {
                            modell_path = 'assets/yolov8n.mlmodel';
                          }
                        });
                      },
                      child: Text('Change Model')),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      is_new_model = !is_new_model;
                      loadModel();
                    },
                    child: const Text('CompileMLModel'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      inference();
                    },
                    child: const Text('Inference'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      debugg();
                    },
                    child: const Text('Debug'),
                  ),
                  const SizedBox(height: 20),
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
                  elapsed_time != null
                      ? Text(
                          "Inference time: $elapsed_time ms\n #${detect_results.length} Found",
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
            // Positioned(
            //   left: (detect_results.length > 0) ? detect_results[0]["left"] : 0,
            //   top: (detect_results.length > 0) ? detect_results[0]["top"] : 0,
            //   child: Container(
            //     decoration: BoxDecoration(
            //       border: Border.all(
            //         width: 2,
            //         color: Colors.blue,
            //       ),
            //     ),
            //     width: (detect_results.length > 0)
            //         ? detect_results[0]["width"]
            //         : 0,
            //     height: (detect_results.length > 0)
            //         ? detect_results[0]["height"]
            //         : 0,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
