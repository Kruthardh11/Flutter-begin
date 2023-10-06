import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Images extends StatefulWidget {
  const Images({super.key});

  @override
  State<Images> createState() => _ImagesState();
}

class _ImagesState extends State<Images> {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  Future<void> getImages() async {
    await users.snapshots().listen((QuerySnapshot snapshot) {
      List<String> imageUrls;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
