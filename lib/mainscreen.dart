import 'package:flutter/material.dart';
import 'package:mad_weather_app/services/weather_service.dart';
import 'dart:async';
import 'dart:convert';
import 'package:mad_weather_app/services/weather_service.dart';

import 'model/weather.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  WeatherService weatherService = WeatherService();
  Weather weather = Weather();

  String currentWeather = "";
  double tempC = 0;
  double tempF = 0;

  @override
  void initState() {
    super.initState();
    getWeather();
  }

  void getWeather() async {
    weather = await weatherService.getWeatherData("Neluwa");

    setState(() {
      currentWeather = weather.condition;
      tempF = weather.temperatureF;
      tempC = weather.temperatureC;
    });
    print(weather.temperatureC);
    print(weather.temperatureF);
    print(weather.condition);
  }

  @override
  Widget build(BuildContext context) {

    final currentWidth = MediaQuery.of(context).size.width;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final appBarHeight = 56.0;

    return Scaffold(


      body: Stack(
        children: [

          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Column(
            children: [
              SizedBox(height: 50.0), // Add some vertical space
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0), // Add margin from right and left
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1), // Set background color and decrease opacity
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search for City',
                          border: InputBorder.none, // Remove border
                          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                        ),
                        style: TextStyle(
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        // Handle search button press
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),



          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(currentWeather),
                Text(tempC.toString()),
                Text(tempF.toString()),
              ],
            ),
          ),
        ],
      ),
    );
  }

}