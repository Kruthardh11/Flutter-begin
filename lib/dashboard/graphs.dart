import 'package:firebase_integrate/dashboard/pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Graphs extends StatefulWidget {
  const Graphs({super.key});

  @override
  State<Graphs> createState() => _GraphsState();
}

class _GraphsState extends State<Graphs> {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  List<String> favSportsList = [];
  Map<String, int> favSportCount = {};

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      //query the collection
      QuerySnapshot querySnapshot = await users.get();
      favSportCount = {};

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        //print('Document ID: ${documentSnapshot.id}');
        //print('Data: ${documentSnapshot.data()}');
        List<String> favSportsList = [];

        List<dynamic>? favSports = documentSnapshot['favSport'];

        // If favSports is not null, iterate through it and add values to the list
        if (favSports != null) {
          for (dynamic sport in favSports) {
            if (sport is String) {
              favSportsList.add(sport);
            }
          }
        }

        //count the occurences of each sport
        for (String sport in favSportsList) {
          if (favSportCount.containsKey(sport)) {
            favSportCount[sport] = (favSportCount[sport] ?? 0) + 1;
          } else {
            favSportCount[sport] = 1;
          }
        }
      }
      print("$favSportsList");
      print("the count goes : $favSportCount");
    } catch (e) {
      print('Error retrieving data: $e');
    }

    //iterate through the document to access the data
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildPieChart(),
      ],
    );
  }

  Widget _buildPieChart() {
    return Center(
      child: PieChartWidget(data: favSportCount),
    );
  }
}
