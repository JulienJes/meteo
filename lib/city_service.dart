import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CityData {
  final String name;
  final double latitude;
  final double longitude;
  final String country;
  final int population;
  final bool isCapital;

  CityData(
      {required this.name,
      required this.latitude,
      required this.longitude,
      required this.country,
      required this.population,
      required this.isCapital});

  factory CityData.fromJson(Map<String, dynamic> json) {
    return CityData(
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      country: json['country'],
      population: json['population'],
      isCapital: json['is_capital'],
    );
  }
}

Future<CityData> fetchCity(city) async {
  String url = 'https://api.api-ninjas.com/v1/city?name=$city';

  try {
    var response = await Dio().get(
      url,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'X-Api-Key': dotenv.env['CITY_API_KEY'],
        },
      ),
    );

    return CityData.fromJson(response.data[0]);
  } catch (error) {
    // ignore: avoid_print
    print(error);
    throw Exception('Une erreur s\'est produite, veuillez réessayer plus tard');
  }
}
