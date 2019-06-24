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
    fontWeight: FontWeight.normal,
    color: Color(0xFF222222));

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
        theme: ThemeData(
          primaryColor: dadJokesBlue,
          brightness: Brightness.dark,
        ),
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
      backgroundColor: dadJokesBlue,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Image.asset(
                "assets/title-image.png",
                fit: BoxFit.fitWidth,
                filterQuality: FilterQuality.high,
              ),
            ),
            Expanded(
              child: Center(
                child: JokeWidget(
                  joke: joke,
                  refreshCallback: _refreshAction,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color(0xFFBAE2FC),
        onPressed: _refreshAction,
        label: Text(
          'New Joke',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
          ),
        ),
        icon: Icon(Icons.mood),
        elevation: 2.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.info),
                onPressed: _aboutAction,
                tooltip: 'About $appName'),
            IconButton(
                icon: Icon(Icons.share),
                onPressed: _shareAction,
                tooltip: 'Share joke'),
          ],
        ),
        // shape: CircularNotchedRectangle(),
        color: Color(0xFF118DDE),
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
