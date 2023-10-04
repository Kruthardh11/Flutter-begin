import 'package:firebase_integrate/form/form_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ShowOffline extends StatefulWidget {
  const ShowOffline({Key? key});

  @override
  State<ShowOffline> createState() => _ShowOfflineState();
}

class _ShowOfflineState extends State<ShowOffline> {
  final formData = Hive.box<FormModel>('formData');
  List<FormModel> offlineData = [];

  @override
  void initState() {
    super.initState();
    getOfflineData();
  }

  Future<void> getOfflineData() async {
    offlineData = formData.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Offline Data'),
      ),
      body: ListView.builder(
        itemCount: offlineData.length,
        itemBuilder: (context, index) {
          final formModel = offlineData[index];
          return ListTile(
            title: Text('Name: ${formModel.name}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Age: ${formModel.age}'),
                Text('City: ${formModel.city}'),
                Text('Email: ${formModel.email}'),
                Text('Gender: ${formModel.gender}'),
                Text('Favorite Sports: ${formModel.favSport.join(", ")}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
