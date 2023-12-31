import 'package:flutter/material.dart';
import 'package:mad_weather_app/services/weather_service.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  String formattedDate = DateFormat.yMMMMd().format(DateTime.now());



  String currentWeather = "";
  double tempC = 0;
  double tempF = 0;
  double windd = 0;
  double uvv = 0;
  double press = 0;
  int hum=0;

  @override
  void initState() {
    super.initState();
    // getWeather("Colombo");
    _loadLastSearchedCity();
  }

  void _loadLastSearchedCity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastSearchedCity = prefs.getString('lastSearchedCity');

    if (lastSearchedCity != null && lastSearchedCity.isNotEmpty) {
      setState(() {
        _selectedCity = lastSearchedCity;
      });

      // Fetch weather data for the last searched city
      getWeather(lastSearchedCity);
    } else {
      // Load Colombo as the default city
      setState(() {
        _selectedCity = 'Colombo';
      });

      // Fetch weather data for Colombo
      getWeather('Colombo');
    }
  }


  void _saveLastSearchedCity(String city) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('lastSearchedCity', city);
  }

  void getWeather(String city) async {

    weather = await weatherService.getWeatherData(city);

    setState(() {
      currentWeather = weather.condition;
      tempF = weather.temperatureF;
      tempC = weather.temperatureC;
      windd = weather.wind;
      uvv = weather.uv;
      press = weather.pressure;
      hum=weather.humidity;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Set this to false
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height, // Set Stack height to full screen height
          child: Stack(
            children: [
              // Background image
              Image.asset(
                'images/bg.jpg',
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
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Opacity(
                        opacity: 1.0,
                        child: TextField(
                          controller: _searchController,
                          onChanged: _onSearchTextChanged,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Poppins',
                          ),
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
                    ),
                    SizedBox(height: 20.0),
                    Stack(
                      children: [
                        Center(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(                          //search box
                              color: Colors.white.withOpacity(0),
                              borderRadius: BorderRadius.circular(20.0), // Adjust the border radius as needed
                            ),

                            child: Container(
                              child: Column(
                                children: [

                                  SizedBox(height: 20.0),
                                  _selectedCity.isNotEmpty
                                      ? Text(                                   //city
                                    '$_selectedCity',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                    ),
                                  )
                                      : Container(),
                                  SizedBox(height: 20.0),
                                  _selectedCity.isNotEmpty
                                      ? Image.asset(                            //load image
                                    _getImagePath(weather.condition),
                                    width: 180.0,
                                    height: 180.0,
                                  )
                                      : Container(),
                                  _selectedCity.isNotEmpty
                                      ? Text(                                   //weather text
                                    weather.condition,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                    ),
                                  )

                                      : Container(),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(                                //date
                                      '$formattedDate',
                                      style: TextStyle(
                                        color: Colors.white, // Choose a color that suits your design
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ),
                                  Text(                                         // temp
                                    '${weather.temperatureC.toStringAsFixed(0)}°C',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 100.0,
                                      fontWeight: FontWeight.w300,
                                      fontFamily: 'PoppinsT',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        _buildSuggestedCities(),

                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 45.0),
                      width: double.infinity,
                      height: 210,
                      decoration: ShapeDecoration(
                        color: Color(0x892F8BA8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            left: 16,
                            top: 27,
                            child: Column(
                              children: [
                                Container(
                                  width: 33,
                                  height: 33,
                                  decoration: ShapeDecoration(
                                    color: Colors.transparent,
                                    shape: CircleBorder(),
                                  ),
                                  child: Image.asset('images/wind.png'), // Add your image path
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Wind',
                                  style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                                ),
                                Text(                                           //wind
                                  '${weather.wind.toStringAsFixed(0)} kmH',
                                  style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            left: 16,
                            top: 110,
                            child: Column(
                              children: [
                                Container(
                                  width: 33,
                                  height: 33,
                                  decoration: ShapeDecoration(
                                    color: Colors.transparent,
                                    shape: CircleBorder(),
                                  ),
                                  child: Image.asset('images/pressure.png'), // Add your image path
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Preasure', // Your title
                                  style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                                ),
                                Text(                                           //preasure
                                  '${weather.pressure.toStringAsFixed(0)} IN',
                                  style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            left: 167,
                            top: 27,
                            child: Column(
                              children: [
                                Container(
                                  width: 33,
                                  height: 33,
                                  decoration: ShapeDecoration(
                                    color: Colors.transparent,
                                    shape: CircleBorder(),
                                  ),
                                  child: Image.asset('images/humidity.png'), // Add your image path
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Humidity', // Your title
                                  style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                                ),
                                Text(                                           //humidity
                                  '${weather.humidity.toStringAsFixed(0)} %',
                                  style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            left: 167,
                            top: 110,
                            child: Column(
                              children: [
                                Container(
                                  width: 33,
                                  height: 33,
                                  decoration: ShapeDecoration(
                                    color: Colors.transparent,
                                    shape: CircleBorder(),
                                  ),
                                  child: Image.asset('images/uv-index.png'), // Add your image path
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'UV-Index', // Your title
                                  style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                                ),
                                Text(                                           //UV
                                  '${weather.uv.toStringAsFixed(0)}',
                                  style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                                ),
                              ],
                            ),
                          ),
                          // Add the rest of your content here
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }


  String _getImagePath(String condition) {
    String lowercaseCondition = condition.toLowerCase();

    if (lowercaseCondition.contains('rain') && lowercaseCondition.contains('thunder')) {
      return 'images/thunder.gif';
    } else if (lowercaseCondition.contains('rain') || lowercaseCondition.contains('rainy')) {
      return 'images/rainy.gif';
    } else if (lowercaseCondition.contains('cloud') || lowercaseCondition.contains('cloudy')) {
      return 'images/cloudy.gif';
    }else if (lowercaseCondition.contains('thunder') || lowercaseCondition.contains('thundering')) {
      return 'images/thunder.gif';
    } else if (lowercaseCondition.contains('sun') || lowercaseCondition.contains('sunny')) {
      return 'images/sun.gif';
    } else {
      return 'images/defcloudy.gif';
    }
  }


  void _onCitySelected(String cityAndCountry) {
    if (cityAndCountry.isNotEmpty) {
      setState(() {
        _selectedCity = cityAndCountry;
        _suggestedCities.clear();
        getWeather(_selectedCity);
        _saveLastSearchedCity(_selectedCity);                                   // Save the selected city
      });
    }
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
        color: Colors.white.withOpacity(0.9), // White container with transparency
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
}