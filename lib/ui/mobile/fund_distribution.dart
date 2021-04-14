import 'dart:async';

import 'package:flutter/material.dart';
import 'package:money_admin_2021/ui/mobile/anchor_balances_mobile.dart';
import 'package:money_library_2021/api/net.dart';
import 'package:money_library_2021/bloc/agent_bloc.dart';
import 'package:money_library_2021/models/anchor.dart';
import 'package:money_library_2021/models/stellar_account_bag.dart';
import 'package:money_library_2021/models/stitch/models.dart';
import 'package:money_library_2021/util/functions.dart';
import 'package:money_library_2021/util/snack.dart';
import 'package:money_library_2021/util/util.dart';
import 'package:money_library_2021/widgets/balances_scroller.dart';
import 'package:money_library_2021/widgets/currency_dropdown.dart';
import 'package:oauth2_client/google_oauth2_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:page_transition/page_transition.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

class FundDistributionMobile extends StatefulWidget {
  @override
  _FundDistributionMobileState createState() => _FundDistributionMobileState();
}

class _FundDistributionMobileState extends State<FundDistributionMobile>
    with SingleTickerProviderStateMixin
    implements CurrencyDropDownListener {
  AnimationController _controller;
  bool busy = false;
  GoogleOAuth2Client client;
  OAuth2Helper oauth2Helper;
  var url = 'https://secure.stitch.money/connect/authorize';
  var clientId = 'test-3e463858-6832-49f3-a598-b2e4a9e14113';
  String paymentRequestResponse;
  String lastTransaction;
  Animation animation;
  StreamSubscription _sub;
  Anchor anchor;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    initUniLinks();
    _getBasicData();
  }

  static const mm = 'FundDistribution: 🌺 🌺 🌺 ';
  var _key = GlobalKey<ScaffoldState>();
  String authCode;
  String paymentRequestURL;
  var textController = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    _setAnimation();
    _sub.cancel();
    super.dispose();
  }

  Future<Null> initUniLinks() async {
    p('$mm .............. listening to uniLinks stream');
    _sub = getLinksStream().listen((String link) {
      p('$mm listen fired: $link');
    }, onError: (err) {
      p(err);
    });
    _sub.onData((data) {
      p('$mm LinksStream subscription onData fired: $data');
      String mData = data as String;
      int i = mData.indexOf("=");
      int j = mData.indexOf("&");
      paymentId = mData.substring(i + 1, j);
      p('$mm paymentId: $paymentId $mm');
      //
      var index = mData.lastIndexOf('=');
      if (index > 0) {
        paymentStatus = mData.substring(index + 1);
        p('$mm paymentStatus: $paymentStatus $mm');
      }
      _startFunding();
    });
    _sub.onDone(() {
      p('$mm sub onDone ....');
    });
  }

  void _getBasicData() async {
    anchor = await agentBloc.getAnchor();
    _getDistributionAccountBalances();
    _getCurrency();
  }

  void _getCurrency() {
    if (anchor.anchorCurrencyCode == null) anchor.anchorCurrencyCode = "ZAR";
    if (anchor.assetCode == null) anchor.assetCode = "ZARK";
  }

  void _getPaymentRequestURL() async {
    p('$mm ........ getPaymentRequestURL from Stitch ...');
    setState(() {
      busy = true;
    });
    try {
      Map<String, dynamic> stitchResponseJSON = await NetUtil.get(
          apiRoute:
              'createPaymentRequest?amount=$amount&currency=${anchor.anchorCurrencyCode}&reference=${referenceController.text}');
      StitchResponse stitchResponse =
          StitchResponse.fromJson(stitchResponseJSON);

      if (stitchResponse.errors == null) {
        paymentRequestURL = stitchResponse.paymentRequest.url;
        paymentRequestURL.trimLeft();
        paymentRequestURL.trimRight();
        p('🔑 🔑 🔑 🔑 payment request generated : 🔑 🔑 🔑 🔑  url to send to backend: $paymentRequestURL');
        startBrowser();
      } else {
        StringBuffer buffer = StringBuffer();
        stitchResponse.errors.forEach((element) {
          buffer.writeln(element.toJson());
        });
        AppSnackBar.showErrorSnackBar(
            scaffoldKey: _key, message: buffer.toString());
      }
    } catch (e) {
      p(e);
      AppSnackBar.showErrorSnackBar(
          scaffoldKey: _key, message: 'Failed to get Payment Request');
    }

    setState(() {
      busy = false;
    });
  }

  void startBrowser() async {
    p('$mm 🔆 🔆 🔆 🔆 🔆 🔆 🔆 🔆 starting browser with $paymentRequestURL 🔆 🔆 🔆 🔆');
    setState(() {
      busy = true;
    });
    if (await canLaunch(paymentRequestURL)) {
      await launch(paymentRequestURL);
      p('🔆 🔆 🔆 🔆 🔵 🔵 🔵 🔵 🔵 🔵  browser launched with $paymentRequestURL 🔵 🔵');
    } else {
      throw '🔆 🔆  Could not launch $paymentRequestURL';
    }
  }

  String paymentStatus, paymentId;

  var amtController = TextEditingController(text: "0.00");
  var referenceController = TextEditingController(
      text:
          '${(DateTime.now().millisecondsSinceEpoch / (1000 * 60 * 60)).toStringAsFixed(3)}');

  List<Balance> balances = [];
  bool fundingDone = false;
  _startFunding() async {
    p(mm + '_startFunding distribution account with $amount');
    setState(() {
      busy = true;
    });
    List<dynamic> list =
        await NetUtil.get(apiRoute: 'fundDistributionAccount?amount=$amount');
    balances.clear();
    list.forEach((element) {
      balances.add(Balance.fromJson(element));
    });

    fundingDone = true;
    p('🦠🦠🦠🦠🦠 fundDistributionAccount result, should be list of balances: $result');
    setState(() {
      amtController.text = "";
      busy = false;
    });
    _navigateToAnchorBalances();
    AppSnackBar.showSnackBar(
        scaffoldKey: _key,
        message: result,
        textColor: Colors.yellow,
        backgroundColor: Colors.black);
  }

  String result = "";
  StellarAccountBag bag;

  _getDistributionAccountBalances() async {
    setState(() {
      isBusy = true;
    });

    p("$mm 🔵 🔵 🔵 🔵 🔵 🔵 _getDistributionAccountBalances: Anchor: ${anchor.toJson()}");
    bag = await agentBloc.getBalances(
        accountId: anchor.distributionStellarAccount.accountId, refresh: true);
    p("$mm 🔵 🔵 🔵 🔵 🔵 🔵 _getDistributionAccountBalances: Bag: ${bag.toJson()}");
    setState(() {
      isBusy = false;
    });
  }

  _setAnimation() {
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
  }

  _navigateToAnchorBalances() async {
    p("🚈 🔆 🔆 _navigateToAnchorBalances ...");
    Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.scale,
          alignment: Alignment.centerRight,
          duration: Duration(seconds: 1),
          child: AnchorBalancesMobile(balances: balances),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: _key,
      backgroundColor: secondaryColor,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          'Distribution Account Funding',
          style: Styles.blackBoldSmall,
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
        backgroundColor: secondaryColor,
        elevation: 0,
        bottom: PreferredSize(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: <Widget>[
                  Text(
                    anchor == null ? '' : anchor.name,
                    style: Styles.blackBoldMedium,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 48.0, right: 48),
                    child: Text(
                      bag == null ? '' : bag.accountId,
                      style: Styles.greyLabelTiny,
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      desc,
                      style: Styles.blackSmall,
                    ),
                  ),
                ],
              ),
            ),
            preferredSize: Size.fromHeight(180)),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration:
                BoxDecoration(boxShadow: customShadow, color: secondaryColor),
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: ListView(
                children: <Widget>[
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 64.0),
                    child: Row(
                      children: [
                        Text(
                          anchor == null ? "" : anchor.anchorCurrencyCode,
                          style: Styles.blackBoldLarge,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Icon(
                          Icons.arrow_forward,
                          size: 32,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          anchor == null ? "" : anchor.assetCode,
                          style: Styles.blackBoldLarge,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                        boxShadow: customShadow,
                        color: secondaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 28, right: 28, top: 20, bottom: 20),
                      child: TextField(
                        controller: textController,
                        keyboardType: TextInputType.number,
                        maxLength: 20,
                        style: Styles.blackBoldMedium,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: '0000.00',
                            labelText: 'Amount'),
                        onChanged: _onAmountChanged,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: amount == null
                        ? Container()
                        : ElevatedButton(
                            onPressed: _getPaymentRequestURL,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: busy
                                  ? Container(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        backgroundColor: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      'Create StableCoin',
                                      style: Styles.whiteBoldSmall,
                                    ),
                            ),
                          ),
                  ),
//                    SizedBox(height: 8),
//                    SizedBox(height: 20),
                  lastTransaction == null
                      ? Container()
                      : Text(
                          lastTransaction,
                          style: Styles.blackSmall,
                        ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            bottom: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 60,
                  width: 420,
                  decoration:
                      BoxDecoration(boxShadow: customShadow, color: baseColor),
                  child: BalancesScroller(
                    bag: bag,
                    direction: Axis.horizontal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  @override
  onChanged(Balance value) {
    p('MobileFunder: 💚 💚 balance selected ${value.assetCode} ${value.balance}');
    setState(() {});
  }

  double amount;
  var desc =
      'This page facilitates the funding of an Anchor \'s distribution account. '
      'It allows the administrator to transfer funds from a bank account in fiat currency and creates equivalent StableCoin in the distribution account';
  void _onAmountChanged(String value) {
    p('on amount changed: $value');
    setState(() {
      amount = double.parse(value);
    });
  }
}
