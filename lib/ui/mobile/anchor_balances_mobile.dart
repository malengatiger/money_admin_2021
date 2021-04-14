import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_admin_2021/ui/mobile/account_transactions_mobile.dart';
import 'package:money_library_2021/api/net.dart';
import 'package:money_library_2021/models/anchor.dart';
import 'package:money_library_2021/models/stellar_account_bag.dart';
import 'package:money_library_2021/util/functions.dart';
import 'package:money_library_2021/util/prefs.dart';
import 'package:money_library_2021/util/util.dart';
import 'package:page_transition/page_transition.dart';

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
  bool busy = false;

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

  _navigateToAccountTransactions() async {
    p("🚈 🔆 🔆 _navigateToAccountTransactions ...");
    Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.scale,
          alignment: Alignment.centerRight,
          duration: Duration(seconds: 1),
          child: AccountTransactionsMobile(
            accountId: anchor.distributionStellarAccount.accountId,
          ),
        ));
  }

  void _getData() async {
    setState(() {
      busy = true;
    });
    var list = await NetUtil.getAnchorBalances();
    _filterBalances(list);
    setState(() {
      busy = false;
    });
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
          title: Text(
            'Anchor Balances',
            style: Styles.blackSmall,
          ),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: Colors.black,
                ),
                onPressed: _getData)
          ],
          backgroundColor: secondaryColor,
          elevation: 0,
          bottom: PreferredSize(
              child: Column(
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    anchor == null ? "Loading..." : anchor.name,
                    style: Styles.blackBoldMedium,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Assets',
                    style: Styles.blackBoldLarge,
                  ),
                  SizedBox(
                    height: 16,
                  )
                ],
              ),
              preferredSize: Size.fromHeight(120)),
        ),
        backgroundColor: secondaryColor,
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: busy
              ? Center(
                  child: Container(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 6,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: _balances.length,
                  itemBuilder: (context, index) {
                    var bal = _balances.elementAt(index);
                    return GestureDetector(
                      onTap: () {
                        _navigateToAccountTransactions();
                      },
                      child: Card(
                        elevation: 4,
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
                                      bal.assetCode == null
                                          ? "XLM"
                                          : bal.assetCode,
                                      style: Styles.blackBoldMedium,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(bal.balance,
                                        style: Styles.blackBoldSmall),
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
                                      padding: const EdgeInsets.only(
                                          left: 48, right: 48),
                                      child: Text(
                                        bal.assetIssuer == null
                                            ? ""
                                            : bal.assetIssuer,
                                        style: Styles.greyLabelTiny,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
        ),
      ),
    );
  }
}
