import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiPage extends StatefulWidget {
  const ApiPage({super.key});

  @override
  State<ApiPage> createState() => _ApiPageState();
}

class _ApiPageState extends State<ApiPage> {
  Future<Map<String, dynamic>>? mangaData;

  // http get request logic to fetch the data in json
  Future<Map<String, dynamic>> fetchMangaData() async {
    final url = Uri.parse('https://api.jikan.moe/v4/top/manga');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        // If the server did not return a 200 OK response,
        // throw an exception or handle the error as needed.
        throw Exception('Failed to load manga data');
      }
    } catch (e) {
      // Handle any exceptions that might occur during the HTTP request.
      print('Error: $e');
      throw Exception('Failed to load manga data');
    }
  }

  // Called on start up.
  @override
  void initState() {
    super.initState();
    mangaData = fetchMangaData(); // Call the fetchMangaData function here
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      AppBar(
        title: const Text('Data'),
      ),
      Expanded(
        child: FutureBuilder<Map<String, dynamic>>(
          future: mangaData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Container(
                  height: 32,
                  width: 32,
                  child: const CircularProgressIndicator(color: Colors.white),
                ),
              ); // Loading indicator
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              final mangaData = snapshot.data!['data'];
              return ListView.builder(
                itemCount: mangaData.length,
                itemBuilder: (context, index) {
                  final manga = mangaData[index];
                  return MangaCard(
                    mangaName: manga['title'],
                    imageUrl: manga['images']['jpg']['image_url'],
                  );
                },
              );
            }

            // Return an empty container or a placeholder widget by default
            return Container();
          },
        ),
      )
    ]);
  }
}

//widget to return the card component
class MangaCard extends StatelessWidget {
  final String mangaName;
  final String imageUrl;

  const MangaCard({required this.mangaName, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.all(
          8.0), // Add space between the card and screen border
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0), //  rounded corners
            child: Image.network(
              imageUrl,
              height: 300.0,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              mangaName,
              style: const TextStyle(
                fontSize: 18.0, // Increase font size
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
              height:
                  8.0), // Add space between manga name and the bottom of the card
        ],
      ),
    );
  }
}
