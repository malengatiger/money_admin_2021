import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_library_2021/api/net.dart';
import 'package:money_library_2021/models/payment_dto.dart';
import 'package:money_library_2021/models/stellar_account_bag.dart';
import 'package:money_library_2021/util/functions.dart';
import 'package:money_library_2021/util/image_handler/currency_icons.dart';
import 'package:money_library_2021/util/util.dart';

class AccountTransactionsMobile extends StatefulWidget {
  final String accountId;

  const AccountTransactionsMobile({Key key, this.accountId}) : super(key: key);
  @override
  _AccountTransactionsMobileState createState() =>
      _AccountTransactionsMobileState();
}

class _AccountTransactionsMobileState extends State<AccountTransactionsMobile>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  List<PaymentDTO> payments = [];
  StellarAccountBag stellarAccountBag;
  bool busy;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    _getData();
  }

  void _getData() async {
    p('🌼 🌼 🌼 Getting account payments and balances  ....');
    setState(() {
      busy = true;
    });
    payments = await NetUtil.getAccountPayments(widget.accountId);
    stellarAccountBag = await NetUtil.getAccountBalances(widget.accountId);
    p('🌼 🌼 🌼 Payments found: ${payments.length} balances: ${stellarAccountBag.balances.length}');
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
          elevation: 0,
          title: Text(
            'Account Balances & Payments',
            style: Styles.blackTiny,
          ),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: Colors.black,
                  size: 16,
                ),
                onPressed: _getData)
          ],
          backgroundColor: secondaryColor,
        ),
        backgroundColor: secondaryColor,
        body: busy
            ? Center(
                child: Container(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 6,
                  ),
                ),
              )
            : ListView(
                children: [
                  SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 28.0),
                    child: Text(
                      "Account Balances",
                      style: Styles.blackBoldMedium,
                    ),
                  ),
                  Container(
                    height: 300,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView.builder(
                          itemCount: stellarAccountBag == null
                              ? 0
                              : stellarAccountBag.balances.length,
                          itemBuilder: (context, index) {
                            var bal =
                                stellarAccountBag.balances.elementAt(index);
                            return Card(
                              elevation: 4,
                              child: ListTile(
                                leading: Image.asset(
                                  CurrencyIcons.getCurrencyImagePath(
                                      bal.assetCode),
                                  scale: 4,
                                ),
                                title: Row(
                                  children: [
                                    Text(
                                      bal.assetCode == null
                                          ? "XLM"
                                          : bal.assetCode,
                                      style: Styles.blackBoldSmall,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      bal.balance,
                                      style: Styles.blackBoldSmall,
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 28.0),
                    child: Text(
                      "Account Payments",
                      style: Styles.blackBoldMedium,
                    ),
                  ),
                  Container(
                    height: 400,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView.builder(
                          itemCount: payments.length,
                          itemBuilder: (context, index) {
                            var pay = payments.elementAt(index);
                            return Card(
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          width: 40,
                                          child: Text(
                                            pay.asset_code,
                                            style: Styles.blackBoldSmall,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          pay.amount,
                                          style: Styles.tealBoldMedium,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 100,
                                            ),
                                            Image.asset(
                                              CurrencyIcons
                                                  .getCurrencyImagePath(
                                                      pay.asset_code),
                                              scale: 4,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 40,
                                          child: Text(
                                            "From: ",
                                            style: Styles.greyLabelTiny,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Flexible(
                                          fit: FlexFit.tight,
                                          child: Text(
                                            pay.from,
                                            style: Styles.blackTiny,
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 40,
                                          child: Text(
                                            "To: ",
                                            style: Styles.greyLabelTiny,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Flexible(
                                          fit: FlexFit.loose,
                                          child: Text(
                                            pay.to,
                                            style: Styles.blackTiny,
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 40,
                                          child: Text(
                                            "Date: ",
                                            style: Styles.greyLabelTiny,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          getFormattedDateShortWithTime(
                                              pay.created_at, context),
                                          style: Styles.blackBoldSmall,
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
