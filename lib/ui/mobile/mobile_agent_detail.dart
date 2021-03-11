import 'package:flutter/material.dart';
import 'package:money_library_2021/bloc/agent_bloc.dart';
import 'package:money_library_2021/models/agent.dart';
import 'package:money_library_2021/models/anchor.dart';
import 'package:money_library_2021/models/balances.dart';
import 'package:money_library_2021/models/client.dart';
import 'package:money_library_2021/util/functions.dart';
import 'package:money_library_2021/util/image_handler/random_image.dart';
import 'package:money_library_2021/util/prefs.dart';
import 'package:money_library_2021/util/util.dart';
import 'package:money_library_2021/widgets/agent_widgets.dart';
import 'package:money_library_2021/widgets/avatar.dart';
import 'package:money_library_2021/widgets/balances_scroller.dart';
import 'package:money_library_2021/widgets/contact_widgets.dart';

class AgentDetailMobile extends StatefulWidget {
  final Agent agent;
  const AgentDetailMobile(this.agent);

  @override
  _AgentDetailMobileState createState() => _AgentDetailMobileState();
}

class _AgentDetailMobileState extends State<AgentDetailMobile> {
  bool weAreInProduction = false;
  List<Balances> balancesList = List();
  Balances currentBalances;
  List<Client> clients = [];
  String path;
  bool isBusy = false;
  AnchorUser anchorUser;

  @override
  void initState() {
    super.initState();
    _setup();
  }

  _setup() async {
    weAreInProduction = await isProductionMode();
    anchorUser = await Prefs.getAnchorUser();
    path = RandomImage.getImagePath();
    clients = await agentBloc.getClients(
        agentId: widget.agent.agentId, refresh: false);
    currentBalances =
        await agentBloc.getLocalBalances(widget.agent.stellarAccountId);
    if (mounted) {
      setState(() {});
    }
    currentBalances =
        await agentBloc.getRemoteBalances(widget.agent.stellarAccountId);
    if (mounted) {
      setState(() {});
    }
  }

  String getPath() {
    path = RandomImage.getImagePath();
    if (weAreInProduction) {
      if (widget.agent.url == null) {
        return 'assets/logo/logo.png';
      } else {
        return widget.agent.url;
      }
    } else {
      if (widget.agent.url != null) {
        return widget.agent.url;
      }
      return path;
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = 440.0;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor,
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.attach_money,
                  color: Colors.black,
                ),
                onPressed: () {
                  // Navigator.push(
                  //     context,
                  //     PageTransition(
                  //         type: PageTransitionType.scale,
                  //         curve: Curves.easeInOut,
                  //         duration: Duration(seconds: 2),
                  //         child: AgentFunder(
                  //           agent: widget.agent,
                  //         )));
                }),
            IconButton(
                icon: Icon(
                  Icons.create,
                  color: Colors.black,
                ),
                onPressed: () {
                  assert(widget.agent != null);
                  // Navigator.push(
                  //     context,
                  //     PageTransition(
                  //         type: PageTransitionType.scale,
                  //         curve: Curves.easeInOut,
                  //         duration: Duration(seconds: 2),
                  //         child: AgentEditor(
                  //           agent: widget.agent,
                  //         )));
                }),
            IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: Colors.black,
                ),
                onPressed: () {
                  agentBloc.getClients(
                      agentId: widget.agent.agentId, refresh: true);
                  agentBloc.getRemoteBalances(widget.agent.stellarAccountId);
                }),
            IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ],
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: <Widget>[
                  Text(
                    widget.agent.personalKYCFields.getFullName(),
                    style: Styles.blackBoldMedium,
                  ),
                  SizedBox(
                    height: 0,
                  )
                ],
              ),
            ),
          ),
        ),
        backgroundColor: baseColor,
        body: Stack(
          children: <Widget>[
            Positioned(
              left: 20,
              top: 40,
              child: Container(
                width: 320,
                height: 300,
                decoration:
                    BoxDecoration(boxShadow: customShadow, color: baseColor),
                child: ListView(
                  children: <Widget>[
                    SizedBox(
                      height: isBusy ? 10 : 40,
                    ),
                    EmailWidget(
                      emailAddress: widget.agent.personalKYCFields.emailAddress,
                    ),
                    PhoneWidget(
                      phoneNumber: widget.agent.personalKYCFields.mobileNumber,
                    ),
                    GestureDetector(
                      onTap: () {
                        p('🔆 🔆 Refreshing clients .... ');
                        agentBloc.getClients(
                            agentId: widget.agent.agentId, refresh: true);
                      },
                      child: AgentClientsWidget(
                        agent: widget.agent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 200,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: RoundAvatar(
                    path: getPath(),
                    radius: 120,
                    fromNetwork: weAreInProduction),
              ),
            ),
            Positioned(
              left: 20,
              bottom: 80,
              child: Text('Balances'),
            ),
            Positioned(
              left: 20,
              bottom: 20,
              child: Container(
                width: width - 40,
                height: 60,
                decoration:
                    BoxDecoration(boxShadow: customShadow, color: baseColor),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StreamBuilder<List<Balances>>(
                      stream: agentBloc.balancesStream,
                      builder: (context, snapshot) {
                        Balances mBal;
                        if (snapshot.hasData) {
                          p('👽 👽 👽 👽 balances delivered via stream ... 👽 👽 👽 ${snapshot.data}');
                          balancesList = snapshot.data;
                          mBal = balancesList.last;
                        }
                        return Center(
                          child: BalancesScroller(
                            balances: mBal,
                            direction: Axis.horizontal,
                          ),
                        );
                      }),
                ),
              ),
            ),
            isBusy
                ? Positioned(
                    left: 20,
                    top: 0,
                    child: Container(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
