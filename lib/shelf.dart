// ignore_for_file: prefer_const_constructors

import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:my_assistant/applications.dart';

class Shelf extends StatefulWidget {
  const Shelf({Key? key}) : super(key: key);

  @override
  _ShelfState createState() => _ShelfState();
}

class _ShelfState extends State<Shelf> {
  void callback() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Builder(builder: (context) {
          if (loaded) {
            List<Application> allApps = apps;
            return GridView.count(
              physics: BouncingScrollPhysics(),
              crossAxisCount: 4,
              children: List.generate(allApps.length, (index) {
                return GestureDetector(
                    onTap: () {
                      DeviceApps.openApp(allApps[index].packageName);
                    },
                    onLongPress: () async {
                      await allApps[index].openSettingsScreen();
                      load(callback);
                    },
                    child: Column(
                      children: [
                        Image.memory(
                          (allApps[index] as ApplicationWithIcon).icon,
                          width: 32,
                        ),
                        Text(
                          allApps[index].appName,
                          style: TextStyle(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ));
              }),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        }));
  }
}
