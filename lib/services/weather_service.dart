import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mad_weather_app/model/weather.dart';

import '../consts.dart';

class WeatherService {
  Future<Weather> getWeatherData(String place) async {
    try {
      final queryParameters = {
        'key': WEATHER_API,
        'q': place,
      };
      final uri = Uri.http('api.weatherapi.com', '/v1/current.json', queryParameters);
      final response = await http.get(uri);
      if(response.statusCode == 200) {
        return Weather.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Can not get weather");
      }
    } catch(e) {
      rethrow;
    }
  }

  Future<List<String>> getSuggestedCities(String prefix) async {
    final String apiUrl = 'https://api.weatherapi.com/v1/search.json?key=$WEATHER_API&q=$prefix';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> suggestions = json.decode(response.body);

        if (suggestions is List) {
          return suggestions
              .map<String>((dynamic item) => _formatCityAndCountry(item))
              .toList();
        } else {
          throw Exception('Unexpected format in suggestions');
        }
      } else {
        throw Exception('Failed to load suggested cities');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  String _formatCityAndCountry(dynamic item) {
    final String city = item['name'].toString();
    final String country = item['country'].toString();

    if (country.isNotEmpty) {
      return '$city, $country';
    } else {
      return city;
    }
  }

}