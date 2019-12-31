/*
 * Maintained by jemo from 2019.12.31 to now
 * Created by jemo on 2019.12.31 16:11:47
 * Cropped image
 */

import 'package:flutter/material.dart';
import 'dart:io';

class CroppedImage extends StatefulWidget {

  final File imageFile;

  const CroppedImage({
    Key key,
    this.imageFile,
  }) : super(key: key);

  @override
  CroppedImageState createState() => CroppedImageState();

}

class CroppedImageState extends State<CroppedImage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('小福学习助手'),
      ),
      body: Image.file(widget.imageFile),
    );
  }

}
