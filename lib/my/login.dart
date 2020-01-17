/*
 * Maintained by jemo from 2020.1.17 to now
 * Created by jemo on 2020.1.17 10:14:53
 * Login
 */

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart';
import '../colors.dart';
import '../util/loading.dart';
import '../util/alert.dart';

class Login extends StatefulWidget {

  @override
  LoginState createState() => LoginState();

}

class LoginState extends State<Login> {

  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  bool passwordObscure = true;

  void onSubmitPressed() async {
    if(!formKey.currentState.validate()) {
      return null;
    }
    var phone = phoneController.text;
    var password = passwordController.text;
    final query = r'''
      mutation GetTokenMutation(
        $input: GetTokenInput!
      ) {
        getToken(input: $input) {
          getTokenResult {
            error
            message
            phone
            token
          }
        }
      }
    ''';
    Map<String, dynamic> variables = {
      'input': {
        'clientMutationId': "333",
        'phone': phone,
        'password': password,
      },
    };
    final data = {
      'query': query,
      'variables': variables,
    };
    final body = json.encode(data);
    Loading.show(context);
    try {
      final response = await http.post(
        Config.graphqlUrl,
        headers: {
          "Content-Type": "application/json",
        },
        body: body,
      );
      Loading.dismiss(context);
      if(response.statusCode == 200) {
        final data = json.decode(response.body);
        final result = data['data']['getToken']['getTokenResult'];
        final error = result['error'];
        final message = result['message'];
        final phone = result['phone'];
        final token = result['token'];
        if(error == null) {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('token', token);
        }
        Aleart.show(
          message: message,
          context: context,
        );
      } else {
        throw Exception('网络出错了');
      }
    }
    catch(error) {
      print('error: $error');
      Loading.dismiss(context);
      Aleart.show(
        message: '网络出错了',
        context: context,
      );
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('登录'),
      ),
      body: Form(
        key: formKey,
        autovalidate: false,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 40.0,
            right: 40.0,
          ),
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: '请输入手机号码',
                  labelText: '手机号',
                ),
                validator: (value) {
                  if(value.isEmpty) {
                    return '请输入手机号码';
                  }
                  RegExp phoneReg = new RegExp(r'(^1[3-9](\d{9})$)');
                  if(!phoneReg.hasMatch(value)) {
                    return '手机号格式不正确';
                  }
                  return null;
                },
              ),
              Stack(
                children: [
                  TextFormField(
                    controller: passwordController,
                    obscureText: passwordObscure,
                    decoration: const InputDecoration(
                      hintText: '请输入秘密',
                      labelText: '密码',
                    ),
                    validator: (value) {
                      if(value.isEmpty) {
                        return '请输入秘密';
                      }
                      return null;
                    },
                  ),
                  Positioned(
                    right: 0,
                    bottom: 8,
                    child: IconButton(
                      icon: Icon(
                        passwordObscure ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          passwordObscure = !passwordObscure;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 40,
                ),
                width: double.infinity,
                child: RaisedButton(
                  color: Color(CustomColors.LamTinBlue),
                  onPressed: onSubmitPressed,
                  child: Text('登录'),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 20,
                ),
                child: FlatButton(
                  onPressed: () {
                    /*
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Register()
                      ),
                    );
                    */
                  },
                  child: Text('注册'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
