import 'package:flutter/material.dart';
import 'package:meteo/city_service.dart';
import 'package:meteo/weather_service.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CityForm extends StatefulWidget {
  const CityForm({super.key});

  @override
  State<CityForm> createState() => _CityFormState();
}

class _CityFormState extends State<CityForm> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerLatitude = TextEditingController();
  final TextEditingController _controllerLongitude = TextEditingController();
  final _formKeyName = GlobalKey<FormState>();
  final _formKeyCoordinates = GlobalKey<FormState>();
  Future<Map<String, dynamic>>? _future;

  Future<Map<String, dynamic>> _getCityWeatherByName(String city) async {
    var responseCity = await fetchCity(city);
    var responseWeather =
        await fetchWeather(responseCity.latitude, responseCity.longitude);

    return {
      'cityData': responseCity,
      'weatherData': responseWeather,
    };
  }

  Future<Map<String, dynamic>> _getCityWeatherByCoordinates(
      double latitude, double longitude) async {
    var responseWeather = await fetchWeather(latitude, longitude);

    return {
      'weatherData': responseWeather,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter a city'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Form(
            key: _formKeyName,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _controllerName,
                  decoration: const InputDecoration(labelText: 'City'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer une ville';
                    }
                    final regex = RegExp(r'^[a-zA-Z\s]*$');
                    if (!regex.hasMatch(value)) {
                      return 'Veuillez entrer une ville valide';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKeyName.currentState != null &&
                        _formKeyName.currentState!.validate()) {
                      setState(() {
                        _future = _getCityWeatherByName(_controllerName.text);
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Veuillez entrer une ville valide.'),
                          duration: Duration(seconds: 4),
                        ),
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
          Form(
            key: _formKeyCoordinates,
            child: Column(
              children: <Widget>[
                Column(
                  children: [
                    TextFormField(
                      controller: _controllerLatitude,
                      decoration: const InputDecoration(labelText: 'Latitude'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer une coordonnée';
                        }
                        final regex = RegExp(r'^[0-9]+(\.[0-9]+)?$');
                        if (!regex.hasMatch(value)) {
                          return 'Veuillez entrer une coordonnée valide';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _controllerLongitude,
                      decoration: const InputDecoration(labelText: 'Longitude'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer une coordonnée';
                        }
                        final regex = RegExp(r'^[0-9]+(\.[0-9]+)?$');
                        if (!regex.hasMatch(value)) {
                          return 'Veuillez entrer une coordonnée valide';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKeyCoordinates.currentState != null &&
                        _formKeyCoordinates.currentState!.validate()) {
                      setState(() {
                        _future = _getCityWeatherByCoordinates(
                            double.parse(_controllerLatitude.text),
                            double.parse(_controllerLongitude.text));
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Veuillez entrer des coordonnées valides.'),
                          duration: Duration(seconds: 4),
                        ),
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
          Flexible(
            child: FutureBuilder<Map<String, dynamic>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${snapshot.error}'),
                        duration: const Duration(seconds: 4),
                      ),
                    );
                  });
                  return Container();
                } else if (snapshot.hasData) {
                  var cityData = snapshot.data!['cityData'];
                  var weatherData = snapshot.data!['weatherData'];
                  return Column(
                    children: [
                      cityData != null
                          ? Text(cityData.name ?? "Nom indisponible")
                          : Container(),
                      cityData != null
                          ? Text(cityData.country ?? "Pays indisponible")
                          : Container(),
                      Text(weatherData.main),
                      Text(weatherData.temp.toString()),
                      const SizedBox(height: 20),
                      Expanded(
                        child: FlutterMap(
                          options: MapOptions(
                            initialCenter: cityData != null
                                ? LatLng(cityData.latitude, cityData.longitude)
                                : LatLng(double.parse(_controllerLatitude.text),
                                    double.parse(_controllerLongitude.text)),
                            initialZoom: 13.0,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.app',
                            ),
                            RichAttributionWidget(
                              attributions: [
                                TextSourceAttribution(
                                  'OpenStreetMap contributors',
                                  onTap: () => (Uri.parse(
                                      'https://openstreetmap.org/copyright')),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
