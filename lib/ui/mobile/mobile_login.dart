import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:money_admin_2021/ui/dashboard/dashboard_main.dart';
import 'package:money_library_2021/api/auth.dart';
import 'package:money_library_2021/util/functions.dart';
import 'package:money_library_2021/util/snack.dart';
import 'package:money_library_2021/util/util.dart';
import 'package:page_transition/page_transition.dart';

class LoginMobile extends StatefulWidget {
  @override
  _LoginMobileState createState() => _LoginMobileState();
}

class _LoginMobileState extends State<LoginMobile> implements SnackBarListener {
  GlobalKey<ScaffoldState> _key = GlobalKey();
  bool isBusy = false;

  @override
  void initState() {
    super.initState();
    p("🌸 🌸 🌸 initState in LoginMobile ....");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        key: _key,
        backgroundColor: Colors.brown[100],
        body: isBusy
            ? Center(
                child: Container(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 6,
                    backgroundColor: Colors.teal[800],
                  ),
                ),
              )
            : Stack(
                children: <Widget>[
                  Center(child: LoginForm()),
                ],
              ),
      ),
      onWillPop: () => doNothing(),
    );
  }

  Future<bool> doNothing() async {
    return false;
  }

  @override
  onActionPressed(int action) {
    // TODO: implement onActionPressed
    return null;
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm>
    with SingleTickerProviderStateMixin {
  TextEditingController emailCntr = TextEditingController();
  TextEditingController pswdCntr = TextEditingController();
  AnimationController titleController;
  Animation titleAnimation, btnAnimation;

  bool isBusy = false;
  Animation<double> boxAnimation;
  Animation<double> classificationAnimation;
  Animation<Offset> pulseAnimation;
  Animation<Offset> meanAnimation;
  @override
  void initState() {
    super.initState();
    _setUpAnimation();
    _setDemoLogin();
  }

  _setDemoLogin() {
    var status = DotEnv.env['status'];
    if (status == 'dev') {
      emailCntr.text = 'aubrey@aftarobot.com';
      pswdCntr.text = 'pTiger3#Word!isWannamaker#23';
    }
  }

  _setUpAnimation() {
    titleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    titleAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: titleController,
        curve: Interval(0.0, 1.0, curve: Curves.easeInOut)));
    btnAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: titleController,
        curve: Interval(0.0, 1.0, curve: Curves.easeInOut)));

    titleController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        p(".......... 💦 💦 💦 Title Animation completed");
      }
    });

    titleController.forward();
  }

  var _key = GlobalKey<ScaffoldState>();

  void _onEmailChanged(String value) {
    print(value);
  }

  void _signIn() async {
    if (emailCntr.text.isEmpty || pswdCntr.text.isEmpty) {
      AppSnackBar.showErrorSnackBar(
          scaffoldKey: _key,
          message: "Credentials missing or invalid",
          actionLabel: 'Error');
      return;
    }
    setState(() {
      isBusy = true;
    });
    try {
      var user = await Auth.signInAnchor(
          email: emailCntr.text, password: pswdCntr.text);
      print('✳️ ️signed in ok, ✳️ popping ..... anchorUser: ${user.toJson()}');
      Navigator.pop(context, true);
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.scale,
              alignment: Alignment.bottomCenter,
              child: DashboardMain()));
    } catch (e) {
      print(e);
      setState(() {
        isBusy = false;
      });
      AppSnackBar.showErrorSnackBar(
          scaffoldKey: _key, message: 'We have a problem $e', actionLabel: '');
    }
  }

  void _onPasswordChanged(String value) {
    print(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        key: _key,
        children: <Widget>[
          ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 2,
                  color: secondaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 60,
                        ),
                        ScaleTransition(
                          scale: titleAnimation,
                          alignment: Alignment(0.0, 0.0),
                          child: GestureDetector(
                            onTap: () {
                              titleController.reset();
                              titleController.forward();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Hero(
                                  tag: 'logo',
                                  child: Image.asset(
                                    'assets/logo/logo.png',
                                    width: 20,
                                    height: 20,
                                  ),
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  'Anchor Boss Sign in',
                                  style: Styles.blackBoldMedium,
                                ),
                                SizedBox(
                                  width: 48,
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                        icon: Icon(Icons.close),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        })
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(dummy),
                        SizedBox(
                          height: 40,
                        ),
                        TextField(
                          onChanged: _onEmailChanged,
                          keyboardType: TextInputType.emailAddress,
                          controller: emailCntr,
                          style: Styles.blueBoldSmall,
                          decoration: InputDecoration(
                              hintText: 'Enter  email address',
                              labelText: 'Email'),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        TextField(
                          onChanged: _onPasswordChanged,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          controller: pswdCntr,
                          decoration: InputDecoration(
                              hintText: 'Enter password',
                              labelText: 'Password'),
                        ),
                        SizedBox(
                          height: 60,
                        ),
                        ScaleTransition(
                          scale: btnAnimation,
                          child: Container(
                            height: 60,
                            width: 300,
                            decoration: BoxDecoration(
                                boxShadow: customShadow,
                                color: Theme.of(context).primaryColor),
                            child: isBusy
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : ElevatedButton(
                                    onPressed: () {
                                      p('💙 tapped to go logging in ...');
                                      _signIn();
                                    },
                                    child: isBusy
                                        ? Container(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 6,
                                            ),
                                          )
                                        : Text(
                                            "Submit Credentials",
                                            style: Styles.whiteBoldSmall,
                                          ),
                                  ),
                          ),
                        ),
                        SizedBox(
                          height: 60,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
