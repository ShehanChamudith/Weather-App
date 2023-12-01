// main.dart
import 'package:flutter/material.dart';
import 'mainscreen.dart';
import 'splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(), // Use MainScreen with an uppercase 'M'
    );
  }
}


