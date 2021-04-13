import 'package:flutter/material.dart';
import 'package:money_library_2021/api/net.dart';
import 'package:money_library_2021/util/functions.dart';
import 'package:money_library_2021/util/util.dart';

class FundDistribution extends StatefulWidget {
  @override
  _FundDistributionState createState() => _FundDistributionState();
}

class _FundDistributionState extends State<FundDistribution>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  bool busy = false;
  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    _startFunding();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _startFunding() async {
    p('_startFunding .... ');
    setState(() {
      busy = true;
    });
    result = await NetUtil.get(
        apiRoute: 'fundDistributionAccount?amount=100000', mTimeOut: 9000);
    p('$result');
    setState(() {
      busy = false;
    });
  }

  String result = "";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Distribution Funding'),
        ),
        backgroundColor: Colors.brown[100],
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: busy
              ? Center(
                  child: Container(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 8,
                      )),
                )
              : Center(
                  child: GestureDetector(
                    onTap: () {
                      _startFunding();
                    },
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          result,
                          style: Styles.blackBoldSmall,
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
