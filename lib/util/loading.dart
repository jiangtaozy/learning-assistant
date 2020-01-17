/*
 * Maintained by jemo from 2020.1.17 to now
 * Created by jemo on 2020.1.17 11:32:14
 * Loading
 */

import 'package:flutter/material.dart';

class Loading {

  static show(context) {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Container(
            padding: EdgeInsets.all(10),
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  static dismiss(context) {
    Navigator.of(
      context,
      rootNavigator: true,
    ).pop('dialog');
  }

}
