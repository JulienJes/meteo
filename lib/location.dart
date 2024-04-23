import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationWidget extends StatefulWidget {
  final Function(double, double)? onLocationObtained;
  const LocationWidget({super.key, this.onLocationObtained});

  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: _determinePosition,
            child: const Text('Get Location'),
          ),
        ],
      ),
    );
  }

  Future<void> _determinePosition() async {
    Position position = await Geolocator.getCurrentPosition();
    if (widget.onLocationObtained != null) {
      widget.onLocationObtained!(position.latitude, position.longitude);
    }
  }
}
