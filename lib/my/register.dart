/*
 * Maintained by jemo from 2020.1.17 to now
 * Created by jemo on 2020.1.17 13:55:19
 * Register
 */

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../util/loading.dart';
import '../util/alert.dart';
import '../config.dart';
import '../colors.dart';
import 'dart:convert';
import 'dart:async';

class Register extends StatefulWidget {

  @override
  RegisterState createState() => RegisterState();

}

class RegisterState extends State<Register> {

  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final validationCodeController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();
  int countdown = -1;
  bool passwordObscure = true;
  Timer countdownTimer;

  void onGetValidationCodePressed() async {
    var phone = phoneController.text;
    RegExp phoneReg = new RegExp(r'(^1[3-9](\d{9})$)');
    if(phone.length == 0) {
      Alert.show(
        message: '请先输入手机号',
        context: context,
      );
      return null;
    }
    if(!phoneReg.hasMatch(phone)) {
      Alert.show(
        message: '手机号格式不正确',
        context: context,
      );
      return null;
    }
    final query = r'''
      mutation GetValidationCodeMutation(
        $input: GetValidationCodeInput!
      ) {
        getValidationCode(input: $input) {
          result {
            error
            message
          }
        }
      }
    ''';
    Map<String, dynamic> variables = {
      'input': {
        'clientMutationId': "111",
        'phone': phone,
      },
    };
    final data = {
      'query': query,
      'variables': variables,
    };
    final body = json.encode(data);
    Loading.show(context);
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
      final result = data['data']['getValidationCode']['result'];
      final message = result['message'];
      Alert.show(
        message: message,
        context: context,
      );
      setState(() {
        countdown = 5 * 60;
      });
      countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          countdown = countdown - 1;
        });
        if(countdown < 0) {
          timer.cancel();
        }
      });
    } else {
      throw Exception('网络出错了');
    }
  }

  void onSubmitPressed() async {
    if(!formKey.currentState.validate()) {
      return null;
    }
    var phone = phoneController.text;
    var validationCode = validationCodeController.text;
    var password = passwordController.text;
    var repeatPassword = repeatPasswordController.text;
    if(password != repeatPassword) {
      Alert.show(
        message: '两次输入的密码不一致',
        context: context,
      );
      return null;
    }
    final query = r'''
      mutation CreateUserMutation(
        $input: CreateUserInput!
      ) {
        createUser(input: $input) {
          createUserResult {
            error
            message
            token
          }
        }
      }
    ''';
    Map<String, dynamic> variables = {
      'input': {
        'clientMutationId': "222",
        'phone': phone,
        'password': password,
        'code': validationCode,
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
        final result = data['data']['createUser']['createUserResult'];
        final message = result['message'];
        final token = result['token'];
        Alert.show(
          message: message,
          context: context,
        );
      } else {
        throw Exception('网络出错了');
      }
    }
    catch(error) {
      Loading.dismiss(context);
      Alert.show(
        message: '网络出错了',
        context: context,
      );
      print('error: $error');
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    validationCodeController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();
    if(countdownTimer != null) {
      countdownTimer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('注册'),
      ),
      body: Form(
        key: formKey,
        autovalidate: false,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 40.0,
            right: 40.0,
          ),
          child: Column(
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
                    controller: validationCodeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: '请输入验证码',
                      labelText: '验证码',
                    ),
                    validator: (value) {
                      if(value.isEmpty) {
                        return '请输入验证码';
                      }
                      return null;
                    },
                  ),
                  Positioned(
                    right: 0,
                    bottom: 8,
                    child: RaisedButton(
                      onPressed: countdown > 0 ? null : onGetValidationCodePressed,
                      child: Text(
                        countdown > 0 ? '${countdown}秒' : '获取验证码'
                      ),
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  TextFormField(
                    controller: passwordController,
                    obscureText: passwordObscure,
                    decoration: const InputDecoration(
                      hintText: '请输入密码',
                      labelText: '密码',
                    ),
                    validator: (value) {
                      if(value.isEmpty) {
                        return '请输入密码';
                      }
                      if(value.length < 6) {
                        return '请输入长度不少于 6 位的秘密';
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
                      }
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: repeatPasswordController,
                obscureText: passwordObscure,
                decoration: const InputDecoration(
                  hintText: '请再次输入密码',
                  labelText: '重复密码',
                ),
                validator: (value) {
                  if(value.isEmpty) {
                    return '请再次输入密码';
                  }
                  return null;
                },
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 30,
                ),
                width: double.infinity,
                child: RaisedButton(
                  color: Color(CustomColors.LamTinBlue),
                  onPressed: onSubmitPressed,
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
