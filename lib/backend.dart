import 'dart:async';

import 'package:battery/battery.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_assistant/applications.dart';
import 'package:my_assistant/tts_command.dart';
import 'package:notifications/notifications.dart';

int battery = 0;
late Notifications notifications;
late StreamSubscription<NotificationEvent> subscription;
List<String> allowedApps = ['Instagram', 'WhatsApp'];
Map<String, String> packagename = {};
NotificationEvent lastEvent = NotificationEvent();

Future<void> getBattery(Function callback) async {
  battery = await Battery().batteryLevel;
  callback();
}

Future<String> getLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
  var location = await Geolocator.getCurrentPosition();
  return location.toString();
}

void startListeningNotifications() {
  notifications = Notifications();
  try {
    subscription =
        notifications.notificationStream!.listen(onNotificationListen);
  } on Exception catch (exception) {
    print(exception);
  }
  for (var app in allAvailableApps) {
    if (allowedApps.contains(app.appName)) {
      packagename[app.packageName] = app.appName;
    }
  }
}

void stopListeningNotification() {
  subscription.cancel();
}

void onNotificationListen(NotificationEvent event) {
  try {
    if (packagename.keys.contains(event.packageName)) {
      if (lastEvent.message != event.message ||
          lastEvent.title != event.title) {
        speak(
            'New Notification from ${event.title} and content is ${event.message}');
        lastEvent = event;
      }
    }
  } on Exception catch (e) {
    print(e);
  }
}
