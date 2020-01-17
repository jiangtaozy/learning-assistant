/*
 * Maintained by jemo from 2020.1.17 to now
 * Created by jemo on 2020.1.17 10:03:47
 * My
 */

import 'package:flutter/material.dart';
import 'login.dart';
import '../colors.dart';

class My extends StatefulWidget {

  @override
  MyState createState() => MyState();

}

class MyState extends State<My> {

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Color(CustomColors.LamTinBlue),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Login();
            },
          ),
        );
      },
      child: Text('登录'),
    );
  }

}
