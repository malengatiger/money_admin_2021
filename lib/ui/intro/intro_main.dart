import 'package:flutter/material.dart';
import 'package:money_admin_2021/ui/dashboard/dashboard_main.dart';
import 'package:money_library_2021/models/anchor.dart';
import 'package:money_library_2021/util/functions.dart';
import 'package:money_library_2021/util/prefs.dart';
import 'package:money_library_2021/util/util.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'intro_mobile.dart';
import 'intro_tablet.dart';

class IntroMain extends StatefulWidget {
  final AnchorUser? user;
  IntroMain({Key? key, this.user}) : super(key: key);

  @override
  _IntroMainState createState() => _IntroMainState();
}

/// Main Widget that manages a responsive layout for intro pages
class _IntroMainState extends State<IntroMain> {
  var isBusy = false;
  AnchorUser? user;
  @override
  void initState() {
    super.initState();
    if (widget.user == null) {
      _checkUser();
    } else {
      user = widget.user;
    }
  }

  void _checkUser() async {
    p('IntroMain: 🎽 🎽 🎽 Checking the user .... 🎽 🎽 🎽');
    setState(() {
      isBusy = true;
    });
    user = await Prefs.getAnchorUser();
    if (user != null) {
      p('IntroMain: 🎽 🎽 🎽 Checking the user:  🎽 User is ${user!.firstName}  🎽');
      Navigator.pop(context);
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.scale,
              alignment: Alignment.topLeft,
              duration: Duration(seconds: 1),
              child: DashboardMain()));
    } else {
      p('IntroMain: 🎽 🎽 🎽 Checking the user:  🎽 User is NULL');
    }
    setState(() {
      isBusy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isBusy
        ? Scaffold(
            appBar: AppBar(
              title: Text('Loading User ..', style: Styles.whiteSmall),
            ),
            body: Center(
              child: Container(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(
                  strokeWidth: 8,
                  backgroundColor: Colors.deepPurple,
                ),
              ),
            ),
          )
        : ScreenTypeLayout(
            mobile: IntroMobile(user: user),
            tablet: IntroTablet(user: user),
            desktop: IntroTablet(user: user),
          );
  }
}
