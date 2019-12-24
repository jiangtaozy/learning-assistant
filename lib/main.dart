import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '小福学习助手',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Text('learning assistant'),
    );
  }
}
