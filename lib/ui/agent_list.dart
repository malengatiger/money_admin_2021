import 'package:flutter/material.dart';
import 'package:money_library_2021/bloc/agent_bloc.dart';
import 'package:money_library_2021/models/agent.dart';
import 'package:money_library_2021/models/anchor.dart';
import 'package:money_library_2021/util/functions.dart';
import 'package:money_library_2021/util/prefs.dart';
import 'package:money_library_2021/util/util.dart';
import 'package:money_library_2021/widgets/avatar.dart';
import 'package:money_library_2021/widgets/round_number.dart';
import 'package:page_transition/page_transition.dart';

import 'agent_details.dart';
import 'agent_editor.dart';

class AgentList extends StatefulWidget {
  @override
  _AgentListState createState() => _AgentListState();
}

class _AgentListState extends State<AgentList>
    with SingleTickerProviderStateMixin {
  AnimationController animController;
  Animation animation, animation2;
  bool productionMode = false;
  bool isBusy;

  @override
  void initState() {
    super.initState();
    _setProductionStatus();
    _setAnimation();
    _refresh(false);
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }

  _setProductionStatus() async {
    productionMode = await isProductionMode();
  }

  _setAnimation() {
    animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    animation = Tween(begin: 0.0, end: 1.0).animate(animController);
    animation2 = Tween(begin: 1.0, end: 0.0).animate(animController);
    animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        p(".......... 💦 💦 💦 Forward Animation completed");
      }
    });
  }

  List<Agent> _agents = [];
  Anchor _anchor;

  _refresh(bool refresh) async {
    p('🥦 AgentList: refresh base data: getAgents 🥦 🥦 🥦  ...');
    setState(() {
      isBusy = true;
    });
    _anchor = await Prefs.getAnchor();
    if (_anchor != null) {
      _agents = await agentBloc.getAgents(
          anchorId: _anchor.anchorId, refresh: refresh);
      setState(() {
        isBusy = false;
      });
    }
  }

  _navigateToAgentDetails(Agent agent) {
    p("🚈 _navigateToAgentDetails ...");
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.scale,
            curve: Curves.easeInOut,
            duration: Duration(seconds: 2),
            child: AgentDetail(
              agent: agent,
            )));
  }

  _navigateToAgentEditor({Agent agent}) {
    p("🚈 🔆 🔆 _navigateToAgentDetails ...");
    Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.scale,
          alignment: Alignment.centerRight,
          duration: Duration(seconds: 1),
          child: AgentEditor(
            agent: agent,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        bottom: PreferredSize(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        _anchor == null ? '' : _anchor.name,
                        style: Styles.blackBoldMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            preferredSize: Size.fromHeight(60)),
        elevation: 0,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                agentBloc.getAgents(anchorId: _anchor.anchorId, refresh: true);
              }),
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _navigateToAgentEditor();
              }),
        ],
        title: Text(
          "Agent List",
          style: Styles.blackSmall,
        ),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 48.0),
            child: StreamBuilder<List<Agent>>(
                stream: agentBloc.agentStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    _agents = snapshot.data;
                  }

                  return ListView.builder(
                      itemCount: _agents.length,
                      itemBuilder: (context, index) {
                        var mAgent = _agents.elementAt(index);
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20, top: 12),
                          child: GestureDetector(
                            onTap: () {
                              _navigateToAgentDetails(mAgent);
                            },
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                  boxShadow: customShadow, color: baseColor),
                              child: ListTile(
                                leading: RoundAvatar(
                                  path: mAgent.url == null
                                      ? 'assets/logo/logo.png'
                                      : mAgent.url,
                                  radius: mAgent.url == null ? 20 : 48,
                                  fromNetwork:
                                      mAgent.url == null ? false : true,
                                ),
                                title: Text(
                                  _agents
                                      .elementAt(index)
                                      .personalKYCFields
                                      .getFullName(),
                                  style: Styles.blackSmall,
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                }),
          ),
          Positioned(
              right: 16,
              top: 8,
              child: RoundNumberWidget(
                number: _agents.length,
                radius: 60,
                margin: 12,
                marginColor: Colors.blue[200],
                mainColor: Colors.pink[200],
                textStyle: Styles.whiteBoldSmall,
              )),
          isBusy
              ? Positioned(
                  left: 20,
                  top: 8,
                  child: Container(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.black,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  double left = 40.0, bottom, top = 40, right;
  bool isUp = true;

  _moveUp() {
    setState(() {
      left = 40;
      bottom = 60;
    });
  }

  _moveDown() {
    setState(() {
      left = 40;
      bottom = 40;
    });
  }
}
