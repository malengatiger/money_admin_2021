import 'package:flutter/material.dart';
import 'package:money_library_2021/models/anchor.dart';
import 'package:money_library_2021/util/util.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'dashboard_mobile.dart';
import 'dashboard_tablet.dart';

class DashboardMain extends StatefulWidget {
  final Anchor? user;

  const DashboardMain({Key? key, this.user}) : super(key: key);
  @override
  _DashboardMainState createState() => _DashboardMainState();
}

class _DashboardMainState extends State<DashboardMain>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  var isBusy = false;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    _refreshData();
  }

  void _refreshData() async {
    p('🔵 🔵 🔵 🔵 🔵 🔵 Refresh data and set up FCM messaging ....');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: DashboardMobile(),
      tablet: DashboardTablet(),
      desktop: DashboardTablet(),
    );
  }
}
