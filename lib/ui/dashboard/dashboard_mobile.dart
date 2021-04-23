import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_admin_2021/ui/agent_list.dart';
import 'package:money_admin_2021/ui/chart/fiat_payment_chart.dart';
import 'package:money_admin_2021/ui/chart/path_payment_chart.dart';
import 'package:money_admin_2021/ui/mobile/account_transactions_mobile.dart';
import 'package:money_library_2021/bloc/agent_bloc.dart';
import 'package:money_library_2021/models/agent.dart';
import 'package:money_library_2021/models/anchor.dart';
import 'package:money_library_2021/models/client.dart';
import 'package:money_library_2021/models/fiat_payment_request.dart';
import 'package:money_library_2021/models/path_payment_request.dart';
import 'package:money_library_2021/models/stellar_account_bag.dart';
import 'package:money_library_2021/util/functions.dart';
import 'package:money_library_2021/util/prefs.dart';
import 'package:money_library_2021/util/theme.dart';
import 'package:money_library_2021/util/util.dart';
import 'package:page_transition/page_transition.dart';

class DashboardMobile extends StatefulWidget {
  @override
  _DashboardMobileState createState() => _DashboardMobileState();
}

class _DashboardMobileState extends State<DashboardMobile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Animation<double>? _animation;
  var isBusy = false;
  List<Agent>? _agents = <Agent>[];
  List<Client>? _clients = <Client>[];
  var _fiatPayments = <StellarFiatPaymentResponse>[];
  List<PathPaymentRequest>? _pathPayments = <PathPaymentRequest>[];

  Anchor? anchor;
  StellarAccountBag? bag;
  static const mm = ' 🔵 🔵 🔵 🔵 🔵 🔵 DashboardMobile: ';

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    _animation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _getAdmin();
    _setItems();
    // _listen();
  }

  void _animate() {
    _controller.forward();
  }

  void _getAdmin() async {
    setState(() {
      isBusy = true;
    });
    anchor = await Prefs.getAnchor();
    setState(() {
      isBusy = false;
    });
    prettyPrint(anchor!.toJson(), "$mm ANCHOR");
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
    p('\n\n\n$mm Getting a lot of data ................................ forceRefresh: $forceRefresh \n\n');
    setState(() {
      isBusy = true;
    });

    if (agentBloc == null) agentBloc = AgentBloc();
    _agents = await agentBloc.getAgents(
        anchorId: anchor!.anchorId, refresh: forceRefresh);
    _toggleState();
    _clients = await agentBloc.getAnchorClients(
        anchorId: anchor!.anchorId, refresh: forceRefresh);
    _toggleState();

    DateTime to = DateTime.now();
    DateTime from = to.subtract(Duration(days: 30));

    _pathPayments = await agentBloc.getPathPaymentRequestsByAnchor(
        anchorId: anchor!.anchorId,
        fromDate: from.toIso8601String(),
        toDate: to.toIso8601String(),
        refresh: forceRefresh);
    _toggleState();
    _fiatPayments = await agentBloc.getFiatPaymentResponsesByAnchor(
        anchorId: anchor!.anchorId,
        fromDate: from.toIso8601String(),
        toDate: to.toIso8601String(),
        refresh: forceRefresh);
    _toggleState();
    bag = await agentBloc.getBalances(
        accountId: anchor!.distributionStellarAccount!.accountId,
        refresh: forceRefresh);

    p('$mm Finished getting a lot of data ....  🍎 🍎 agents: ${_agents!.length} '
        'clients: ${_clients!.length}  🍎 balances: ${bag!.balances!.length}  🍎 _pathPayments: ${_pathPayments!.length}');
    setState(() {
      isBusy = false;
    });
  }

  void _toggleState() {
    setState(() {
      isBusy = false;
    });
    setState(() {
      isBusy = true;
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
            preferredSize: Size.fromHeight(50),
            child: Column(
              children: [
                Text(
                  anchor == null ? '' : anchor!.name!,
                  //chango, ericaOne
                  style: GoogleFonts.modak(
                    textStyle: TextStyle(color: Colors.grey[400], fontSize: 24),
                  ),
                ),
                // SizedBox(
                //   height: 8,
                // ),
                // Text(
                //   'Anchor Administrator',
                //   style: Styles.blackTiny,
                // ),
                SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
        ),
        backgroundColor: secondaryColor,
        // bottomNavigationBar: BottomNavigationBar(
        //   items: items,
        //   onTap: ((m) {}),
        // ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView(
                children: [
                  Container(
                    height: 130,
                    child: GridView.count(
                      crossAxisCount: 3,
                      children: [
                        Container(
                          child: GestureDetector(
                            onTap: _navigateToAgents,
                            child: Card(
                              elevation: 4,
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
                                        return isBusy
                                            ? Center(
                                                child: Container(
                                                  height: 16,
                                                  width: 16,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    backgroundColor:
                                                        Colors.black,
                                                  ),
                                                ),
                                              )
                                            : Text(
                                                '${_agents!.length}',
                                                style: _agents!.length < 10000
                                                    ? Styles.blackBoldLarge
                                                    : Styles.blackBoldMedium,
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
                              elevation: 4,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  StreamBuilder<List<Client>>(
                                      stream: agentBloc.clientStream,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData)
                                          _clients = snapshot.data;
                                        return isBusy
                                            ? Center(
                                                child: Container(
                                                  height: 16,
                                                  width: 16,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    backgroundColor:
                                                        Colors.black,
                                                  ),
                                                ),
                                              )
                                            : Text(
                                                '${_clients!.length}',
                                                style: _fiatPayments.length <
                                                        10000
                                                    ? Styles.blackBoldLarge
                                                    : Styles.blackBoldMedium,
                                              );
                                      }),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    'Clients',
                                    style: Styles.greyLabelSmall,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: GestureDetector(
                            onTap: _navigateToTransactions,
                            child: Card(
                              elevation: 4,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  StreamBuilder<List<PathPaymentRequest>>(
                                      stream: agentBloc.pathPaymentStream,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData)
                                          _pathPayments = snapshot.data;
                                        return isBusy
                                            ? Center(
                                                child: Container(
                                                  height: 16,
                                                  width: 16,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    backgroundColor:
                                                        Colors.black,
                                                  ),
                                                ),
                                              )
                                            : Text(
                                                '${_pathPayments!.length}',
                                                style: _pathPayments!.length <
                                                        10000
                                                    ? Styles.blackBoldLarge
                                                    : Styles.blackBoldMedium,
                                              );
                                      }),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    'Path Payments',
                                    style: Styles.greyLabelSmall,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  isBusy ? Container() : FiatPaymentChart(),
                  SizedBox(
                    height: 12,
                  ),
                  isBusy ? Container() : PathPaymentChart(),
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

  onClose() {
    ScaffoldMessenger.of(_key.currentState!.context).removeCurrentSnackBar();
  }

  void _navigateToAgents() {
    p("🚈 _navigateToAgents ...");
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.scale,
            curve: Curves.easeInOut,
            duration: Duration(seconds: 2),
            child: AgentList()));
  }

  void _navigateToPayments() {
    p("🚈 _navigateToPayments ...");
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.scale,
            curve: Curves.easeInOut,
            duration: Duration(seconds: 2),
            child: AccountTransactionsMobile(
              accountId: anchor!.distributionStellarAccount!.accountId,
            )));
  }

  void _navigateToTransactions() {
    p("🚈 _navigateToTransactions ...");
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.scale,
            curve: Curves.easeInOut,
            duration: Duration(seconds: 2),
            child: AccountTransactionsMobile(
              accountId: anchor!.distributionStellarAccount!.accountId,
            )));
  }
}
