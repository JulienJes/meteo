import 'package:flutter/material.dart';
import 'package:meteo/city_form.dart';

class Weather extends StatelessWidget {
  const Weather({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Weather', home: CityForm());
  }
}
