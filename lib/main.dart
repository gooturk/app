import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gooturk/common/exception/custom_exception_handler.dart';
import 'package:gooturk/common/provider/go_router_provider.dart';
import 'package:gooturk/playground.dart';
import 'package:image_picker/image_picker.dart';
import 'yolo_example.dart';
import 'package:logger/logger.dart' as log;

var logger = log.Logger();

class Logger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    print('''
{
  "provider": "${provider.name ?? provider.runtimeType}",
  "newValue": "$newValue"
}''');
  }
}

void main() {
  final container = ProviderContainer(observers: [Logger()]);
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.grey[50],
    ),
  );

  // final originalOnError = FlutterError.onError;
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    // originalOnError?.call(details);
    CustomExceptionHandler.hanldeException(details.exception);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    CustomExceptionHandler.hanldeException(error);
    return true;
  };

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: _App(),
    ),
  );
}

class _App extends ConsumerWidget {
  const _App();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    return ScreenUtilInit(
      designSize: MediaQuery.of(context).size.height > 700
          ? const Size(375, 812)
          : MediaQuery.of(context).size.height > 550
              ? const Size(375, 667)
              : const Size(375, 500),
      // scaleByHeight: MediaQuery.of(context).size.width > 450,
      builder: (context, child) => MaterialApp.router(
        routerConfig: router,
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: 1.0,
          ),
          child: child!,
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gooturk Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Gooturk Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

double getLength(double value, double ratio) {
  return ratio * value;
}

class _MyHomePageState extends State<MyHomePage> {
  static const nativeChannel = MethodChannel('gooturk_native');
  int _counter = 0;
  bool _image = true;
  ImageProvider<Object> _centerImage = const AssetImage('assets/logo2.png');
  XFile? _imagePicked;
  int? batteryState;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imagePicked = pickedImage;
    });
  }

  void _switchImage() {
    setState(() {
      if (_image) {
        _centerImage = const AssetImage('assets/logo1.png');
      } else {
        _centerImage = const AssetImage('assets/logo2.png');
      }
      _image = !_image;
    });
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  Widget loadAssetImage() {
    return _imagePicked == null
        ? const Text('No image selected')
        : Image.file(
            File(_imagePicked!.path),
            width: 200,
            height: 200,
          );
  }

  Future<String> getDelayedData() async {
    await Future.delayed(const Duration(seconds: 20));
    return "Data: Hello World!";
  }

  Widget buildFutureData() {
    return FutureBuilder(
      future: getDelayedData(),
      builder: (context, snapshot) {
        return snapshot.data == null
            ? Text("Waiting for 20sec till data is available...")
            : Text(snapshot.data!);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: getLength(width, 0.8),
                height: getLength(height, 0.2),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    const Text('Go to Playground Page'),
                    OutlinedButton(
                      key: const Key('go_to_playground_page'),
                      onPressed:
                          // _incrementCounter,
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PlaygroundWidget(),
                          ),
                        );
                      },
                      // tooltip: 'Go to Example',
                      // child: const Icon(Icons.arrow_forward),
                      child: const Text("Playground page"),
                    ),
                  ],
                ),
              ),
              Container(
                width: getLength(width, 0.8),
                height: getLength(height, 0.2),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text(
                        'FutureBuilder Test',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      const Text(
                        'Data initialized once on build:',
                      ),
                      buildFutureData(),
                    ],
                  ),
                ),
              ),
              Container(
                width: getLength(width, 0.8),
                height: getLength(height, 0.2),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      'You have pushed the button this many times:',
                    ),
                    Text(
                      '$_counter',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    FloatingActionButton(
                      heroTag: 'increment_icon_tag',
                      onPressed: _incrementCounter,
                      tooltip: 'Increment',
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
              Container(
                width: getLength(width, 0.8),
                height: getLength(height, 0.3),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text(
                        'Asset Image Test',
                      ),
                      Container(
                        width: getLength(width, 0.4),
                        height: getLength(width, 0.4),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: _centerImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const Text('Switch Image'),
                      FloatingActionButton(
                        heroTag: 'switch_image_tag',
                        key: const Key('switch_image'),
                        onPressed: _switchImage,
                        tooltip: 'Switch',
                        child: const Icon(Icons.swap_vert),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: getLength(width, 0.8),
                height: getLength(height, 0.3),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text('Local Image load Test(for iOS)'),
                      const Text('for android, may require permission config'),
                      loadAssetImage(),
                      FloatingActionButton(
                        heroTag: 'pick_image_tag',
                        key: const Key('pick_image'),
                        onPressed: _pickImage,
                        child: Icon(Icons.add_a_photo),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: getLength(width, 0.8),
                height: getLength(height, 0.3),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text('Go to Yolo Camera View Page'),
                      const Text('tested on iOS device O / Simulator X'),
                      const Text(
                        'android requires camera & storage permission config',
                      ),
                      OutlinedButton(
                        key: const Key('go_to_example_page'),
                        onPressed:
                            // _incrementCounter,
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ExampleWidget(),
                            ),
                          );
                        },
                        // tooltip: 'Go to Example',
                        // child: const Icon(Icons.arrow_forward),
                        child: const Text("Yolo page"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            key: const Key('yolo_run_icon'),
            heroTag: 'run_icon_test',
            // onPressed: getData,
            onPressed: () {
              print("pressed run");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Hello World!'),
                ),
              );
            },
            tooltip: 'Run',
            child: const Icon(Icons.arrow_circle_right),
          ),
          FloatingActionButton(
            key: const Key('debug_icon1'),
            heroTag: 'debug_icon_test',
            // onPressed: getData,
            onPressed: () async {
              print("Swift method called");
              final res =
                  await nativeChannel.invokeMethod<int>("getBatteryLevel", {
                "arg1": 1,
                "arg2": 2,
              });
              batteryState = res;
              print("Recieved as $res");
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Battery Level: $batteryState%'),
                ),
              );
            },
            tooltip: 'Run',
            child: const Icon(Icons.battery_5_bar_sharp),
          ),
        ],
      ),
    );
  }
}
