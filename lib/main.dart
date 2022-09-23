// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:my_assistant/app_activity_detector.dart';
import 'package:my_assistant/home_page.dart';
import 'package:my_assistant/porcupine_listener.dart';
import 'package:my_assistant/tts_command.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding.instance!
      .addObserver(AppActivityDetector(detachCallback: detachCallback()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    initSpeaker();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: const MyHomePage(),
    );
  }
}

detachCallback() {
  onDetachPorcupine();
}
