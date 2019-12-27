import 'package:flutter/material.dart';
import './homepage.dart';

void main() {
  runApp(Start());
}

class Start extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "RemindME",
      debugShowCheckedModeBanner: false,
      home: new Container(
        child: HomePage(),
      ),
    );
  }
}