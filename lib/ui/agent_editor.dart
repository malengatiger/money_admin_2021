import 'package:flutter/material.dart';
import 'package:money_library_2021/models/agent.dart';
import 'package:money_library_2021/util/functions.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'mobile/mobile_agent_editor.dart';

class AgentEditor extends StatefulWidget {
  final Agent agent;

  const AgentEditor({Key key, this.agent}) : super(key: key);
  @override
  _AgentEditorState createState() => _AgentEditorState();
}

class _AgentEditorState extends State<AgentEditor> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Agent Editor',
                style: Styles.whiteSmall,
              ),
              backgroundColor: Colors.brown[100],
              bottom: PreferredSize(
                  child: Column(
                    children: <Widget>[
                      Text(
                        widget.agent == null
                            ? ''
                            : widget.agent.personalKYCFields.getFullName(),
                        style: Styles.blackBoldMedium,
                      ),
                      SizedBox(
                        height: 40,
                      )
                    ],
                  ),
                  preferredSize: Size.fromHeight(100)),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ScreenTypeLayout(
                mobile: AgentEditorMobile(agent: widget.agent),
              ),
            )));
  }
}
