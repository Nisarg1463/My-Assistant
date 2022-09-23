import 'package:my_assistant/speech_to_text_recognition.dart';
import 'package:my_assistant/tts_command.dart';
import 'package:porcupine_flutter/porcupine_manager.dart';

var accessKey = 'Qyi+ldncsqHPT3dASY8Zu9WlX0hWslPiMauaq9bYcfgT7U2a6DKyEQ==';
PorcupineManager? porcupineManager;
bool porcupineOn = false;
late Function setStateCallback;

Future<void> initializePorcupine(
    Function callback, Function setStateCallbackFun) async {
  setStateCallback = setStateCallbackFun;
  porcupineManager = await PorcupineManager.fromKeywordPaths(
      accessKey, ['assets/cobra_android_v2.0.0/cobra_en_android_v2_0_0.ppn'],
      (keywordIndex) async {
    await speak('listening');
    await porcupineManager!.stop();
    porcupineOn = false;
    setStateCallbackFun();
    startRecognition(callback, startPorcupine);
  });
  startPorcupine();
}

void startPorcupine() {
  if (porcupineManager != null) {
    porcupineManager!.start();
    porcupineOn = true;
    setStateCallback();
  }
}

void stopPorcupine() {
  if (porcupineManager != null) {
    porcupineManager!.stop();
    porcupineOn = false;
    setStateCallback();
  }
}

void onDetachPorcupine() {
  if (porcupineManager != null) {
    porcupineManager!.delete();
    porcupineOn = false;
  }
}

void resetPorcupine() {
  speak('reset complete');
  startPorcupine();
}
