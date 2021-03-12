import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:money_admin_2021/ui/intro/intro_main.dart';
import 'package:money_library_2021/util/util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
  await Firebase.initializeApp();
  p('🔵 🔵 🔵 Firebase initialized ....');
  await DotEnv.load(fileName: '.env');
  p('🍎 🍎 🍎 DotEnv has been loaded - this is so cool! ');
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: IntroMain(),
    );
  }
}
