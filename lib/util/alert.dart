/*
 * Maintained by jemo from 2020.1.17 to now
 * Created by jemo on 2020.1.17 11:34:09
 * Alert
 */

import 'package:flutter/material.dart';
import 'dart:async';

class Alert {

  static show({message, context}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(message),
        );
      },
    );
    Timer(Duration(seconds: 1), () {
      Navigator.of(
        context,
        rootNavigator: true,
      ).pop('dialog');
    });
  }

}
