import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

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

  @override
  // ignore: must_call_super
  void initState() {
    _cameraController = CameraController(widget.firstCamera, ResolutionPreset.medium);
    _initializeControllerFuture = _cameraController.initialize();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            return CameraPreview(_cameraController);
          } else {
            return Center(child: Text("Failed"),);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        child: Icon(Icons.add),
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            // final path = join(
            //     (await getTemporaryDirectory()).path,
            //   '${DateTime.now()}.png'
            // );
            XFile pic = await _cameraController.takePicture();
            // Navigator.push(context, MaterialPageRoute(
            //     builder: (context) => DisplayPicture(pic)
            // ));
          } catch (e) {
            print(e);
          }
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

// class DisplayPicture extends StatelessWidget{
//   final XFile path;
//
//   DisplayPicture(this.path);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Image.file(File(path)),
//     );
//   }

}
