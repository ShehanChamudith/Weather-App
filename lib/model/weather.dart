class Weather {
  final double temperatureC;
  final double temperatureF;
  final String condition;
  final double wind; // Wind speed
  final int humidity; // Humidity percentage
  final double uv; // UV index
  final double pressure; // Atmospheric pressure

  Weather({
    this.temperatureC = 0,
    this.temperatureF = 0,
    this.condition = "Sunny",
    this.wind = 0,
    this.humidity = 0,
    this.uv = 0,
    this.pressure = 0,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temperatureC: json['current']['temp_c'],
      temperatureF: json['current']['temp_f'],
      condition: json['current']['condition']['text'],
      wind: json['current']['wind_kph'],
      humidity: json['current']['humidity'],
      uv: json['current']['uv'],
      pressure: json['current']['pressure_in'],
    );
  }
}
