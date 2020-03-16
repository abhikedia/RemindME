import 'package:flutter/material.dart';
import './utils/global.dart';
import './homepage.dart';

void main() {

  runApp(Start());
}

class Start extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/home': (context) => HomePage(),
      },
      title: "RemindME",
      debugShowCheckedModeBanner: false,
      home: new Container(
        child: HomePage(),
      ),
    );
  }
}