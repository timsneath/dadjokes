import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const dadJokeApi = "https://icanhazdadjoke.com/";
const httpHeaders = const {
  'User-Agent': 'DadJokes (https://github.com/timsneath/dadjokes)',
  'Accept': 'application/json',
};

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  MainPageState createState() => new MainPageState();
}

class MainPageState extends State<MainPage> {
  // String displayedDadJoke = '';

  @override
  initState() {
    super.initState();

    // displayedDadJoke = 'Here';
  }

  Future<String> getNewJoke() async {
    final response = await http.read(dadJokeApi, headers: httpHeaders);
    final decoded = JSON.decode(response);

    if (decoded['status'] == 200) {
      return decoded['joke'];
    } else {
      return 'Error: ${decoded['status']}';
    }
  }

  newJoke() async {
    String newJoke = await getNewJoke();
    // setState(() {
    // displayedDadJoke = newJoke;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new FutureBuilder<String>(
                future: getNewJoke(),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return new Icon(Icons.sync_problem);
                    case ConnectionState.waiting:
                      return new Center(child: new CircularProgressIndicator());
                    default:
                      return new Text(snapshot.data,
                          style: Theme.of(context).textTheme.display1);
                  }
                }),
            new RaisedButton(
              onPressed: () {},
              child: new Text('New Joke'),
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: newJoke,
        tooltip: 'Share',
        child: new Icon(Icons.share),
      ),
    );
  }
}
