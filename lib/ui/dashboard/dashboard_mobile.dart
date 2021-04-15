import 'package:flutter/material.dart';
import 'package:money_library_2021/bloc/agent_bloc.dart';
import 'package:money_library_2021/models/agent.dart';
import 'package:money_library_2021/models/anchor.dart';
import 'package:money_library_2021/models/payment_dto.dart';
import 'package:money_library_2021/models/stellar_account_bag.dart';
import 'package:money_library_2021/models/transaction_dto.dart';
import 'package:money_library_2021/ui/charts/payments_line_chart.dart';
import 'package:money_library_2021/util/functions.dart';
import 'package:money_library_2021/util/prefs.dart';
import 'package:money_library_2021/util/theme.dart';
import 'package:money_library_2021/util/util.dart';

class DashboardMobile extends StatefulWidget {
  @override
  _DashboardMobileState createState() => _DashboardMobileState();
}

class _DashboardMobileState extends State<DashboardMobile>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  var isBusy = false;
  var _agents = <Agent>[];
  var _balances = <Balance>[];
  var _payments = <PaymentDTO>[];
  var _transactions = <TransactionDTO>[];
  var _videos = <Anchor>[];
  Anchor anchor;
  StellarAccountBag bag;
  static const mm = ' 🔵 🔵 🔵 🔵 🔵 🔵 DashboardMobile: ';

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    _getAdmin();
    _setItems();
    // _listen();
  }

  void _getAdmin() async {
    anchor = await Prefs.getAnchor();
    _refresh(false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  var items = <BottomNavigationBarItem>[];
  void _setItems() {
    items
        .add(BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Users'));
    items.add(
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Projects'));
    // items.add(
    //     BottomNavigationBarItem(icon: Icon(Icons.send), label: 'Reports'));
  }

  void _refresh(bool forceRefresh) async {
    p('$mm Getting a lot of data ....');
    setState(() {
      isBusy = true;
    });
    _agents = await agentBloc.getAgents(
        anchorId: anchor.anchorId, refresh: forceRefresh);
    _payments = await agentBloc.getPayments(
        accountId: anchor.distributionStellarAccount.accountId,
        refresh: forceRefresh);
    _transactions = await agentBloc.getTransactions(
        accountId: anchor.distributionStellarAccount.accountId,
        refresh: forceRefresh);
    bag = await agentBloc.getBalances(
        accountId: anchor.distributionStellarAccount.accountId,
        refresh: forceRefresh);
    p('$mm Finished getting a lot of data ....  🍎 🍎 '
        'payments: ${_payments.length}  🍎 balances: ${bag.balances.length}');
    setState(() {
      isBusy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _key,
        appBar: AppBar(
          backgroundColor: secondaryColor,
          elevation: 0,
          actions: [
            IconButton(
                icon: Icon(
                  Icons.credit_card,
                  color: Colors.black,
                  size: 20,
                ),
                onPressed: () {}),
            IconButton(
                icon: Icon(
                  Icons.info_outline,
                  color: Colors.black,
                  size: 20,
                ),
                onPressed: () {}),
            IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.black,
                size: 20,
              ),
              onPressed: () {
                themeBloc.changeToRandomTheme();
              },
            ),
            IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.black,
                size: 20,
              ),
              onPressed: () {
                _refresh(true);
              },
            )
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(80),
            child: Column(
              children: [
                Text(
                  anchor == null ? '' : anchor.name,
                  style: Styles.blackBoldMedium,
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Anchor Administrator',
                  style: Styles.blackTiny,
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
        backgroundColor: secondaryColor,
        bottomNavigationBar: BottomNavigationBar(
          items: items,
          onTap: ((m) {}),
        ),
        body: isBusy
            ? Center(
                child: Container(
                  height: 48,
                  width: 48,
                  child: CircularProgressIndicator(
                    strokeWidth: 8,
                    backgroundColor: Colors.teal,
                  ),
                ),
              )
            : Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ListView(
                      children: [
                        Container(
                          height: 100,
                          child: GridView.count(
                            crossAxisCount: 3,
                            children: [
                              Container(
                                child: GestureDetector(
                                  onTap: _navigateToAgents,
                                  child: Card(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 20,
                                        ),
                                        StreamBuilder<List<Agent>>(
                                            stream: agentBloc.agentStream,
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData)
                                                _agents = snapshot.data;
                                              return Text(
                                                '${_agents.length}',
                                                style: Styles.blackBoldLarge,
                                              );
                                            }),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          'Agents',
                                          style: Styles.greyLabelSmall,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: GestureDetector(
                                  onTap: _navigateToPayments,
                                  child: Card(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 16,
                                        ),
                                        StreamBuilder<List<PaymentDTO>>(
                                            stream: agentBloc.paymentStream,
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData)
                                                _payments = snapshot.data;
                                              return Text(
                                                '${_payments.length}',
                                                style: Styles.blackBoldLarge,
                                              );
                                            }),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          'Payments',
                                          style: Styles.greyLabelSmall,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: Card(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 16,
                                      ),
                                      StreamBuilder<List<TransactionDTO>>(
                                          stream: agentBloc.transactionStream,
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData)
                                              _transactions = snapshot.data;
                                            return Text(
                                              '${_transactions.length}',
                                              style: Styles.blackBoldLarge,
                                            );
                                          }),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        'Transactions',
                                        style: Styles.greyLabelSmall,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        anchor == null
                            ? Container()
                            : PaymentsLineChart(
                                anchor.distributionStellarAccount.accountId),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // void _handleBottomNav(int value) {
  //   switch (value) {
  //     case 0:
  //       pp(' 🔆🔆🔆 Navigate to MonitorList');
  //       _navigateToUserList();
  //       break;
  //     case 1:
  //       pp(' 🔆🔆🔆 Navigate to ProjectList');
  //       _navigateToProjectList();
  //       break;
  //     case 2:
  //       pp(' 🔆🔆🔆 Navigate to MediaList');
  //       _navigateToMediaList();
  //       break;
  //   }
  // }
  //
  // void _navigateToMediaList() {
  //   Navigator.push(
  //       context,
  //       PageTransition(
  //           type: PageTransitionType.scale,
  //           alignment: Alignment.topLeft,
  //           duration: Duration(seconds: 1),
  //           child: MediaListMain(null)));
  // }
  //
  // void _navigateToUserList() {
  //   Navigator.push(
  //       context,
  //       PageTransition(
  //           type: PageTransitionType.scale,
  //           alignment: Alignment.topLeft,
  //           duration: Duration(seconds: 1),
  //           child: UserListMain()));
  // }
  //
  // void _navigateToProjectList() {
  //   Navigator.push(
  //       context,
  //       PageTransition(
  //           type: PageTransitionType.scale,
  //           alignment: Alignment.topLeft,
  //           duration: Duration(seconds: 1),
  //           child: ProjectListMain(widget.user)));
  // }
  //
  // void _navigateToIntro() {
  //   Navigator.push(
  //       context,
  //       PageTransition(
  //           type: PageTransitionType.scale,
  //           alignment: Alignment.topLeft,
  //           duration: Duration(seconds: 1),
  //           child: IntroMain(
  //             user: widget.user,
  //           )));
  // }
  //
  // void _navigateToCreditCard() {
  //   Navigator.push(
  //       context,
  //       PageTransition(
  //           type: PageTransitionType.scale,
  //           alignment: Alignment.topLeft,
  //           duration: Duration(seconds: 1),
  //           child: CreditCardHandlerMain(
  //             user: widget.user,
  //           )));
  // }
  //
  // void _listen() async {
  //   var android = UniversalPlatform.isAndroid;
  //   var ios = UniversalPlatform.isIOS;
  //
  //   if (android || ios) {
  //     pp('DashboardMobile: 🍎 🍎 _listen to FCM message streams ... 🍎 🍎');
  //     fcmBloc.projectStream.listen((Project project) async {
  //       if (mounted) {
  //         pp('DashboardMobile: 🍎 🍎 showProjectSnackbar: ${project.name} ... 🍎 🍎');
  //         _projects = await monitorBloc.getOrganizationProjects(
  //             organizationId: _user.organizationId, forceRefresh: false);
  //         setState(() {});
  //         SpecialSnack.showProjectSnackbar(
  //             scaffoldKey: _key,
  //             textColor: Colors.white,
  //             backgroundColor: Theme.of(context).primaryColor,
  //             project: project,
  //             listener: this);
  //       }
  //     });
  //     fcmBloc.userStream.listen((User user) async {
  //       if (mounted) {
  //         pp('DashboardMobile: 🍎 🍎 showUserSnackbar: ${user.name} ... 🍎 🍎');
  //         _users = await monitorBloc.getOrganizationUsers(
  //             organizationId: _user.organizationId, forceRefresh: false);
  //         setState(() {});
  //         SpecialSnack.showUserSnackbar(
  //             scaffoldKey: _key, user: user, listener: this);
  //       }
  //     });
  //     fcmBloc.photoStream.listen((Photo photo) async {
  //       if (mounted) {
  //         pp('DashboardMobile: 🍎 🍎 showPhotoSnackbar: ${photo.userName} ... 🍎 🍎');
  //         _photos = await monitorBloc.getOrganizationPhotos(
  //             organizationId: _user.organizationId, forceRefresh: false);
  //         setState(() {});
  //         SpecialSnack.showPhotoSnackbar(
  //             scaffoldKey: _key, photo: photo, listener: this);
  //       }
  //     });
  //     fcmBloc.videoStream.listen((Video video) async {
  //       if (mounted) {
  //         pp('DashboardMobile: 🍎 🍎 showVideoSnackbar: ${video.userName} ... 🍎 🍎');
  //         _videos = await monitorBloc.getOrganizationVideos(
  //             organizationId: _user.organizationId, forceRefresh: false);
  //         SpecialSnack.showVideoSnackbar(
  //             scaffoldKey: _key, video: video, listener: this);
  //       }
  //     });
  //     fcmBloc.messageStream.listen((mon.OrgMessage message) {
  //       if (mounted) {
  //         pp('DashboardMobile: 🍎 🍎 showMessageSnackbar: ${message.message} ... 🍎 🍎');
  //
  //         SpecialSnack.showMessageSnackbar(
  //             scaffoldKey: _key, message: message, listener: this);
  //       }
  //     });
  //   } else {
  //     pp('App is running on the Web 👿 👿 👿  firebase messaging is OFF 👿 👿 👿');
  //   }
  // }

  var _key = GlobalKey<ScaffoldState>();
  static const BLUE =
      '🔵 🔵 🔵 DashboardMain:  🦠  🦠  🦠 FCM message arrived:  🦠 ';

  @override
  onClose() {
    ScaffoldMessenger.of(_key.currentState.context).removeCurrentSnackBar();
  }

  void _navigateToAgents() {}

  void _navigateToPayments() {}
}
