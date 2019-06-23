import 'dart:convert';

import 'package:dadjokes/joke.dart';
import 'package:http/http.dart' as http;

class JokeServer {
  final dadJokeApi = "https://icanhazdadjoke.com/";
  final httpHeaders = const {
    'User-Agent': 'DadJokes (https://github.com/timsneath/dadjokes)',
    'Accept': 'application/json',
  };

  Future<Joke> fetchJoke() async {
    final response = await http.get(dadJokeApi, headers: httpHeaders);

    if (response.statusCode == 200) {
      return Joke.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load joke");
    }
  }
}
