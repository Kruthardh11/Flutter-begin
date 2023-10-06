import 'package:firebase_integrate/maps/camera_page.dart';
import 'package:firebase_integrate/maps/images.dart';
import 'package:firebase_integrate/maps/map_screen.dart';
//import 'package:firebase_integrate/maps/map_screen.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map/camera'),
      ),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, // Adjust as needed
        children: [
          // Add your map widget here, for example:
          SizedBox(
            height: 300, // Adjust the height as needed
            child: MapScreen(),
          ),
          SizedBox(height: 20), // Add spacing between map and images
          // Add your Images widget here, for example:
          Images(),
        ],
      ),
    );
  }
}
