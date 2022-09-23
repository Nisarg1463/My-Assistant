// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:my_assistant/applications.dart';
import 'package:my_assistant/backend.dart';
import 'package:my_assistant/cobra_api_requests.dart';
import 'package:my_assistant/contact.dart';
import 'package:my_assistant/text_scroll_widget.dart';
import 'package:url_launcher/url_launcher.dart';

Future<Widget?> search(String input) async {
  bool isApp = false;
  int index = 0;
  for (var element in apps) {
    if (element.appName.toLowerCase().trim() == input.toLowerCase().trim()) {
      isApp = true;
    }
    if (!isApp) {
      index++;
    }
  }
  if (isApp) {
    apps[index].openApp();
    return null;
  }

  if (input.toLowerCase().contains('search')) {
    bool falseAlarm = true;
    int start = input.indexOf('search');
    if (input.toLowerCase().contains(' on ')) {
      int end = input.lastIndexOf(' on ');
      String query = input.substring(start + 7, end);
      String website = input.toLowerCase().substring(end + 3);
      print(website);
      if (website.trim() == 'google') {
        launch('https://www.google.com/search?q=$query');
        falseAlarm = false;
      } else if (website.trim() == 'youtube') {
        launch('https://www.youtube.com/results?search_query=$query');
        falseAlarm = false;
      } else if (website.trim() == 'spotify') {
        query = query.replaceAll(' ', '%20');
        launch('spotify:search:$query');
        falseAlarm = false;
      } else if (website.trim() == 'playstore' ||
          website.trim() == 'play store') {
        query = query.replaceAll(' ', '%20');
        print(query);
        launch('https://play.google.com/store/search?q=$query');
        falseAlarm = false;
      } else if (website.trim() == 'map') {
        try {
          var location = await getLocation();
          launch('https://www.google.com/maps/search/$query+/@$location,15z');
          falseAlarm = false;
        } on Exception catch (e) {
          print('permissionDenied' + e.toString());
        }
      }
    }
    if (!falseAlarm) {
      return null;
    }
    String query = input.substring(start + 7);
    return TextScrollWidget(await cobraApiSearch(query));
  } else if (input.toLowerCase().contains('open chat')) {
    launch('https://www.instagram.com/direct/inbox/');
  }
}
