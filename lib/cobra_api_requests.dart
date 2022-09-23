import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_assistant/backend.dart';

Future<List<String>> cobraApiSearch(String query) async {
  if (query.toLowerCase().trim() == 'weather') {
    try {
      query = 'weather at ${await getLocation()}';
    } on Exception catch (e) {
      return ['Location error or location permission denied', e.toString()];
    }
  }
  query.replaceAll('+', '%2B');
  var request = await http
      .get(Uri.parse('https://cobra-api.herokuapp.com/search?query=$query'));
  var data = jsonDecode(request.body);
  String wolframalphaAnswers = '';
  List temp = data['wolframalpha answers'] as List;
  for (var element in temp) {
    wolframalphaAnswers = wolframalphaAnswers + '\n$element';
  }
  temp = data['wikipedia answers']['search'] as List;
  String wikipediaSearch = '';
  for (var element in temp) {
    wikipediaSearch = wikipediaSearch + '\n$element';
  }
  return [
    'wolframalpha answers :-',
    wolframalphaAnswers,
    'wikipedia page results:-',
    'Page title : ${data['wikipedia answers']['page']['title']}',
    'Page summary : ${data['wikipedia answers']['page']['summary']}',
    'Page content : ${data['wikipedia answers']['page']['content']}',
    'wikipedia search results:- ',
    wikipediaSearch
  ];
}
