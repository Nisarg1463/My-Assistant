// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_assistant/applications.dart';
import 'package:my_assistant/backend.dart';
import 'package:my_assistant/config_list.dart';
import 'package:my_assistant/contact.dart';
import 'package:my_assistant/porcupine_listener.dart';
import 'package:my_assistant/randomizer_page.dart';
import 'package:my_assistant/search.dart';
import 'package:my_assistant/shelf.dart';
import 'package:my_assistant/speech_to_text_recognition.dart';
import 'package:my_assistant/text_scroll_widget.dart';
import 'package:my_assistant/tts_command.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget mainScreen = Container();
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    await initSpeaker();
    await load(callback);
    await getBattery(callback);
    await getContacts();
    await loadRandomizerGroups();
    await loadHidden();
    await speak('Setup Complete');
    hide();
    // voiceDemo();
  }

  Future<void> initListening() async {
    await initializeSpeech(click);
    await initializePorcupine(voiceInputFeedback, setStateCallback);
    startListeningNotifications();
  }

  Future<void> stopLoad() async {
    stopPorcupine();
    stopListeningNotification();
  }

  void setStateCallback() {
    setState(() {});
  }

  void callback() {
    setState(() {});
  }

  void voiceInputFeedback(SpeechRecognitionResult result) {
    setState(() {
      controller.text = result.recognizedWords;
      click();
    });
  }

  final controller = TextEditingController();
  void click() async {
    String command = controller.text.toLowerCase().trim();
    if (command.trim() == 'shelf') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Shelf()));
    } else if (command.contains('apps')) {
      if (command.contains('-st ')) {
        String appname =
            controller.text.substring(controller.text.indexOf('-st ') + 4);
        for (var element in apps) {
          if (element.appName.toLowerCase() == appname.toLowerCase()) {
            element.openSettingsScreen();
          }
        }
      } else if (command.contains('-ps')) {
        String appname =
            controller.text.substring(controller.text.indexOf('-ps ') + 4);
        for (var element in apps) {
          if (element.appName.toLowerCase() == appname.toLowerCase()) {
            launch(
                'https://play.google.com/store/apps/details?id=${element.packageName}');
          }
        }
      } else if (command.contains('--hide')) {
        hide();
      } else if (command.contains('--show')) {
        apps = allAvailableApps.toList();
        setState(() {});
      }
    } else if (command.indexOf('call') == 0) {
      int start = command.indexOf('call ');
      String contact = command.substring(start + 5);
      if (!permissionDenied) {
        print(contacts);
        for (var element in contacts) {
          print(1);
          if (contact.toLowerCase().trim() ==
              element.displayName!.toLowerCase().trim()) {
            launch('tel:${element.phones![0].value}');
          }
        }
      }
    } else if (command.indexOf('randomizer') == 0) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => RandomizerPage()));
    } else if (command.indexOf('random ') == 0) {
      for (var element in randomizerGroups) {
        if (controller.text
                .substring(controller.text.indexOf('.random ') + 8) ==
            element.keys.single) {
          List randomApps = element[controller.text
              .substring(controller.text.indexOf('.random ') + 8)] as List;
          randomApps.shuffle(Random(DateTime.now().microsecondsSinceEpoch));
          search(randomApps[0]);
        }
      }
    } else if (command.indexOf('config') == 0) {
      if (command.contains('-hidden')) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConfigList((List<String> items) {
                      hidden = items;
                      hide();
                      setState(() {});
                    }, hidden)));
      } else if (command.contains('notifications')) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConfigList((List<String> items) {
                      allowedApps = items;
                      setState(() {});
                    }, allowedApps)));
      }
    } else if (command.indexOf('uninstall') == 0) {
      String name = command.substring(command.indexOf('uninstall') + 10);
      for (var element in apps) {
        if (element.appName.toLowerCase() == name) {
          uninstallApp(element);
        }
      }
    } else if (command.indexOf('reset ai') == 0) {
      initListening();
    } else if (command.indexOf('stop ai') == 0) {
      stopLoad();
    } else if (command.trim() == 'help') {
      mainScreen = TextScrollWidget(
        [
          'shelf',
          'apps: \n\t -st(settings page) \n\t -ps(playstore page)',
          'call',
          'randomizer',
          'random {groupname}',
          'reset ai',
          '{app name}',
          'search ... on {google|youtube|spotify|map}',
          'search ...',
          'config {notifications}',
          'uninstall {app name}'
        ],
      );
    } else {
      mainScreen = await search(controller.text) ?? Container();
    }
    setState(() {});
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/images/wallpaper.jpg'),
          fit: BoxFit.cover,
        )),
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.only(top: 35),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      Icons.circle,
                      color: porcupineOn ? Colors.green : Colors.red,
                    ))),
            Expanded(child: mainScreen),
            TextField(
                style: TextStyle(color: Colors.green),
                controller: controller,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(100, 30, 30, 30),
                  suffixIcon: IconButton(
                    onPressed: click,
                    icon: const Icon(
                      Icons.arrow_forward,
                      color: Colors.green,
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
