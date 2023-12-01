// splash_screen.dart
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.indigo, Colors.blueAccent], // Adjust the colors as needed
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Your splash screen content, e.g., app logo or animation
              Image.asset(
                'images/thunder.png', // Replace with your splash screen image asset
                width: 150.0,
                height: 150.0,
              ),
              SizedBox(height: 16.0),
              Text(
                'Weather Buddy',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,fontFamily: 'Poppins'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
