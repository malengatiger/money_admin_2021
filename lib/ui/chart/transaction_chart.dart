import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:money_library_2021/bloc/agent_bloc.dart';
import 'package:money_library_2021/models/anchor.dart';
import 'package:money_library_2021/models/transaction_dto.dart';
import 'package:money_library_2021/util/functions.dart';
import 'package:money_library_2021/util/prefs.dart';
import 'package:money_library_2021/util/util.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TransactionChart extends StatefulWidget {
  final String accountId;

  const TransactionChart({Key key, this.accountId}) : super(key: key);
  @override
  _TransactionChartState createState() => _TransactionChartState();
}

class _TransactionChartState extends State<TransactionChart>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  List<TransactionDTO> _transactions = [];
  bool busy = false;
  Anchor _anchor;
  static const mm = 'TransactionChart: 👽 👽 👽 👽 ';

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    _getData(false);
  }

  void _getData(bool refresh) async {
    p('$mm Getting data: anchor and payments ...');
    setState(() {
      busy = true;
    });
    _anchor = await Prefs.getAnchor();
    _transactions = await agentBloc.getTransactions(
        accountId: widget.accountId, refresh: refresh);
    p('$mm transactions found:  🍎 ${_transactions.length}  🍎');
    _wrangleTransactions();
    setState(() {
      busy = false;
    });
  }

  void _wrangleTransactions() {
    //create aggregations ....
    _transactions.sort((a, b) => a.created_at.compareTo(b.created_at));
    final SplayTreeMap<int, Map<int, int>> splayTreeMap =
        SplayTreeMap<int, Map<int, int>>();
    Map<int, int> map = HashMap();
    _transactions.forEach((p) {
      DateTime date = DateTime.parse(p.created_at);
      int day = date.day;
      int totalForToday = map[day];
      if (totalForToday == null) totalForToday = 0;
      int count = totalForToday + 1;
      map[day] = count;
      Map<int, int> mm = Map();
      mm[day] = count;
      splayTreeMap[day] = mm;
    });

    data.clear();
    splayTreeMap.forEach((key, value) {
      p('🍎 🍎 🍎 🍎 🍎 🍎 splayTreeMap Key: $key value: $value');
      var mCount = value[key];
      data.add(_TransactionData('$key', double.parse('$mCount')));
    });
    data.add(_TransactionData('17', double.parse('20.0')));
    data.add(_TransactionData('18', double.parse('24.0')));
    data.add(_TransactionData('19', double.parse('26.0')));
    data.add(_TransactionData('20', double.parse('30.0')));
    data.add(_TransactionData('21', double.parse('26.0')));
    data.add(_TransactionData('22', double.parse('30.0')));
    data.add(_TransactionData('23', double.parse('24.0')));
    data.add(_TransactionData('24', double.parse('25.0')));
    data.add(_TransactionData('25', double.parse('12.0')));
    data.add(_TransactionData('26', double.parse('26.0')));
    data.add(_TransactionData('27', double.parse('35.0')));
    data.add(_TransactionData('28', double.parse('38.0')));
    data.add(_TransactionData('29', double.parse('32.0')));
    data.add(_TransactionData('30', double.parse('52.0')));
    data.add(_TransactionData('31', double.parse('34.0')));
    data.add(_TransactionData('32', double.parse('40.0')));
    data.forEach((element) {
      p(' 👽 👽 👽 👽 ${element.toString()}');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<_TransactionData> data = [];
  @override
  Widget build(BuildContext context) {
    return busy
        ? Center(
            child: Container(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 6,
              ),
            ),
          )
        : Stack(
            children: [
              Card(
                elevation: 4,
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  // Chart title
                  title: ChartTitle(
                      text: 'Daily Transactions',
                      textStyle: Styles.blackBoldMedium),
                  // Enable legend
                  legend: Legend(isVisible: true),
                  // Enable tooltip
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <ChartSeries<_TransactionData, String>>[
                    LineSeries<_TransactionData, String>(
                        dataSource: data,
                        xValueMapper: (_TransactionData sales, _) => sales.day,
                        yValueMapper: (_TransactionData sales, _) =>
                            sales.transactions,
                        name: '',
                        color: Theme.of(context).primaryColor,
                        markerSettings: MarkerSettings(isVisible: true),
                        // Enable data label
                        dataLabelSettings: DataLabelSettings(isVisible: true))
                  ],
                ),
              ),
            ],
          );
  }
}

class _TransactionData {
  final String day;
  final double transactions;
  _TransactionData(this.day, this.transactions);

  toString() {
    return '$day - $transactions';
  }
}
