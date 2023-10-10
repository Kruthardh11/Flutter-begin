import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

        String? imageUrl = data?['imageURL'];
        if (imageUrl != null && imageUrl.isNotEmpty) {
          // Check if the URL is valid by sending a HEAD request
          final response = await http.head(Uri.parse(imageUrl));
          if (response.statusCode == 200) {
            // URL is valid, add it to the list
            tempList.add(imageUrl);
            print("Valid URL: $imageUrl");
          } else {
            // URL is invalid (404 error), do nothing or log an error message
            print("Invalid URL (404 error): $imageUrl");
          }
        } else {
          print("URL is empty or not there");
        }
      }

      setState(() {
        urlList = tempList;
      });
      print(urlList); // This will print the list of valid image URLs
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
