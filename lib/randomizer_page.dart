// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_assistant/applications.dart';
import 'package:my_assistant/random_app_editing.dart';
import 'package:my_assistant/randomizer_list.dart';
import 'package:path_provider/path_provider.dart';

class RandomizerPage extends StatefulWidget {
  const RandomizerPage({Key? key}) : super(key: key);

  @override
  _RandomizerPageState createState() => _RandomizerPageState();
}

class _RandomizerPageState extends State<RandomizerPage> {
  List<Map<String, dynamic>> groups = [];

  @override
  void initState() {
    super.initState();
    groups = randomizerGroups;
  }

  void click() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RandomAppEditing(
                  callback: callback,
                  delete: delete,
                )));
  }

  void save() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path;

    File file = File(path + 'content.json');
    file.writeAsString(groups.toString());
    randomizerGroups = groups;
  }

  void delete(String? name) {
    if (name != null) {
      int index = 0;
      bool found = false;
      for (var element in groups) {
        if (element.keys.single == name) {
          found = true;
          return;
        }
        index++;
      }
      if (found) {
        groups.removeAt(index);
        setState(() {});
      }
    }
    save();
  }

  void callback(String name, List<dynamic> items) {
    groups.add({name: items});
    setState(() {});
    save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Expanded(
                child: ListView.builder(
                    itemCount: groups.length,
                    itemBuilder: (context, index) {
                      return RandomizerList(
                          groups[index].keys.single,
                          groups[index][groups[index].keys.single],
                          delete,
                          save);
                    })),
            Align(
                alignment: Alignment.center,
                child: TextButton(
                    onPressed: click,
                    child: Text(
                      'Add new group',
                      style: TextStyle(color: Colors.green),
                    ))),
          ],
        ));
  }
}
