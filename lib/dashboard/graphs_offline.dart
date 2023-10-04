import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_integrate/dashboard/pie_chart.dart';
import 'package:firebase_integrate/form/form_model.dart';

class GrpahsOffline extends StatefulWidget {
  const GrpahsOffline({super.key});

  @override
  State<GrpahsOffline> createState() => _GrpahsOfflineState();
}

class _GrpahsOfflineState extends State<GrpahsOffline> {
  final formData = Hive.box<FormModel>('formData');
  List<String> allsports = [];
  Map<String, int> sportCount = {};

  @override
  void initState() {
    super.initState();
    getOfflineData();
  }

  Future<void> getOfflineData() async {
    List<FormModel> offlineData = formData.values.toList();
    allsports = [];
    for (var list in offlineData) {
      for (var sport in list.favSport) {
        allsports.add(sport);
      }
    }
    sportCount = countSports(allsports);
  }

  Map<String, int> countSports(List<String> sports) {
    Map<String, int> sportCount = {};

    for (String sport in sports) {
      if (sportCount.containsKey(sport)) {
        sportCount[sport] = (sportCount[sport] ?? 0) + 1;
      } else {
        sportCount[sport] = 1;
      }
    }
    return sportCount;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<FormModel>('formData').listenable(),
      builder: (context, box, _) {
        // This builder will be called whenever data in the Hive box changes.
        getOfflineData(); // Update the data whenever there's a change.
        return Center(
          child: PieChartWidget(data: sportCount),
        );
      },
    );
  }
}
