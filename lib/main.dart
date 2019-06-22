import 'package:flutter/material.dart';
import 'mainPage.dart';

const String appName = 'Dad Jokes';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: MainPage(title: appName),
    );
  }
}
