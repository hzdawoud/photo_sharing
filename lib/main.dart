import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_sharing/filter_model.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  return runApp(MyApp(firstCamera));
}

class MyApp extends StatelessWidget {
  final camera;
  MyApp(this.camera);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
          title: 'Flutter Demo Home Page',
          firstCamera:camera
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final CameraDescription firstCamera;
  MyHomePage({Key key, this.title, this.firstCamera}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CameraController _cameraController;
  Future<void> _initializeControllerFuture;
  List<Filter> _myList;
  Filter _filter;
  int counter;


  Color c = const Color(0xFF42A5F5);

  @override
  void initState() {
    _cameraController = CameraController(widget.firstCamera, ResolutionPreset.medium);
    _initializeControllerFuture = _cameraController.initialize();

    _myList = List<Filter>();
    _myList.add(Filter(0, 0, 0, Color(0x00ff0000)));
    _myList.add(Filter(10, 15, 0.2, Color(0x00ff0000)));
    _myList.add(Filter(15, 20, 0.2, Color(0x0000ff00)));
    _myList.add(Filter(23, 23, 0.2, Color(0x0000ff00)));
    _myList.add(Filter(23, 23, 0.2, Color(0x000000ff)));
    _myList.add(Filter(30, 30, 0.3, Color(0x000000ff)));

    counter = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),

      body: Stack(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.done){
                return CameraPreview(_cameraController);
              } else {
                return Center(child: Text("Failed"),);
              }
            },
          ),

          PageView.builder(
            itemCount: _myList.length,
            itemBuilder: (_, index) {
              return BackdropFilter(
                filter: ImageFilter.blur(sigmaX: _myList[index].sigX, sigmaY: _myList[index].sigY),
                child: Container(
                  color: _myList[index].color.withOpacity(_myList[index].opacity),
                ),
              );
            },
            scrollDirection: Axis.horizontal,
          ),

        ],
      ),

      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        child: Icon(Icons.add),
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final path = join(
                (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png'
            );
            await _cameraController.takePicture(path);
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => DisplayPicture(path)
            ));
          } catch (e) {
            print(e);
          }
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class DisplayPicture extends StatelessWidget {

  final String path;

  DisplayPicture(this.path);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.file(File(path)),
    );
  }
}


