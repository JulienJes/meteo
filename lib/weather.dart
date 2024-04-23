import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:meteo/city_form.dart';

class Weather extends StatefulWidget {
  const Weather({super.key});

  @override
  State<Weather> createState() => _Weather();
}

class _Weather extends State<Weather> {
  // bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    print('ready in 3...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 2...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 1...');
    await Future.delayed(const Duration(seconds: 1));
    print('go!');
    FlutterNativeSplash.remove();
    // setState(() {
    //   _isInitialized = true;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Weather', home: CityForm()
        // : Container(
        //     color: Colors.white,
        //     child: const Center(
        //       child: SplashScreen(),
        //     ),
        //   ),
        );
  }
}
