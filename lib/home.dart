/*
 * Maintained by jemo from 2019.12.24 to now
 * Created by jemo on 2019.12.24 14:43:07
 * Home
 */

import 'package:flutter/material.dart';
import 'ask/ask.dart';
import 'my/my.dart';

class Home extends StatefulWidget {

  @override
  HomeState createState() => HomeState();

}

class HomeState extends State<Home> {

  int selectedIndex = 0;
  final widgetOptions = <Widget>[
    Ask(),
    Text('答题'),
    My(),
  ];

  void onBottomNavigationBarItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('小符问题'),
      ),
      body: widgetOptions.elementAt(selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.help_outline),
            title: Text('问题'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feedback),
            title: Text('答题'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mood),
            title: Text('我的'),
          ),
        ],
        currentIndex: selectedIndex,
        onTap: onBottomNavigationBarItemTapped,
      ),
    );
  }

}
