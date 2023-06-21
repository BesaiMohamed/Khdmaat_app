import 'package:flutter/animation.dart';
import 'package:newprojectflutter/resources/globel.dart' as globals;

class ThemeColors {
  Color blue = const Color.fromARGB(255, 95, 51, 225);
  Color yellow = const Color.fromARGB(255, 255, 229, 164);
  Color pink = const Color.fromARGB(255, 247, 120, 186);
  Color grey = const Color.fromARGB(255, 235, 228, 255);
  Color purple = const Color.fromARGB(255, 175, 148, 235);
  Color purpleAccent = const Color.fromARGB(255, 197, 175, 231);
  Color bluewater = const Color.fromARGB(255, 0, 138, 196);
  Color wllapaperbackground = globals.mode
      ? const Color.fromARGB(255, 250, 248, 254)
      : const Color.fromARGB(255, 73, 68, 84);
  Color edgethitem = globals.mode
      ? const Color.fromARGB(255, 0, 0, 0)
      : const Color.fromARGB(255, 250, 248, 254);
}
