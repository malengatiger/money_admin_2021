import 'package:flutter/material.dart';
import 'package:money_library_2021/models/stellar_account_bag.dart';

class AccountBalancesMobile extends StatefulWidget {
  @override
  _AccountBalancesMobileState createState() => _AccountBalancesMobileState();
}

class _AccountBalancesMobileState extends State<AccountBalancesMobile>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  List<Balance> _balances;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  void _getData() async {}

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
