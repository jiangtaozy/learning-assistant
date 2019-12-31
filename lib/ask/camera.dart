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
import 'line.dart';
import 'crop-image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

class Camera extends StatefulWidget {

  @override
  CameraState createState() => CameraState();

}

class CameraState extends State<Camera> with TickerProviderStateMixin {

  CameraController cameraController;
  Future<void> initializeControllerFuture;
  final orientationMap = {
    NativeDeviceOrientation.portraitUp: 0.0,
    NativeDeviceOrientation.portraitDown: 0.5,
    NativeDeviceOrientation.landscapeLeft: 0.25,
    NativeDeviceOrientation.landscapeRight: -0.25,
  };
  AnimationController animationController;
  double rotationBegin = 0.0;
  double rotationEnd = 0.0;
  Stream<NativeDeviceOrientation> nativeDeviceOrientationListener;
  var imageOrientation;


  @override
  void initState() {
    super.initState();
    initCamera();
    initAnimationController();
    initNativeDeviceOrientation();
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  void initCamera() async {
    cameraController = CameraController(
      cameras[0],
      ResolutionPreset.high,
    );
    initializeControllerFuture = cameraController.initialize();
  }

  void initAnimationController() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300,
      ),
    );
  }

  void initNativeDeviceOrientation() async {
    final nativeDeviceOrientationCommunicator = NativeDeviceOrientationCommunicator();
    final currentOrientation = await nativeDeviceOrientationCommunicator.orientation(useSensor: true);
    onOrientationChanged(currentOrientation);
    nativeDeviceOrientationListener = nativeDeviceOrientationCommunicator.onOrientationChanged(useSensor: true)
      ..listen(onOrientationChanged);
  }

  void onOrientationChanged(NativeDeviceOrientation orientation) {
    if(!mounted) {
      return;
    }
    final rotation = orientationMap[orientation];
    setState(() {
      rotationBegin = rotationEnd;
      rotationEnd = rotation;
      imageOrientation = orientation;
    });
    animationController.reset();
    animationController.forward();
  }

  @override
  void dispose() {
    cameraController?.dispose();
    animationController?.dispose();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  void onCameraIconPressed() async {
    try {
      await initializeControllerFuture;
      final temporaryDirectory = await getTemporaryDirectory();
      final path = join(
        temporaryDirectory.path,
        '${DateTime.now()}.png',
      );
      await cameraController.takePicture(path);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return CropImage(
              imagePath: path,
              imageOrientation: imageOrientation,
            );
          },
        ),
      );
    } catch(error) {
      print('cameraOnCameraIconPressedCatchError: $error');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: initializeControllerFuture,
        builder: (context, snapshop) {
          if(snapshop.connectionState == ConnectionState.done) {
            return Stack(
              children: <Widget>[
                CameraPreview(cameraController),
                Line(),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: RotationTransition(
          turns: Tween<double>(
            begin: rotationBegin,
            end: rotationEnd,
          ).animate(animationController),
          child: Icon(Icons.camera_alt),
        ),
        onPressed: onCameraIconPressed,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

}
