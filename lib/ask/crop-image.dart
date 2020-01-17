/*
 * Maintained by jemo from 2019.12.29 to now
 * Created by jemo on 2019.12.29 15:28:37
 * Crop image
 */

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_crop/image_crop.dart';
import '../colors.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:flutter/services.dart';
import 'cropped-image.dart';

class CropImage extends StatefulWidget {

  final String imagePath;
  final NativeDeviceOrientation imageOrientation;

  const CropImage({
    Key key,
    this.imagePath,
    this.imageOrientation,
  }) : super(key: key);

  @override
  CropImageState createState() => CropImageState();

}

class CropImageState extends State<CropImage> {

  final cropKey = GlobalKey<CropState>();
  final defaultWidthMap = {
    NativeDeviceOrientation.portraitUp: 0.8,
    NativeDeviceOrientation.portraitDown: 0.8,
    NativeDeviceOrientation.landscapeLeft: 0.8,
    NativeDeviceOrientation.landscapeRight: 0.8,
  };
  final defaultAspectRatioMap = {
    NativeDeviceOrientation.portraitUp: 2.0 / 1.0,
    NativeDeviceOrientation.portraitDown: 2.0 / 1.0,
    NativeDeviceOrientation.landscapeLeft: 4.0 / 1.0,
    NativeDeviceOrientation.landscapeRight: 4.0 / 1.0,
  };

  @override
  dispose(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  void onCropIconPressed() async {
    final scale = cropKey.currentState.scale;
    final area = cropKey.currentState.area;
    if(area == null) {
      print('CropImageOnCropIconPressedError: area is null');
      return;
    }
    final sample = await ImageCrop.sampleImage(
      file: File(widget.imagePath),
      preferredSize: (2000 / scale).round(),
    );
    final file = await ImageCrop.cropImage(
      file: sample,
      area: area,
    );
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return CroppedImage(
            imageFile: file,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Container(
            color: Color(CustomColors.Black1),
            child: Flex(
              direction: orientation == Orientation.portrait ? Axis.vertical : Axis.horizontal,
              children: <Widget>[
                Expanded(
                  child: Crop(
                    key: cropKey,
                    image: FileImage(File(widget.imagePath)),
                    defaultWidth: defaultWidthMap[widget.imageOrientation],
                    defaultAspectRatio: defaultAspectRatioMap[widget.imageOrientation],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Flex(
                    direction: orientation == Orientation.portrait ? Axis.horizontal : Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: 40.0,
                        height: 40.0,
                      ),
                      FloatingActionButton(
                        child: Icon(Icons.check),
                        onPressed: onCropIconPressed,
                      ),
                      Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: ShapeDecoration(
                          color: Colors.black,
                          shape: CircleBorder(),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.close),
                          color: Colors.white,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }

}
