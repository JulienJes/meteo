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
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Future<Map<String, dynamic>>? _future;

  Future<Map<String, dynamic>> _getCityWeather(String city) async {
    var responseCity = await fetchCity(city);
    var responseWeather =
        await fetchWeather(responseCity.latitude, responseCity.longitude);

    return {
      'cityData': responseCity,
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
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _controller,
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
                    if (_formKey.currentState != null &&
                        _formKey.currentState!.validate()) {
                      setState(() {
                        _future = _getCityWeather(_controller.text);
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
                      Text(cityData.name),
                      Text(cityData.country),
                      Text(weatherData.main),
                      Text(weatherData.temp.toString()),
                      const SizedBox(height: 20),
                      Expanded(
                        child: FlutterMap(
                          options: MapOptions(
                            initialCenter:
                                LatLng(cityData.latitude, cityData.longitude),
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
