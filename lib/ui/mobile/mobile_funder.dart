import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:money_library_2021/bloc/agent_bloc.dart';
import 'package:money_library_2021/models/agent.dart';
import 'package:money_library_2021/models/stellar_account_bag.dart';
import 'package:money_library_2021/util/functions.dart';
import 'package:money_library_2021/util/image_handler/currency_icons.dart';
import 'package:money_library_2021/util/snack.dart';
import 'package:money_library_2021/util/util.dart';
import 'package:money_library_2021/widgets/balances_scroller.dart';
import 'package:money_library_2021/widgets/currency_dropdown.dart';

class AgentFunderMobile extends StatefulWidget {
  final Agent? agent;

  const AgentFunderMobile(this.agent);
  @override
  _AgentFunderMobileState createState() => _AgentFunderMobileState();
}

class _AgentFunderMobileState extends State<AgentFunderMobile>
    with SingleTickerProviderStateMixin
    implements CurrencyDropDownListener {
  late AnimationController controller;
  Animation? animation;
  bool isBusy = false;
  Balance? _selectedBalance;
  var _key = GlobalKey<ScaffoldState>();
  var textController = TextEditingController();

  String? lastTransaction;

  @override
  void initState() {
    super.initState();
    assert(widget.agent != null);
    _setAnimation();
    _getBalances();
  }

  StellarAccountBag? bag;
  _getBalances() async {
    setState(() {
      isBusy = true;
    });
    bag = await agentBloc.getBalances(
        accountId: widget.agent!.stellarAccountId, refresh: true);
    p("🔵 🔵 🔵 🔵 🔵 _AgentFunderMobileState: 🔵 getBalances Balances: ${bag!.toJson()}");
    setState(() {
      isBusy = false;
    });
  }

  _setAnimation() {
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    animation = Tween(begin: 0.0, end: 1.0).animate(controller);
  }

  _sendMoneyToAgent() async {
    if (isBusy) return;
    p('💧 ............... Sending money to agent ....>>>>>>>>>');
    if (amount == null || amount == 0.0) {
      AppSnackBar.showErrorSnackBar(
          scaffoldKey: _key, message: 'Please enter the amount');
      return;
    }

    p('MobileFunder: 🍊 🍊 🍊 send $amount to agent: 💚 ${widget.agent!.toJson()} ');
    setState(() {
      isBusy = true;
      lastTransaction = null;
    });
    try {
      //todo - hide keyboard
      bag = await agentBloc.sendMoneyToAgent(
          amount: amount.toString(),
          agent: widget.agent!,
          assetCode: _selectedBalance!.assetCode!);
    } catch (e) {
      p(e);
      AppSnackBar.showErrorSnackBar(
          scaffoldKey: _key, message: "Payment failed");
    }
    setState(() {
      isBusy = false;
      textController.text = '';
      lastTransaction = "Payment of ${_selectedBalance!.assetCode} $amount  "
          "at ${getFormattedDateHour(DateTime.now().toIso8601String())}";
      amount = null;
    });
  }

  Widget _getSelected() {
    return Container(
      decoration: BoxDecoration(
          boxShadow: customShadow, color: baseColor, shape: BoxShape.circle),
      child: Image.asset(
          CurrencyIcons.getCurrencyImagePath(_selectedBalance!.assetCode),
          height: 48,
          width: 48),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: _key,
      backgroundColor: secondaryColor,
      appBar: AppBar(
        title: Text(
          'Agent Funding',
          style: Styles.blackSmall,
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
                    widget.agent == null
                        ? ''
                        : widget.agent!.personalKYCFields!.getFullName(),
                    style: Styles.blackBoldMedium,
                  ),
                ],
              ),
            ),
            preferredSize: Size.fromHeight(60)),
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
                  SizedBox(height: 80),
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
                    child: _selectedBalance == null
                        ? Container()
                        : RaisedButton(
                            onPressed: _sendMoneyToAgent,
                            elevation: isBusy ? 0 : 8,
                            color:
                                isBusy ? Colors.pink[400] : Colors.indigo[300],
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: isBusy
                                  ? Container(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        backgroundColor: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      'Send Agent Funds',
                                      style: Styles.whiteSmall,
                                    ),
                            ),
                          ),
                  ),
//                    SizedBox(height: 8),
//                    SizedBox(height: 20),
                  lastTransaction == null
                      ? Container()
                      : Text(
                          lastTransaction!,
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
                  height: 40,
                  width: 400,
                  decoration:
                      BoxDecoration(boxShadow: customShadow, color: baseColor),
                  child: BalancesScroller(
                    bag: bag!,
                    direction: Axis.horizontal,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 60,
            top: 40,
            child: bag == null
                ? Container()
                : Center(
                    child: Row(
                      children: <Widget>[
                        CurrencyDropDown(
                          bag: bag!,
                          listener: this,
                          showXLM: false,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        _selectedBalance == null ? Container() : _getSelected(),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    ));
  }

  @override
  onChanged(Balance? value) {
    _selectedBalance = value;
    p('MobileFunder: 💚 💚 balance selected ${value!.assetCode} ${value.balance}');
    setState(() {});
  }

  double? amount;
  void _onAmountChanged(String value) {
    p('on amount changed: $value');
    amount = double.parse(value);
  }
}
