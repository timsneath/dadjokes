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

  _about() {
    final aboutDialog = new AlertDialog(
      title: new Text('About Dad Jokes'),
      content: new Text('This app is brought to you by Tim Sneath (@timsneath), proud parent of Naomi, Esther, and Silas. May your children groan like mine will.'),
    );
    showDialog(context: context, child: aboutDialog);
    }

  void _share() {
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
                      return new Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: new Text(decoded['joke'],
                              style: Theme.of(context).textTheme.display1));
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
