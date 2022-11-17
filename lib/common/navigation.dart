import 'package:flutter/material.dart';

BottomNavigationBar createBottomNavigation() {
  return BottomNavigationBar(
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: "Home",
        backgroundColor: Colors.black45,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.map),
        label: "Map",
        backgroundColor: Colors.black45,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.wine_bar_rounded),
        label: "Challenges",
        backgroundColor: Colors.black45,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.accessibility_new),
        label: "Fight",
        backgroundColor: Colors.black45,
      ),

    ],
    selectedItemColor: Colors.purple,
  );
}