import 'dart:io';
import 'package:device_apps/device_apps.dart';
import 'package:path_provider/path_provider.dart';

List<Application> apps = [];
bool loaded = false;
List<String> names = [];
List<Map<String, dynamic>> randomizerGroups = [];
List<String> hidden = [];
List<Application> allAvailableApps = [];

Future<void> load(Function callback) async {
  apps = await DeviceApps.getInstalledApplications(
      includeSystemApps: true,
      onlyAppsWithLaunchIntent: true,
      includeAppIcons: true);
  loaded = true;
  apps.sort(
      (a, b) => a.appName.toLowerCase().compareTo(b.appName.toLowerCase()));
  allAvailableApps = apps.toList();
  loadNames();
  callback();
}

void loadNames() {
  for (var element in apps) {
    names.add(element.appName);
  }
}

Future<void> loadRandomizerGroups() async {
  Directory directory = await getApplicationDocumentsDirectory();
  String path = directory.path;

  randomizerGroups = [];
  try {
    File file = File(path + 'content.json');
    var data = await file.readAsString();
    data.substring(1, data.length - 1).split('}, {').forEach((element) {
      var mapping = element.replaceAll('{', '').replaceAll('}', '').split(':');
      Map<String, dynamic> map = {};
      List<dynamic> temp = [];
      mapping[1].split(', ').forEach((element) {
        temp.add(element.replaceAll('[', '').replaceAll(']', ''));
      });
      map[mapping[0]] = temp;
      randomizerGroups.add(map);
    });
  } catch (exceptions) {
    randomizerGroups = [];
  }
}

void hide() async {
  List<Application> temp = apps.toList();
  for (var element1 in temp) {
    for (var element in hidden) {
      if (element.toLowerCase().trim() ==
          element1.appName.toLowerCase().trim()) {
        apps.remove(element1);
      }
    }
  }
  var directory = await getApplicationDocumentsDirectory();
  String path = directory.path;

  File file = File(path + 'hidden.json');
  file.writeAsString(hidden.toString());
}

Future<void> loadHidden() async {
  var directory = await getApplicationDocumentsDirectory();
  String path = directory.path;

  File file = File(path + 'hidden.json');
  if (await file.exists()) {
    String data = await file.readAsString();
    hidden = [];
    data.split(', ').forEach((element) {
      hidden.add(element.replaceAll('[', '').replaceAll(']', ''));
    });
  }
}

void uninstallApp(Application app) async {
  app.openSettingsScreen();
}
