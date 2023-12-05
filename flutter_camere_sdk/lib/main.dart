import 'dart:io';

import 'package:edge_detection/edge_detection.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Rn Flutter Deneme Sdk")),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.camera_alt),
          onPressed: () async {
            if (Platform.isIOS) {
              bool isCameraGranted = await Permission.camera.request().isGranted;
              if (!isCameraGranted) {
                isCameraGranted = await Permission.camera.request() == PermissionStatus.granted;
              }

              if (!isCameraGranted) {
                // Have not permission to camera
                return;
              }
              String imagePath = join((await getApplicationSupportDirectory()).path, "${(DateTime.now().millisecondsSinceEpoch / 1000).round()}.jpeg");

// Use below code for live camera detection with option to select from gallery in the camera feed.

              try {
                //Make sure to await the call to detectEdge.
                bool success = await EdgeDetection.detectEdge(
                  imagePath,
                  canUseGallery: true,
                  androidScanTitle: 'Scanning',
                  // use custom localizations for android
                  androidCropTitle: 'Crop',
                  androidCropBlackWhiteTitle: 'Black White',
                  androidCropReset: 'Reset',
                );
                setState(() {
                  _image = File(imagePath);
                });
              } catch (e) {
                print(e);
              }
            } else {
              final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
              setState(() {
                if (pickedFile != null) {
                  _image = File(pickedFile.path);
                } else {
                  _image = null;
                }
              });
            }
          }),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _image == null ? const Text('No image selected.') : Image.file(_image!),
            ),
            SizedBox(
              height: 200,
              child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => ViewPhotoScreen(image: _image)));
                  },
                  child: const Text("fotoğrafı görüntüle")),
            )
          ],
        ),
      ),
    );
  }
}

class ViewPhotoScreen extends StatelessWidget {
  final File? image;

  const ViewPhotoScreen({required this.image, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Photo"),
      ),
      body: Center(
        child: image == null ? const Text('No image selected.') : Image.file(image!),
      ),
    );
  }
}
