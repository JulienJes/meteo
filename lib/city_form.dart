import 'package:flutter/material.dart';
import 'package:meteo/city_service.dart';
import 'package:meteo/weather_service.dart';

class CityForm extends StatefulWidget {
  const CityForm({super.key});

  @override
  State<CityForm> createState() => _CityFormState();

  void setState(Null Function() param0) {}
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
                        return 'Veuiller entrer une ville';
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
            FutureBuilder<Map<String, dynamic>>(
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
                  return Column(
                    children: [
                      Text(snapshot.data!['cityData'].name),
                      Text(snapshot.data!['cityData'].country),
                      Text(snapshot.data!['weatherData'].main),
                      Text(snapshot.data!['weatherData'].temp.toString()),
                    ],
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
