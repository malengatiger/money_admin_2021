import 'package:flutter/material.dart';
import 'package:money_library_2021/models/anchor.dart';

class DashboardDesktop extends StatefulWidget {
  final Anchor user;
  DashboardDesktop({Key key, this.user}) : super(key: key);
  @override
  _DashboardDesktopState createState() => _DashboardDesktopState();
}

class _DashboardDesktopState extends State<DashboardDesktop>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
