import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

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
  Future<String> _response;

  @override
  initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() {
      _response = http.read(dadJokeApi, headers: httpHeaders);
    });
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
                future: _response,
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return new Icon(Icons.sync_problem);
                    case ConnectionState.waiting:
                      return new Center(child: new CircularProgressIndicator());
                    default:
                      final decoded = JSON.decode(snapshot.data);

                      if (decoded['status'] == 200) {
                        return new Text(decoded['joke'],
                          style: Theme.of(context).textTheme.display1);
                      } else {
                        return new Icon(Icons.error);

                      }
                  }
                }),
            new RaisedButton(
              onPressed: _refresh,
              child: new Text('New Joke'),
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _refresh,
        tooltip: 'Share',
        child: new Icon(Icons.share),
      ),
    );
  }
}
