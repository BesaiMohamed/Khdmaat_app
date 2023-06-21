import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newprojectflutter/resources/globel.dart' as globals;

import '../../auth/profile.dart';

class Mapscrean extends StatefulWidget {
  const Mapscrean({super.key});

  @override
  State<Mapscrean> createState() => _MapscreanState();
}

class _MapscreanState extends State<Mapscrean> {
  Position? currentPosition;
  double latitude = 33.783823;
  double longitude = 2.845928;
  LatLng myPosition = LatLng(33.783823, 2.845928);
  MapController mapController = MapController();
  int a = 0;
  final TextEditingController value = TextEditingController();
  List<Marker> marker = [];

  static const MAPBOX_ACCESS_TOKEN =
      'pk.eyJ1IjoicGl0bWFjIiwiYSI6ImNsY3BpeWxuczJhOTEzbnBlaW5vcnNwNzMifQ.ncTzM4bW-jpq-hUFutnR1g';

  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('خدمة تحديد المواقع غير مفعلة ')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('لا يوجد أذن الوصول إلى الموقع')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('لا يوجد أذن الوصول إلى الموقع')));
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    value.dispose();
    super.dispose();
  }

  Future<void> getCurrentPosition() async {
    final hasPermission = await handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition().then((Position position) {
      setState(() => currentPosition = position);
    }).catchError((e) {
      debugPrint(e);
    });
    latitude = currentPosition!.latitude;
    longitude = currentPosition!.longitude;

    myPosition = LatLng(currentPosition!.latitude, currentPosition!.longitude);
  }

  addmarker(LatLng postion, String urlimg, String id) {
    marker.add(Marker(
      point: postion,
      height: 60,
      width: 60,
      builder: (context) {
        return InkWell(
          onTap: () {
            globals.iduserProfile = id;
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const profileuser(),
                ));
          },
          child: CachedNetworkImage(
            imageUrl: urlimg,
            imageBuilder: (context, imageProvider) {
              return CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.greenAccent,
                  child: CircleAvatar(
                    radius: 27,
                    backgroundImage: imageProvider,
                  ));
            },
          ),
        );
      },
    ));
    return marker;
  }

  searchmap() {
    if (value.text.isEmpty) {
      return FlutterMap(
        mapController: mapController,
        options:
            MapOptions(center: myPosition, minZoom: 5, maxZoom: 25, zoom: 18),
        nonRotatedChildren: [
          TileLayer(
            urlTemplate:
                'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
            additionalOptions: const {
              'accessToken': MAPBOX_ACCESS_TOKEN,
              'id': 'mapbox/streets-v12'
            },
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: myPosition,
                builder: (context) {
                  return a != 0
                      ? const Icon(
                          Icons.person_pin_circle,
                          color: Colors.red,
                          size: 60,
                        )
                      : Container();
                },
              )
            ],
          )
        ],
      );
    } else {
      return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .orderBy("name", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text("لايوجد مستخدمين");
          } else {
            List<GeoPoint> geopoint = [];
            marker = [];
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              String content = snapshot.data!.docs[i]['typeOfservies'];
              if (content.contains(value.text.toString())) {
                geopoint.add(snapshot.data!.docs[i].get("geopoint"));
                LatLng postion =
                    LatLng(geopoint[i].latitude, geopoint[i].longitude);
                addmarker(postion, snapshot.data!.docs[i].get("photoUrl"),
                    snapshot.data!.docs[i].get("uid"));
              }
            }
            return FlutterMap(
              mapController: mapController,
              options: MapOptions(
                  center: myPosition, minZoom: 5, maxZoom: 25, zoom: 18),
              nonRotatedChildren: [
                TileLayer(
                  urlTemplate:
                      'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                  additionalOptions: const {
                    'accessToken': MAPBOX_ACCESS_TOKEN,
                    'id': 'mapbox/streets-v12'
                  },
                ),
                MarkerLayer(markers: [
                  Marker(
                    point: myPosition,
                    builder: (context) {
                      return const Icon(
                        Icons.person_pin_circle,
                        color: Colors.red,
                        size: 60,
                      );
                    },
                  )
                ]),
                MarkerLayer(markers: marker)
              ],
            );
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (a != 0) {
      mapController.move(myPosition, 18);
    }
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: TextField(
            onSubmitted: (value) {
              getCurrentPosition();
              mapController.move(myPosition, 18);
              setState(() {});
            },
            controller: value,
            decoration: const InputDecoration(
              hintText: ' قم بالبحث هنا...',
              hintStyle: TextStyle(
                color: Color.fromARGB(255, 75, 68, 83),
                fontFamily: 'Alexandria',
                fontSize: 18,
                fontStyle: FontStyle.italic,
              ),
              border: InputBorder.none,
            ),
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
          leading: const Icon(
            Icons.search,
            color: Color.fromARGB(255, 75, 68, 83),
            size: 28,
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 235, 248, 235),
        ),
        body: searchmap(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            getCurrentPosition();
            a++;
            setState(() {});
          },
          label: const Text(
            '',
          ),
          icon: const Icon(
            Icons.gps_fixed,
            color: Colors.white,
          ),
          backgroundColor: Colors.green,
        ));
  }
}
