import 'package:flutter/material.dart';
import 'package:newprojectflutter/views/page/Home.dart';
import 'package:newprojectflutter/views/page/Mas.dart';
import 'package:newprojectflutter/views/page/map/MapScreen(1).dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'views/page/Profile.dart';

class bottom_bar extends StatefulWidget {
  const bottom_bar({super.key});

  @override
  State<bottom_bar> createState() => _bottom_barState();
}

class _bottom_barState extends State<bottom_bar> {
  int index = 0;
  final screens = [
    const Home(),
    const Mapscrean(),
    const Mas(),
    const Profile(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SalomonBottomBar(
        items: [
          /// Home
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text("الصفحة الرئيسية",
                style: TextStyle(
                  fontFamily: 'Alexandria',
                )),
            selectedColor: Colors.blueGrey,
          ),

          /// Likes
          SalomonBottomBarItem(
            icon: const Icon(Icons.location_on_rounded),
            title: const Text("الخريطة",
                style: TextStyle(
                  fontFamily: 'Alexandria',
                )),
            selectedColor: Colors.green,
          ),

          /// Search
          SalomonBottomBarItem(
            icon: const Icon(Icons.mail),
            title: const Text("الرسائل",
                style: TextStyle(
                  fontFamily: 'Alexandria',
                )),
            selectedColor: Colors.orange,
          ),

          /// Profile
          SalomonBottomBarItem(
            icon: const Icon(Icons.person),
            title: const Text("الحساب",
                style: TextStyle(
                  fontFamily: 'Alexandria',
                )),
            selectedColor: Colors.teal,
          ),
        ],
        backgroundColor: Colors.transparent,
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
      ),
      body: screens[index],
    );
  }
}
