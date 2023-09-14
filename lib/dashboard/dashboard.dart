import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  final String? email;
  Dashboard({super.key, required this.email});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String? Email; // Define another variable

  @override
  void initState() {
    super.initState();
    // Assign the email value to the anotherEmail variable in the initState method
    Email = widget.email;
  }

  Future<void> fetchUserData(String email) async {
    final headers = {
      'Content-Type': 'application/json',
      'Cookie': 'JSESSIONID=75BE2F666036E90625C27E37AC26FD09',
    };

    final url =
        Uri.parse('https://internal.resustainability.com/reirm/reone/login');
    final Map<String, dynamic> requestBody = {"email_id": email};

    final request = http.Request('GET', url)
      ..headers.addAll(headers)
      ..body = jsonEncode(requestBody);

    try {
      final http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseString = await response.stream.bytesToString();
        // Parse and handle the response data here
        print(responseString);
      } else {
        // Handle error cases
        print(response.reasonPhrase);
      }
    } catch (e) {
      // Handle network or other errors
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Column(
        children: [
          const Text('dashboard'),
          ElevatedButton(
              onPressed: () {
                if (Email != null) {
                  fetchUserData(Email!);
                }
              },
              child: const Text('print email'))
        ],
      ),
    );
  }
}
