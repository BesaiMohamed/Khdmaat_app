import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

const MAPBOX_ACCESS_TOKEN =
    'pk.eyJ1IjoicGl0bWFjIiwiYSI6ImNsY3BpeWxuczJhOTEzbnBlaW5vcnNwNzMifQ.ncTzM4bW-jpq-hUFutnR1g';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  dynamic location = ' null ';
  // ignore: non_constant_identifier_names
  dynamic Adress = 'search';

  StreamSubscription<Position>? positionStream;
  List<MarkerOption> markers = [];

  @override
  void initState() {
    super.initState();
    startLocationUpdates();
  }

  void startLocationUpdates() {
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    @override
    void initState() {
      super.initState();
      StreamSubscription<Position> positionStream =
          Geolocator.getPositionStream(locationSettings: locationSettings)
              .listen((Position? position) {});
    }
  }

  @override
  void dispose() {
    positionStream?.cancel();
    super.dispose();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> GetAddressFromLong(Position position) async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemark[0];
    Adress = '${place.locality},${place.country}';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Map'),
        ),
        // ignore: prefer_const_constructors
        body: Column(children: [
          Text(
            location,
            style: TextStyle(color: Colors.white, fontSize: 28),
          ),
          Text(
            Adress,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          ElevatedButton(
              onPressed: () async {
                Position position = await _determinePosition();
                location =
                    'lat:${position.latitude} , Long ${position.longitude}';

                GetAddressFromLong(position);
                setState(() {});
              },
              child: const Text('tahar')),
        ]));
  }
}

class LocationOptions {
  final LocationAccuracy accuracy;
  final double distanceFilter;

  LocationOptions({
    required this.accuracy,
    required this.distanceFilter,
  });
}
