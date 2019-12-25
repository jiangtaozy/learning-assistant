/*
 * Maintained by jemo from 2019.12.24 to now
 * Created by jemo on 2019.12.24 14:43:07
 * Home
 */

import 'package:flutter/material.dart';
import 'ask/ask.dart';

class Home extends StatefulWidget {

  @override
  HomeState createState() => HomeState();

}

class HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('小福学习助手'),
      ),
      body: Ask(),
    );
  }

}
