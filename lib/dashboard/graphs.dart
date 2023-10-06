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
    //getData();
    setupRealTimeListener();
  }

  void setupRealTimeListener() {
    users.snapshots().listen((QuerySnapshot snapshot) {
      // Create a temporary variable to update favSportCount
      Map<String, int> tempFavSportCount = {};

      for (QueryDocumentSnapshot documentSnapshot in snapshot.docs) {
        List<String> favSportsList = [];
        List<dynamic>? favSports = documentSnapshot['favSport'];

        if (favSports != null) {
          for (dynamic sport in favSports) {
            if (sport is String) {
              favSportsList.add(sport);
            }
          }
        }

        for (String sport in favSportsList) {
          if (tempFavSportCount.containsKey(sport)) {
            tempFavSportCount[sport] = (tempFavSportCount[sport] ?? 0) + 1;
          } else {
            tempFavSportCount[sport] = 1;
          }
        }
      }

      // Update favSportCount with the new data
      setState(() {
        favSportCount = tempFavSportCount;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (favSportCount.isEmpty) // Check if favSportCount is empty
          const CircularProgressIndicator()
        else
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
