/*
 * Maintained by jemo from 2019.12.24 to now
 * Created by jemo on 2019.12.24 16:20:37
 * Camera
 */

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../main.dart';
import 'package:flutter/services.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

class Camera extends StatefulWidget {

  @override
  CameraState createState() => CameraState();

}

class CameraState extends State<Camera> {

  CameraController controller;
  Future<void> initializeControllerFuture;
  final orientationMap = {
    NativeDeviceOrientation.portraitUp: 0,
    NativeDeviceOrientation.portraitDown: 2,
    NativeDeviceOrientation.landscapeLeft: 1,
    NativeDeviceOrientation.landscapeRight: -1,
  };

  @override
  void initState() {
    super.initState();
    initCamera();
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  void initCamera() async {
    controller = CameraController(
      cameras[0],
      ResolutionPreset.medium,
    );
    initializeControllerFuture = controller.initialize();
  }

  @override
  void dispose() {
    controller?.dispose();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: initializeControllerFuture,
        builder: (context, snapshop) {
          if(snapshop.connectionState == ConnectionState.done) {
            return CameraPreview(controller);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: NativeDeviceOrientationReader(
        useSensor: true,
        builder: (context) {
          NativeDeviceOrientation orientation = NativeDeviceOrientationReader.orientation(context);
          final turns = orientationMap[orientation];
          return FloatingActionButton(
            child: RotatedBox(
              quarterTurns: turns,
              child: Icon(Icons.camera_alt),
            ),
            onPressed: () {},
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

}
