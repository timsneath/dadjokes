import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:share/share.dart';

import 'package:dadjokes/jokeserver.dart';
import 'package:dadjokes/joke.dart';

// Theme constants
const appName = 'Dad Jokes';

const jokeTextStyle = TextStyle(
    fontFamily: 'Patrick Hand',
    fontSize: 36,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal);

const dadJokesBlue = Color(0xFF5DBAF4);

// We store the joke as global state so it can be used in other places. We
// could create a BLoC, but that really seems a little overkill for this
// lightweight app.
Joke theJoke;

void main() => runApp(DadJokesApp());

class DadJokesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: appName,
        theme:
            ThemeData(primaryColor: dadJokesBlue, brightness: Brightness.light),
        home: MainPage(title: appName),
      );
}

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  Future<Joke> joke;

  @override
  initState() {
    super.initState();
    joke = JokeServer().fetchJoke();
  }

  _refreshAction() {
    setState(() {
      joke = JokeServer().fetchJoke();
    });
  }

  _aboutAction() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text('About Dad Jokes'),
            content:
                Text('Dad jokes is brought to you by Tim Sneath (@timsneath), '
                    'proud dad of Naomi, Esther, and Silas. May your children '
                    'groan like mine do.\n\nDad jokes come from '
                    'https://icanhazdadjoke.com with thanks.'),
          );
        });
  }

  _shareAction() {
    Share.share(theJoke.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset(
          'assets/icon.png',
          fit: BoxFit.scaleDown,
        ),
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            tooltip: 'About Dad Jokes',
            onPressed: _aboutAction,
          ),
          IconButton(
            icon: Icon(Icons.share),
            tooltip: 'Share joke',
            onPressed: _shareAction,
          )
        ],
      ),
      body: Center(
        child: SafeArea(
          child: JokeWidget(
            joke: joke,
            refreshCallback: _refreshAction,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _refreshAction,
        icon: Icon(Icons.mood),
        label: Text('NEW JOKE'),
      ),
    );
  }
}

class JokeWidget extends StatelessWidget {
  final Future<Joke> joke;
  final refreshCallback;

  JokeWidget({Key key, this.joke, this.refreshCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Joke>(
      future: JokeServer().fetchJoke(),
      builder: (BuildContext context, AsyncSnapshot<Joke> snapshot) {
        // We have a joke
        if (snapshot.hasData) {
          theJoke = snapshot.data;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Dismissible(
              key: const Key("joke"),
              direction: DismissDirection.horizontal,
              onDismissed: (direction) {
                refreshCallback();
              },
              child: AutoSizeText(
                snapshot.data.body,
                style: jokeTextStyle,
              ),
            ),
          );
        }

        // Something went wrong
        else if (snapshot.hasError) {
          return const Center(
            child: ListTile(
              leading: Icon(Icons.error),
              title: Text('Network error'),
              subtitle:
                  Text('Sorry - this isn\'t funny, we know, but our jokes '
                      'come directly from the Internet for maximum freshness. '
                      'We can\'t reach the server: network issues, perhaps?'),
            ),
          );
        }

        return CircularProgressIndicator();
      },
    );
  }
}
