import 'package:my_assistant/porcupine_listener.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';

final SpeechToText speech = SpeechToText();
bool isRecognizing = false;
bool hasSpeech = false;

void startRecognition(Function callback, Function startPorcupine) async {
  speech.listen(
      onResult: (result) {
        if (result.finalResult) {
          callback(result);
          startPorcupine();
          print(result.recognizedWords);
        }
      },
      pauseFor: const Duration(seconds: 5),
      listenFor: const Duration(minutes: 2),
      partialResults: true);
}

Future<void> initializeSpeech(Function click) async {
  if (await bluetoothConnectPermission().isGranted) {
    hasSpeech =
        await speech.initialize(onError: (SpeechRecognitionError error) {
      print('Received error status: $error, listening: ${speech.isListening}');
      startPorcupine();
      // click();
    }, onStatus: (String status) {
      print(status);
    });
  } else {
    print('denied');
  }
}

Future<PermissionStatus> bluetoothConnectPermission() async {
  final PermissionStatus permission =
      await Permission.bluetoothConnect.request();
  if (permission != PermissionStatus.granted &&
      permission != PermissionStatus.denied) {
    final Map<Permission, PermissionStatus> permissionStatus =
        await [Permission.contacts].request();
    return permissionStatus[Permission.contacts] ?? PermissionStatus.values[0];
  } else {
    return permission;
  }
}
