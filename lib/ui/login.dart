import 'package:flutter/material.dart';
import 'package:money_library_2021/util/util.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'mobile/mobile_login.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: baseColor,
      body: ScreenTypeLayout(
        mobile: LoginMobile(),
      ),
    ));
  }
}
