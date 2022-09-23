import 'dart:async';

import 'package:flutter_tts/flutter_tts.dart';

late FlutterTts flutterTts;
bool ended = false;

Future<void> initSpeaker() async {
  flutterTts = FlutterTts();
  flutterTts.setStartHandler(() {
    ended = false;
    print('started');
  });
  flutterTts.setCompletionHandler(() {
    print('completed');
    ended = true;
  });
  await flutterTts.setVoice({'name': 'en-au-x-aud-network', 'locale': 'en-AU'});
}

Future<void> speak(String data) async {
  initSpeaker();
  flutterTts.setVolume(1);
  flutterTts.setSpeechRate(0.5);
  flutterTts.speak(data);
  await _waitUntilDone();
}

Future<void> _waitUntilDone() async {
  final completer = Completer();
  if (!ended) {
    await Future.delayed(const Duration(microseconds: 200));
    return _waitUntilDone();
  } else {
    completer.complete();
    ended = false;
  }
  return completer.future;
}

void voiceDemo() async {
  print('1 \n\n\n\n\n');
  var voices = await flutterTts.getVoices;
  for (var i in voices) {
    print(i);
  }
  flutterTts.setVoice({'name': 'en-au-x-aud-network', 'locale': 'en-AU'});
  speak('hello sir how are you doing');
}
