import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_integrate/dashboard/graphs.dart';
import 'package:firebase_integrate/dashboard/graphs_offline.dart';
import 'package:firebase_integrate/dashboard/wearther_card.dart';
import 'package:firebase_integrate/form/form_model.dart';
import 'package:firebase_integrate/form/show_offline.dart';
import 'package:firebase_integrate/maps/images.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class Dashboard extends StatefulWidget {
  final String? email;

  const Dashboard({super.key, required this.email});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String? Email;
  double latitude = 0;
  double longitude = 0;
  double humidity = 0;
  double temperature = 0;
  double windSpeed = 0;
  int currentHour = 0;
  Map<String, dynamic> targetHourData = {};
  Map<String, dynamic> userData = {};
  Map<String, dynamic>? dataForTargetHour;
  late Stream<ConnectivityResult> connectivityStream;

  bool isOnline = false;

  @override
  void initState() {
    super.initState();
    Email = widget.email;
    fetchData(Email!);
    getLocation();
    getCurrentHour();
    fetchWeatherData(latitude, longitude, currentHour);
    connectivityStream = Connectivity().onConnectivityChanged;
    checkConnectivity();
  }

  Future<void> getLocation() async {
    try {
      // ignore: unused_local_variable
      LocationPermission? permission;
      permission = await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error getting location: $e");
      }
    }
  }

  void getCurrentHour() {
    DateTime now = DateTime.now();
    setState(() {
      currentHour = now.hour;
    });
  }

  void fetchData(String Email) async {
    final apiUrl =
        Uri.parse('https://internal.resustainability.com/reirm/reone/login');

    // Create a Map containing the data you want to send
    final data = {
      "email_id": Email,
    };

    // Convert the data to JSON
    final jsonData = jsonEncode(data);

    try {
      // Send the POST request
      final response = await http.post(
        apiUrl,
        headers: {
          'Content-Type': 'application/json', // Set the content type to JSON
        },
        body: jsonData, // Set the JSON payload as the request body
      );

      if (response.statusCode == 200) {
        // If the request is successful, you can parse the JSON response
        final jsonResponse = jsonDecode(response.body);
        //print(jsonResponse);
        setState(() {
          userData = jsonResponse;
        });
      } else {
        // If the request fails, you can handle the error here
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}');
        }
        if (kDebugMode) {
          print(response.body);
        }
      }
    } catch (error) {
      // Handle any exceptions that might occur during the request
      if (kDebugMode) {
        print('Error: $error');
      }
    }
  }

  final formData = Hive.box<FormModel>('formData');
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  Future<void> getOfflineData() async {
    List<FormModel> offlineData = formData.values.toList();
    var path = formData.path;
    if (kDebugMode) {
      print(path);
    }
    await syncData(offlineData);
  }

  Future<void> checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      isOnline = (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi);
    });
  }

  Future<void> syncData(List<FormModel> data) async {
    // Loop through the data and send each record to Firestore
    if (isOnline) {
      for (FormModel form in data) {
        try {
          await users.add({
            'name': form.name,
            'email': form.email,
            'city': form.city,
            'age': form.age,
            'password': form.password,
            'gender': form.gender,
            'favSport': form.favSport,
          });
          if (kDebugMode) {
            print('sending to online');
          }
          // If you want, you can delete the record from Hive after it's successfully sent to Firestore.
          // formData.delete(form.key);
        } catch (e) {
          // Handle any errors that might occur during Firestore write operations.
          if (kDebugMode) {
            print('Error sending data to Firestore: $e');
          }
        }
      }
      // Clear the data from Hive after successful synchronization
      formData.clear();

      // Show a snackbar to inform the user that the synchronization is complete
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data synchronized'),
          duration: Duration(seconds: 2), // Adjust the duration as needed
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Connect to internet'),
          duration: Duration(seconds: 2), // Adjust the duration as needed
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String userName = userData["user_name"] ?? " ";
    final String userId = userData["user_id"] ?? " ";
    final String departmentName = userData["department_name"] ?? " ";
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              departmentName,
              style: const TextStyle(
                color: Colors.black, // Text color in the AppBar
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'Welcome',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
            Text(
              userName,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'YourFontFamily', // Replace with your desired font
              ),
            ),
            Text(
              'User ID: $userId',
              style: const TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
                height: 16), // Add spacing between user details and WeatherCard
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Latitude: ${latitude.toStringAsFixed(2)}'),
                const SizedBox(
                    width: 16), // Add spacing between latitude and longitude
                Text('Longitude: ${longitude.toStringAsFixed(2)}'),
              ],
            ),
            const SizedBox(height: 16), // Add spacing below latitude/longitude
            WeatherCard(
              humidity: humidity,
              temperature: temperature,
              windSpeed: windSpeed,
            ),
            const Text('Online data'),
            const Graphs(),
            ElevatedButton(
                onPressed: () {
                  getOfflineData();
                },
                child: const Text('Sync')),
            const Text('Offline data'),
            const GrpahsOffline(),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const ShowOffline(),
                  ));
                },
                child: const Text("offline data")),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const Images(),
                  ));
                },
                child: const Text('images'))
          ],
        ),
      ),
    );
  }

  Future<void> fetchWeatherData(
      double latitude, double longitude, int targetHour) async {
    const apiKey = 'B5gvREObNOqySOxpYlFiCbq6zJ2mJ4Sg';
    final apiUrl = Uri.parse(
      'https://api.tomorrow.io/v4/weather/forecast?location=$latitude,$longitude&apikey=$apiKey',
    );

    try {
      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        // Extract the "hourly" data from the JSON response
        List<dynamic> hourlyData = jsonResponse['timelines']['hourly'];

        // Find the entry in the "hourly" data that matches the target hour
        Map<String, dynamic> dataForTargetHour = {};
        for (var entry in hourlyData) {
          int entryHour = DateTime.parse(entry['time']).hour;
          if (entryHour == targetHour) {
            dataForTargetHour = entry['values'];
            break;
          }
        }
        // Now, 'dataForTargetHour' contains the values for the current hour
        if (kDebugMode) {
          print('Values recieved');
        }
        // Call the `setState` method to update the UI with the weather data
        setState(() {
          this.dataForTargetHour = dataForTargetHour;
          humidity = dataForTargetHour['humidity'] ?? 0.0; // Extract humidity
          temperature =
              dataForTargetHour['temperature'] ?? 0.0; // Extract temperature
          windSpeed = dataForTargetHour['windSpeed'] ?? 0.0;
        });
      } else {
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}');
        }
        if (kDebugMode) {
          print(response.body);
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }
    }
  }
}
