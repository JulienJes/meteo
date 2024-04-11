import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherData {
  final String main;
  final String description;
  final double? temp;

  WeatherData(
      {required this.main, required this.description, required this.temp});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    var weatherInfo = json['weather'][0];
    var tempInfo = json['main'];
    return WeatherData(
      main: weatherInfo['main'],
      description: weatherInfo['description'],
      temp: tempInfo['temp'].toDouble(),
    );

    // return WeatherData(
    //   main: weatherInfo['main'],
    //   description: weatherInfo['description'],
    // );
  }
}

Future<WeatherData?> fetchWeather(double lat, double lon) async {
  final apiKey = dotenv.env['METEO_API_KEY'];

  var url =
      'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric';

  try {
    var response = await Dio().get(url);
    return WeatherData.fromJson(response.data);
  } catch (error) {
    // ignore: avoid_print
    print(error);
    return null;
  }
}
