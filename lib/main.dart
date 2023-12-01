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
      home: AppWrapper(), // Use the AppWrapper widget to transition from splash screen to main screen
    );
  }
}

class AppWrapper extends StatefulWidget {
  const AppWrapper({Key? key}) : super(key: key);

  @override
  _AppWrapperState createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  @override
  void initState() {
    super.initState();
    _loadSplashScreen();
  }

  void _loadSplashScreen() async {
    await Future.delayed(const Duration(seconds: 2)); // Adjust the duration as needed
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => MainScreen()), // Replace with your main screen widget
    );
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(); // Show the splash screen initially
  }
}
