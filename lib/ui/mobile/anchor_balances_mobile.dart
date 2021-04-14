import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_library_2021/api/net.dart';
import 'package:money_library_2021/models/anchor.dart';
import 'package:money_library_2021/models/stellar_account_bag.dart';
import 'package:money_library_2021/util/functions.dart';
import 'package:money_library_2021/util/prefs.dart';

class AnchorBalancesMobile extends StatefulWidget {
  final List<Balance> balances;

  const AnchorBalancesMobile({Key key, this.balances}) : super(key: key);
  @override
  _AnchorBalancesMobileState createState() => _AnchorBalancesMobileState();
}

class _AnchorBalancesMobileState extends State<AnchorBalancesMobile>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  List<Balance> _balances = [];

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    _getAnchor();
    if (widget.balances == null) {
      _getData();
    } else {
      _filterBalances(widget.balances);
    }
  }

  void _filterBalances(List<Balance> mList) {
    _balances.clear();
    mList.forEach((element) {
      if (element.assetIssuer != null) {
        _balances.add(element);
      }
    });
  }

  Anchor anchor;
  void _getAnchor() async {
    anchor = await Prefs.getAnchor();
    setState(() {});
  }

  void _getData() async {
    var list = await NetUtil.getAnchorBalances();
    _filterBalances(list);
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Anchor Balances'),
          bottom: PreferredSize(
              child: Column(
                children: [
                  Text(
                    anchor == null ? "Loading..." : anchor.name,
                    style: Styles.blackBoldMedium,
                  ),
                  SizedBox(
                    height: 40,
                  )
                ],
              ),
              preferredSize: Size.fromHeight(100)),
        ),
        backgroundColor: Colors.brown[100],
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView.builder(
              itemCount: _balances.length,
              itemBuilder: (context, index) {
                var bal = _balances.elementAt(index);
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.money,
                            color: Theme.of(context).primaryColor,
                          ),
                          title: Row(
                            children: [
                              Text(
                                bal.assetCode == null ? "XLM" : bal.assetCode,
                                style: Styles.blackBoldMedium,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(bal.balance),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              Text('Issuer'),
                              SizedBox(
                                height: 0,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 60, right: 60),
                                child: Text(
                                  bal.assetIssuer == null
                                      ? ""
                                      : bal.assetIssuer,
                                  style: Styles.greyLabelTiny,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
