import 'package:flutter/material.dart';
import 'package:money_library_2021/models/agent.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'mobile/mobile_agent_detail.dart';

class AgentDetail extends StatefulWidget {
  final Agent? agent;

  const AgentDetail({Key? key, this.agent}) : super(key: key);
  @override
  _AgentDetailState createState() => _AgentDetailState();
}

class _AgentDetailState extends State<AgentDetail> {
  @override
  Widget build(BuildContext context) {
    if (widget.agent == null) {
      throw Exception('👿👿 Agent is null');
    }
    return ScreenTypeLayout(
      mobile: AgentDetailMobile(widget.agent),
    );
  }
}
