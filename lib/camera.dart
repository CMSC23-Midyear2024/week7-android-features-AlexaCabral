import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Camera Demo',
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
              color: Colors.blue,
              titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.bold))),
      home: const CameraExample(),
    );
  }
}

class CameraExample extends StatefulWidget {
  const CameraExample({super.key});

  @override
  State<CameraExample> createState() => _CameraExampleState();
}

class _CameraExampleState extends State<CameraExample> {
  // camera permission is denied by default
  Permission permission = Permission.camera;
  PermissionStatus permissionStatus = PermissionStatus.denied;
  File? imageFile;

  @override
  void initState() {
    super.initState();

    _listenForPermissionStatus();
  }

  void _listenForPermissionStatus() async {
    final status = await permission.status;
    setState(() => permissionStatus = status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Camera App")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    if (permissionStatus == PermissionStatus.granted) {
                      final image = await ImagePicker()
                          .pickImage(source: ImageSource.camera);

                      setState(() {
                        imageFile = image == null ? null : File(image.path);
                      });
                    } else {
                      requestPermission();
                    }
                  },
                  child: const Text("Take Picture")),
              imageFile == null
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.all(30),
                      child: ClipRect(
                        child: Image.file(imageFile!, fit: BoxFit.cover),
                      ),
                    )
            ],
          ),
        ));
  }

  Future<void> requestPermission() async {
    final status = await permission.request();

    setState(() {
      print(status);
      permissionStatus = status;
      print(permissionStatus);
    });
  }
}
