import 'package:flutter/material.dart';
import 'package:meteo/weather.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const Weather());
}
