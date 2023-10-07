import 'package:firebase_integrate/Google%20lens%20clone/image_lebelling.dart';
import 'package:firebase_integrate/Google%20lens%20clone/text_recogniser.dart';
import 'package:flutter/material.dart';

class MainLens extends StatefulWidget {
  const MainLens({super.key});

  @override
  State<MainLens> createState() => _MainLensState();
}

class _MainLensState extends State<MainLens> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Title(
            color: Colors.black,
            child: const Text(
              'Google Lens',
              style: TextStyle(color: Color.fromARGB(255, 116, 166, 251)),
            )),
      ),
      body: const ImageLabelling(),
    );
  }
}
