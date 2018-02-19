import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';

const dadJokeApi = "https://icanhazdadjoke.com/";
const httpHeaders = const {
  'User-Agent': 'DadJokes (https://github.com/timsneath/dadjokes)',
  'Accept': 'application/json',
};

const jokeTextStyle = const TextStyle(
    fontFamily: 'Patrick Hand',
    fontSize: 34.0,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal);

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  MainPageState createState() => new MainPageState();
}

class MainPageState extends State<MainPage> {
  Future<String> _response;
  String _displayedJoke = '';

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

  _about() {
    final aboutDialog = new AlertDialog(
      title: new Text('About Dad Jokes'),
      content: new Text(
          'Dad jokes is brought to you by Tim Sneath (@timsneath), proud dad '
          'of Naomi, Esther, and Silas. May your children groan like mine '
          'will.\n\nDad jokes come from https://icanhazdadjoke.com with '
          'thanks.'),
    );
    showDialog(context: context, child: aboutDialog);
  }

  _share() async {
    if (_displayedJoke != '') {
      await share(_displayedJoke);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.info),
            tooltip: 'About Dad Jokes',
            onPressed: _about,
          ),
          new IconButton(
            icon: new Icon(Icons.share),
            tooltip: 'Share joke',
            onPressed: _share,
          )
        ],
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new FutureBuilder<String>(
              future: _response,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return new Icon(Icons.sync_problem);
                  case ConnectionState.waiting:
                    return new Center(child: new CircularProgressIndicator());
                  default:
                    final decoded = JSON.decode(snapshot.data);
                    if (decoded['status'] == 200) {
                      _displayedJoke = decoded['joke'];
                      return new Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: new Dismissible(
                            key: new Key("joke"),
                            direction: DismissDirection.horizontal,
                            onDismissed: (direction) { _refresh(); },
                            child:
                                new Text(_displayedJoke, style: jokeTextStyle),
                          ));
                    } else {
                      return new Icon(Icons.error);
                    }
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _refresh,
        tooltip: 'New joke',
        child: new Icon(Icons.refresh),
      ),
    );
  }
}
