import 'dart:convert';
import 'package:firebase_integrate/api/post.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HttpCrud extends StatefulWidget {
  const HttpCrud({super.key});

  @override
  State<HttpCrud> createState() => _HttpCrudState();
}

class _HttpCrudState extends State<HttpCrud> {
  Future<Post?>? post;

  Future<Post> fetchPost() async {
    final uri = Uri.parse('https://jsonplaceholder.typicode.com/posts/1');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return Post.fromJson(json.decode(response.body));
    } else {
      throw Exception('failed to load post');
    }
  }

  Future<Post> createPost(String title, String body) async {
    // Create a Map containing the data you want to send as the request body.
    Map<String, dynamic> request = {
      'title': title,
      'body': body,
      'userId': '111'
    };

    // Define the URI (Uniform Resource Identifier) for the HTTP POST request.
    final uri = Uri.parse('https://jsonplaceholder.typicode.com/posts');

    // Send an HTTP POST request to the specified URI with the request body.
    final response = await http.post(uri, body: request);

    // Check if the HTTP response status code is 201 (Created).
    if (response.statusCode == 201) {
      // If the response status code is 201, parse the JSON response body
      // and create a 'Post' object from it using the 'fromJson' constructor.
      return Post.fromJson(json.decode(response.body));
    } else {
      // If the response status code is not 201 (indicating an error),
      // throw an exception with a descriptive error message.
      throw Exception('Failed to load post');
    }
  }

  Future<Post> updatePost(String title, String body) async {
    Map<String, dynamic> request = {
      'id': '101',
      'title': title,
      'body': body,
      'userId': '111'
    };

    final uri = Uri.parse('https://jsonplaceholder.typicode.com/posts/2');
    final response = await http.put(uri, body: request);

    if (response.statusCode == 200) {
      return Post.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<Post?>? deletePost() async {
    final uri = Uri.parse('https://jsonplaceholder.typicode.com/posts/1');
    final response = await http.delete(uri);

    if (response.statusCode == 200) {
      return null;
    } else {
      throw Exception('failed to load post');
    }
  }

  void clickGetButton() {
    setState(() {
      post = fetchPost();
    });
  }

  void clickDeleteButton() {
    setState(() {
      post = deletePost();
    });
  }

  void clickPostButton() {
    setState(() {
      post = createPost('TOP POST', 'THIS IS THE EXAMPLE POST');
    });
  }

  void clickUpdateButton() {
    setState(() {
      post = updatePost('UPDATED POST', 'NEW UPDATED EXAMPLE POST');
    });
  }

  Widget buildDataWidget(context, snapshot) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(snapshot.data.title),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(snapshot.data.description),
          )
        ],
      );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        //by adding list view it makes the screen scrollable. used to solve overflowing issues
        child: ListView(
          children: [
            FutureBuilder<Post?>(
                future: post,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      height: 12,
                      width: 12,
                      child:
                          const CircularProgressIndicator(color: Colors.white),
                    );
                  } else if (snapshot.connectionState == ConnectionState.none) {
                    return Container();
                  } else {
                    if (snapshot.hasData) {
                      return buildDataWidget(context, snapshot);
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    } else {
                      return Container();
                    }
                  }
                }),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                child: const Text('GET'),
                onPressed: () => clickGetButton(),
              ),
            ),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                child: const Text('POST'),
                onPressed: () => clickPostButton(),
              ),
            ),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                child: const Text('UPDATE'),
                onPressed: () => clickUpdateButton(),
              ),
            ),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                child: const Text('DELETE'),
                onPressed: () => clickDeleteButton(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
