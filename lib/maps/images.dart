import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Images extends StatefulWidget {
  const Images({super.key});

  @override
  State<Images> createState() => _ImagesState();
}

class _ImagesState extends State<Images> {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  List<String>? urlList = [];

  @override
  void initState() {
    super.initState();
    getImages();
  }

  Future<void> getImages() async {
    List<String> tempList = []; // Initialize as an empty list

    try {
      QuerySnapshot snapshot = await users.get(); // Await the query result

      for (QueryDocumentSnapshot documentSnapshot in snapshot.docs) {
        final Map<String, dynamic>? data =
            documentSnapshot.data() as Map<String, dynamic>?;

        String? balls = data?['imageURL'];
        if (balls != null && balls.isNotEmpty) {
          print("Document Data: $balls");
          tempList.add(balls); // Add to the list
        } else {
          print("Not there");
        }
      }

      setState(() {
        urlList = tempList;
      });
      print(urlList); // This will print the list of image URLs
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: urlList?.length,
      itemBuilder: (context, index) {
        String url = urlList![index];
        return Card(
          child: ListTile(
            title: Image.network(url),
            subtitle: Text("Image $index"),
          ),
        );
      },
    );
  }
}
