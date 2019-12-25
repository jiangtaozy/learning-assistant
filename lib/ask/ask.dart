/*
 * Maintained by jemo from 2019.12.24 to now
 * Created by jemo on 2019.12.24 15:37:06
 * Ask
 */

import 'package:flutter/material.dart';
import 'camera.dart';

class Ask extends StatefulWidget {

  @override
  AskState createState() => AskState();

}

class AskState extends State<Ask> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('问题'),
      floatingActionButton: FloatingActionButton(
        tooltip: '问题',
        child: Icon(Icons.camera_alt),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return Camera();
              },
            ),
          );
        },
      ),
    );
  }

}
