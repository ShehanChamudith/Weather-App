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
  final TextEditingController _searchController = TextEditingController();
  List<String> _suggestedCities = [];
  String _selectedCity = '';


  String currentWeather = "";
  double tempC = 0;
  double tempF = 0;

  @override
  void initState() {
    super.initState();
    getWeather("Colombo");
  }

  void getWeather(String city) async {
    weather = await weatherService.getWeatherData(city);

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
    return Scaffold(
      backgroundColor: Colors.transparent, // Set background color to transparent
      // appBar: AppBar(
      //   title: Text('Search for city', style: TextStyle(fontFamily: 'Ubuntu', fontSize: 18.0, fontWeight: FontWeight.w600)),
      //   backgroundColor: Colors.transparent, // Set app bar background color to transparent
      //   elevation: 0,
      //   centerTitle: true,
      // ),
      body: Stack(
        children: [
          // Background image
          Image.asset(
            'images/bg.jpg',  // Replace 'background.jpg' with the actual image asset path
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Padding(
            padding: EdgeInsets.only(left: 40.0, top: 60.0, right: 40.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchTextChanged,
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
                    decoration: InputDecoration(
                      hintText: 'Search for City',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(15.0),
                      prefixIcon: Image.asset(
                        'images/search.png',
                        width: 30.0,
                        height: 30.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                _buildSuggestedCities(),
              ],
            ),
          ),
        ],
      ),
    );
  }


  void _onSearchTextChanged(String input) {
    if (input.length >= 1) {
      weatherService.getSuggestedCities(input).then((suggestions) {
        suggestions.sort();

        setState(() {
          _suggestedCities = suggestions.take(5).toList();
        });
      });
    } else {
      setState(() {
        _suggestedCities.clear();
      });
    }
  }

  Widget _buildSuggestedCities() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6), // White container with transparency
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _suggestedCities.map((cityAndCountry) {
          // Split the city and country using a comma as a separator
          List<String> parts = cityAndCountry.split(', ');

          return Column(
            children: [
              ListTile(
                title: Text(
                  parts[0], // Display the city
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
                subtitle: Text(
                  parts.length > 1 ? parts[1] : '', // Display the country if available
                  style: TextStyle(color: Color(0xFF878787)),
                ),
                onTap: () {
                  _onCitySelected(cityAndCountry);
                },
              ),
              Divider(
                color: Color(0xFFe0e0eb),
                height: 1, // Adjust the height of the divider
                indent: 10,
                endIndent: 10,
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  void _onCitySelected(String cityAndCountry) {
    if (cityAndCountry.isNotEmpty) {
      setState(() {
        _selectedCity = cityAndCountry;
        _suggestedCities.clear();
        getWeather(_selectedCity);
      });
    }
  }

}