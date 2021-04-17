import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:money_library_2021/bloc/agent_bloc.dart';
import 'package:money_library_2021/models/anchor.dart';
import 'package:money_library_2021/models/payment_dto.dart';
import 'package:money_library_2021/util/functions.dart';
import 'package:money_library_2021/util/prefs.dart';
import 'package:money_library_2021/util/util.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PaymentChart extends StatefulWidget {
  final String accountId;

  const PaymentChart({Key key, this.accountId}) : super(key: key);
  @override
  _PaymentChartState createState() => _PaymentChartState();
}

class _PaymentChartState extends State<PaymentChart>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  List<PaymentDTO> _payments = [];
  bool busy = false;
  Anchor _anchor;
  static const mm = '🔵 🔵 🔵 PaymentChart: 👽 👽 👽 👽 ';

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
    _payments = await agentBloc.getPayments(
        accountId: widget.accountId, refresh: refresh);
    p('$mm payments found:  🍎 ${_payments.length}  🍎');
    _wrangleTransactions();
    setState(() {
      busy = false;
    });
  }

  void _wrangleTransactions() {
    //create aggregations ....
    _payments.sort((a, b) => a.created_at.compareTo(b.created_at));
    final SplayTreeMap<int, Map<int, int>> splayTreeMap =
        SplayTreeMap<int, Map<int, int>>();
    Map<int, int> map = HashMap();
    _payments.forEach((p) {
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
      data.add(_PaymentData('$key', double.parse('$mCount')));
    });
    data.add(_PaymentData('17', double.parse('12.0')));
    data.add(_PaymentData('18', double.parse('24.0')));
    data.add(_PaymentData('19', double.parse('16.0')));
    data.add(_PaymentData('20', double.parse('16.0')));
    data.add(_PaymentData('21', double.parse('26.0')));
    data.add(_PaymentData('22', double.parse('30.0')));
    data.add(_PaymentData('23', double.parse('24.0')));
    data.add(_PaymentData('24', double.parse('25.0')));
    data.add(_PaymentData('25', double.parse('12.0')));
    data.add(_PaymentData('26', double.parse('26.0')));
    data.add(_PaymentData('27', double.parse('25.0')));
    data.add(_PaymentData('28', double.parse('28.0')));
    data.add(_PaymentData('29', double.parse('24.0')));
    data.add(_PaymentData('30', double.parse('22.0')));
    data.add(_PaymentData('31', double.parse('20.0')));
    data.add(_PaymentData('32', double.parse('16.0')));
    data.forEach((element) {
      p(' 👽 👽 👽 👽 ${element.toString()}');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<_PaymentData> data = [];
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
                      text: 'Daily Payments',
                      textStyle: Styles.blackBoldMedium),
                  // Enable legend
                  legend: Legend(isVisible: true),
                  // Enable tooltip
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <ChartSeries<_PaymentData, String>>[
                    LineSeries<_PaymentData, String>(
                        dataSource: data,
                        xValueMapper: (_PaymentData sales, _) => sales.day,
                        yValueMapper: (_PaymentData sales, _) => sales.payments,
                        name: '',
                        color: Colors.purple,
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

class _PaymentData {
  final String day;
  final double payments;
  _PaymentData(this.day, this.payments);

  toString() {
    return '$day - $payments';
  }
}
