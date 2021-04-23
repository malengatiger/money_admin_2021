import 'dart:math';

import 'package:money_library_2021/api/anchor_db.dart';
import 'package:money_library_2021/bloc/agent_bloc.dart';
import 'package:money_library_2021/models/agent.dart';
import 'package:money_library_2021/models/anchor.dart';
import 'package:money_library_2021/util/util.dart';

class FakeImages {
  static List<Agent> agents = [];
  static Anchor? anchor;
  static List<String> images = [];
  static const mm = '🔵 🔵 🔵 🔵 🔵 🔵 FakeImages: ';

  static Future start() async {
    p('$mm starting fake images ....');
    _loadImages();
    await _getData();
    _match();
    return null;
  }

  static Future _getData() async {
    p('$mm getting data agents and anchor  ....');
    anchor = await agentBloc.getAnchor();
    if (anchor == null) {
      p('$mm 😡 😡 😡 No anchor found, quitting ...');
      throw Exception('No anchor');
    }
    agents =
        await agentBloc.getAgents(anchorId: anchor!.anchorId, refresh: true);
  }

  static void _loadImages() {
    p('$mm loading fake assets/ images ....');
    images.add('assets/images/m1.jpeg');
    images.add('assets/images/m2.jpeg');
    images.add('assets/images/m3.jpeg');
    images.add('assets/images/m4.jpeg');
    images.add('assets/images/m5.jpeg');
    images.add('assets/images/m6.jpeg');
    images.add('assets/images/m7.jpeg');
    images.add('assets/images/m8.jpeg');
    images.add('assets/images/m9.jpeg');
    images.add('assets/images/m10.jpeg');
    images.add('assets/images/m11.jpeg');
    images.add('assets/images/m12.jpeg');
    images.add('assets/images/m13.jpeg');
    images.add('assets/images/m14.jpeg');
    images.add('assets/images/m15.jpeg');
    images.add('assets/images/m16.jpeg');
    images.add('assets/images/m17.jpeg');
    images.add('assets/images/m18.jpeg');
    images.add('assets/images/m19.jpeg');
    images.add('assets/images/m20.jpeg');
    images.add('assets/images/m21.jpeg');
    images.add('assets/images/m22.jpeg');
    images.add('assets/images/m23.jpeg');
    images.add('assets/images/m24.jpeg');
    images.add('assets/images/m25.jpeg');
    images.add('assets/images/m26.jpeg');
    images.add('assets/images/m27.jpeg');
    images.add('assets/images/m28.jpeg');
    images.shuffle();
  }

  static void _match() async {
    p('$mm matching images to agents ....');
    Random random = Random(DateTime.now().millisecondsSinceEpoch);

    agents.forEach((agent) async {
      if (agent.url == null) {
        var index = random.nextInt(images.length - 1);
        agent.url = images.elementAt(index);
        agent.fakeImage = true;
        p('$mm about to update agent, 😡 😡 😡 😡 😡 😡 check url and fakeImage : .... ${agent.toJson()}');
        await AnchorLocalDB.addAgent(agent);
        index++;
      }
    });
    p('$mm  🎁 DONE!  🎁 matching images to agents ....');
  }
}
