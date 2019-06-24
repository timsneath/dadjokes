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

const uiTextStyle = TextStyle(fontFamily: 'Poppins');

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
          return AlertDialog(
            title: Text('About Dad Jokes'),
            titleTextStyle: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
            ),
            content:
                Text('Dad jokes is brought to you by Tim Sneath (@timsneath), '
                    'proud dad of Naomi, Esther, and Silas. May your children '
                    'groan like mine do.\n\nDad jokes come from '
                    'https://icanhazdadjoke.com, with thanks.'),
            contentTextStyle: uiTextStyle,
            actions: <Widget>[
              FlatButton.icon(
                icon: Icon(Icons.done),
                label: Text('Done'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
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
            Align(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                "assets/title-image.png",
                fit: BoxFit.fitWidth,
                filterQuality: FilterQuality.high,
              ),
            ),

            // JOKE
            Expanded(
              child: Container(
                padding: EdgeInsets.all(5),
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: Color(0x55FFFFFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  child: Center(
                    child: JokeWidget(
                      joke: joke,
                      refreshCallback: _refreshAction,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // NEW JOKE BUTTON
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

      // APP BAR
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.info),
              label: Text('About', style: uiTextStyle),
              onPressed: _aboutAction,
            ),
            FlatButton.icon(
              icon: Icon(Icons.share),
              label: Text('Share', style: uiTextStyle),
              onPressed: _shareAction,
            ),
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
      future: joke,
      builder: (BuildContext context, AsyncSnapshot<Joke> snapshot) {
        // We have a joke
        if (snapshot.hasData) {
          theJoke = snapshot.data;
          return Padding(
            padding: const EdgeInsets.all(8),
            child: AutoSizeText(
              snapshot.data.body,
              style: jokeTextStyle,
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

        // We're still just loading
        else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
