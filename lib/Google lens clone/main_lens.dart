import 'package:flutter/material.dart';

class MainLens extends StatefulWidget {
  const MainLens({super.key});

  @override
  State<MainLens> createState() => _MainLensState();
}

class _MainLensState extends State<MainLens> {
  void getImageGallery() async {}
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
      body: Column(
        children: [],
      ),
    );
  }
}
