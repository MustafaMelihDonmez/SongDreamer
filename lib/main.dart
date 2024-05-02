import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:songdreamer_project00/MainPage.dart';
import 'package:songdreamer_project00/MusicListTab.dart';
import 'package:songdreamer_project00/LoginPage.dart';
import 'package:flutter/services.dart';
import 'package:songdreamer_project00/SignUpPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyArQzITX68X5AqxarmWzaXBpFX0a4GFrU4",
      appId: "1:347593107092:android:5d02891ebd2f00c9a93681",
      messagingSenderId: "347593107092",
      projectId: "songdreamer-5541a",
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      routes: {
        '\loginPage': (ctx) => LoginPage(),
        '\signUpPage': (ctx) => SignUpPage(),
        '\mainPage': (ctx) => MainPage(),
        '\musicListTab': (ctx) => MusicListTab(),
      },
    );
  }
}
