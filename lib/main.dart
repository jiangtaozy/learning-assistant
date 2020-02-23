/*
 * Maintained by jemo from 2019.12.24 to now
 * Created by jemo on 2019.12.24 14:41:51
 * Main
 */

import 'package:flutter/material.dart';
import 'home.dart';
import 'package:camera/camera.dart';
import 'dart:async';

List<CameraDescription> cameras = [];

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error: ${e.code}\nError Message: ${e.description}');
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}
