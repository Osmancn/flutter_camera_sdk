import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
            final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
            setState(() {
              if (pickedFile != null) {
                _image = File(pickedFile.path);
              } else {
                _image = null;
              }
            });
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


