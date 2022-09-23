import 'package:flutter/cupertino.dart';
import 'package:my_assistant/tts_command.dart';

class AppActivityDetector extends WidgetsBindingObserver {
  AppActivityDetector({this.detachCallback});
  final Function? detachCallback;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.detached:
        if (detachCallback != null) {
          detachCallback!();
        }
        break;
      case AppLifecycleState.resumed:
        initSpeaker();
        break;
    }
  }
}
