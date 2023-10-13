import 'package:firebase_integrate/Google%20lens%20clone/image_lebelling.dart';
import 'package:firebase_integrate/Google%20lens%20clone/object_detector.dart';
import 'package:firebase_integrate/Google%20lens%20clone/qr_scanenr.dart';
import 'package:firebase_integrate/Google%20lens%20clone/text_recogniser.dart';
import 'package:flutter/material.dart';

class MainLens extends StatefulWidget {
  const MainLens();

  @override
  State<MainLens> createState() => _MainLensState();
}

class _MainLensState extends State<MainLens> {
  String selectedOption = 'Text Recognition'; // Default selected option

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Title(
          color: Colors.black,
          child: const Text(
            'Google Lens',
            style: TextStyle(color: Color.fromARGB(255, 116, 166, 251)),
          ),
        ),
      ),
      body: _buildBody(),
      drawer: _buildDrawer(),
    );
  }

  Widget _buildBody() {
    switch (selectedOption) {
      case 'Translator':
        return const TextRecognitionAndTranslationWidget();
      case 'Text Recognition':
        return const TextRecogniser();
      case 'Qr Scanner':
        return const QrScanner();
      case 'Image Labelling':
      default:
        return const ImageLabelling();
    }
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 116, 166, 251),
            ),
            child: Text(
              'Options',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          _buildDrawerItem('Image Labelling'),
          _buildDrawerItem('Translator'),
          _buildDrawerItem('Text Recognition'),
          _buildDrawerItem('Qr Scanner'),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(String option) {
    return ListTile(
      title: Text(option),
      selected: selectedOption == option,
      onTap: () {
        setState(() {
          selectedOption = option;
          Navigator.pop(context); // Close the drawer
        });
      },
    );
  }
}
