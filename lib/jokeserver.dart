import 'dart:convert';

import 'package:dadjokes/joke.dart';
import 'package:http/http.dart' as http;

class JokeServer {
  final dadJokeApi = 'https://icanhazdadjoke.com/';
  final httpHeaders = const {
    'User-Agent': 'DadJokes (https://github.com/timsneath/dadjokes)',
    'Accept': 'application/json',
  };

  Future<Joke> fetchJoke() async {
    try {
      final response = await http.get(dadJokeApi, headers: httpHeaders);
      if (response.statusCode == 200) {
        return Joke.fromJson(json.decode(response.body));
      } else {
        return Joke(body: 'Failed to load joke.', id: '', status: 500);
      }
    } catch (exception) {
      return Joke(body: 'Network error occurred.', id: '', status: 500);
    }
  }
}
