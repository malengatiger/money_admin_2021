import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:money_admin_2021/ui/dashboard/dashboard_main.dart';
import 'package:money_library_2021/models/anchor.dart';
import 'package:money_library_2021/util/functions.dart';
import 'package:money_library_2021/util/prefs.dart';
import 'package:money_library_2021/util/util.dart';
import 'package:page_transition/page_transition.dart';

import '../login.dart';

class IntroMobile extends StatefulWidget {
  final AnchorUser? user;
  IntroMobile({Key? key, this.user}) : super(key: key);
  @override
  _IntroMobileState createState() => _IntroMobileState();
}

class _IntroMobileState extends State<IntroMobile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  AnchorUser? user;

  var lorem =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ac sagittis lectus. Aliquam dictum elementum massa, '
      'eget mollis elit rhoncus ut.';

  var mList = <PageViewModel>[];
  Anchor? _anchor;
  void _buildPages(BuildContext context) {
    var page1 = PageViewModel(
      titleWidget: Text(
        "Welcome to AzaniaAnchor",
        style: TextStyle(
            fontSize: Styles.medium, color: Theme.of(context).primaryColor),
      ),
      bodyWidget: Text(
        "$lorem",
        style: Styles.blackSmall,
      ),
      image: Image.asset(
        "assets/intro/img1.jpeg",
        fit: BoxFit.cover,
      ),
    );
    var page2 = PageViewModel(
      titleWidget: Text(
        "Administrators are people too",
        style: TextStyle(
            fontSize: Styles.medium, color: Theme.of(context).primaryColor),
      ),
      bodyWidget: Text(
        "$lorem",
        style: Styles.blackSmall,
      ),
      image: Image.asset("assets/intro/img2.jpeg", fit: BoxFit.cover),
    );
    var page3 = PageViewModel(
      titleWidget: Text(
        "Thank you for using AzaniaAnchor",
        style: TextStyle(
            fontSize: Styles.medium, color: Theme.of(context).primaryColor),
      ),
      bodyWidget: Text(
        "$lorem",
        style: Styles.blackSmall,
      ),
      image: Image.asset("assets/intro/img3.jpg", fit: BoxFit.cover),
    );
    mList.clear();
    setState(() {
      mList.add(page1);
      mList.add(page2);
      mList.add(page3);
    });
  }

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    user = widget.user;
    _getAnchor();
  }

  void _getAnchor() async {
    _anchor = await Prefs.getAnchor();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (mList.isEmpty) {
      _buildPages(context);
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _anchor == null ? 'Anchor loading ...' : _anchor!.name!,
            style: Styles.whiteSmall,
          ),
          bottom: PreferredSize(
            child: Column(
              children: [
                user == null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: _navigateToSignIn,
                            child:
                                Text('Sign In', style: Styles.blackBoldSmall),
                          ),
                          SizedBox(
                            width: 24,
                          ),
                        ],
                      )
                    : Text(
                        '${user!.firstName} ${user!.lastName}',
                        style: Styles.blackBoldSmall,
                      ),
                SizedBox(
                  height: 16,
                )
              ],
            ),
            preferredSize: Size.fromHeight(40),
          ),
        ),
        body: Stack(
          children: [
            IntroductionScreen(
              pages: mList,
              onDone: () {
                _navigateToDashboard(context);
              },
              onSkip: () {
                _navigateToDashboard(context);
              },
              showSkipButton: false,
              skip: const Icon(Icons.skip_next),
              next: const Icon(Icons.arrow_forward),
              done: user == null
                  ? Container()
                  : Text("Done",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      )),
              dotsDecorator: DotsDecorator(
                size: const Size.square(10.0),
                activeSize: const Size(20.0, 10.0),
                activeColor: Theme.of(context).primaryColor,
                color: Colors.black26,
                spacing: const EdgeInsets.symmetric(horizontal: 3.0),
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDashboard(BuildContext context) {
    if (widget.user != null) {
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.scale,
              alignment: Alignment.topLeft,
              duration: Duration(seconds: 1),
              child: DashboardMain()));
    }
  }

  void _navigateToSignUp() async {
    var result = await Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.scale,
            alignment: Alignment.topLeft,
            duration: Duration(seconds: 1),
            child: Login()));
    if (result is AnchorUser) {
      setState(() {
        user = result;
      });
    }
  }

  void _navigateToSignIn() async {
    p('🌍 🌍 🌍 ... Navigate to sign-in ... 🌍');
    var result = await Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.scale,
            alignment: Alignment.topLeft,
            duration: Duration(seconds: 1),
            child: Login()));
    if (result is AnchorUser) {
      setState(() {
        user = result;
      });
    }
  }
}
