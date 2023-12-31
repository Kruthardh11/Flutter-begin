import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_integrate/crud/sport_model.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

class SportDetails extends StatefulWidget {
  //final Box<SportModel> sportsBox;

  const SportDetails({
    Key? key,
  }) : super(key: key);

  @override
  _SportDetailsState createState() => _SportDetailsState();
}

class _SportDetailsState extends State<SportDetails> {
  //stores the changes done in text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _playerController = TextEditingController();
  final TextEditingController _teamController = TextEditingController();

  late Stream<ConnectivityResult> connectivityStream;
  bool isOnline = false;

  //creating a firebase instance referring a particular collection
  final CollectionReference _products =
      FirebaseFirestore.instance.collection('favsport');

  final sportsInfo =
      Hive.box<SportModel>('sports'); // Access the box with the correct type

  @override
  void initState() {
    super.initState();
    connectivityStream = Connectivity().onConnectivityChanged;
    connectivityStream.listen((ConnectivityResult result) {
      setState(() {
        isOnline = (result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi);
      });
    });
  }

  // Show a modal bottom sheet for creating a new product or editing an existing one.
  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _teamController,
                  decoration:
                      const InputDecoration(labelText: 'Favorite Team/Club'),
                ),
                TextField(
                  controller: _playerController,
                  decoration:
                      const InputDecoration(labelText: 'Favorite Player'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Create'),
                  onPressed: () async {
                    final String name = _nameController.text;
                    final String player = _playerController.text;
                    final String team = _teamController.text;

                    if (isOnline) {
                      await _products
                          .add({"name": name, "player": player, "team": team});
                    } else {
                      sportsInfo.put(
                        'key_${_nameController.text}',
                        SportModel(name: name, player: player, team: team),
                      );
                      final path = sportsInfo.path;
                      print("offline data logged");
                      print(path);
                    }
                    _nameController.text = '';
                    _playerController.text = '';
                    _teamController.text = '';
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    //if the document exist do the changes
    if (documentSnapshot != null) {
      _nameController.text = documentSnapshot['name'];
      _playerController.text = documentSnapshot['player'];
      _teamController.text = documentSnapshot['team'];
    }
//styling of the update field
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Sport'),
                ),
                TextField(
                  controller: _playerController,
                  decoration: const InputDecoration(
                    labelText: 'Favorite Player',
                  ),
                ),
                TextField(
                  controller: _teamController,
                  decoration: const InputDecoration(
                    labelText: 'Favorite team',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Update'),
                  onPressed: () async {
                    final String name = _nameController.text;
                    final String player = _playerController.text;
                    final String team = _teamController.text;

                    // Update the document in the Firestore collection with new data
                    await _products
                        .doc(documentSnapshot!.id)
                        .update({"name": name, "player": player, "team": team});
                    // Clear text fields and close the modal
                    _nameController.text = '';
                    _playerController.text = '';
                    _teamController.text = '';
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          );
        });
  }

//logic of deleting the particular document
  Future<void> _delete(String productId) async {
    await _products.doc(productId).delete();
//popup on successful deletion of the document
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a product')));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: connectivityStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Update the isOnline variable based on the latest connectivity result
            isOnline = (snapshot.data == ConnectivityResult.mobile ||
                snapshot.data == ConnectivityResult.wifi);
          }
          if (isOnline) {
            return Scaffold(
                appBar: AppBar(
                  title: Center(child: Text(isOnline ? "Online" : "Offline")),
                ),
                //stream builder to do the changes in real time
                body: StreamBuilder(
                  stream: _products.snapshots(),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    if (streamSnapshot.hasData) {
                      return ListView.builder(
                        itemCount: streamSnapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final DocumentSnapshot documentSnapshot =
                              streamSnapshot.data!.docs[index];
                          return Card(
                            margin: const EdgeInsets.all(10),
                            child: ListTile(
                              title: Text(documentSnapshot['name']),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Player: ${documentSnapshot['player']}'),
                                  Text('Team: ${documentSnapshot['team']}'),
                                ],
                              ),
                              trailing: SizedBox(
                                width: 100,
                                child: Row(
                                  children: [
                                    IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () =>
                                            _update(documentSnapshot)),
                                    IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () =>
                                            _delete(documentSnapshot.id)),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }

                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
                // Add new product
                floatingActionButton: FloatingActionButton(
                  onPressed: () => _create(),
                  child: const Icon(Icons.add),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat);
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Center(child: Text(isOnline ? "Online" : "Offline")),
              ),
              body: ListView.builder(
                  itemCount: sportsInfo.length,
                  itemBuilder: ((context, index) {
                    SportModel? sportModel = sportsInfo.getAt(index);
                    return ListTile(
                      title: Text(sportModel!.name),
                      subtitle: Text(sportModel.player),
                      trailing: Text("Team :${sportModel.team}"),
                      leading: IconButton(
                          onPressed: () {
                            setState(() {
                              sportsInfo.deleteAt(index);
                              print("Deleted!!");
                            });
                          },
                          icon: const Icon(Icons.remove)),
                    );
                  })),
              floatingActionButton: FloatingActionButton(
                onPressed: () => _create(),
                child: const Icon(Icons.add),
              ),
            );
          }
        });
  }
}

class User {
  String id;
  final String name;
  final String team;
  final String player;

  User({
    this.id = '',
    required this.name,
    required this.player,
    required this.team,
  });

  //method to convert User object to json
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'player': player,
        'team': team,
      };

  //json data to User object
  static User fromJson(Map<String, dynamic> json) => User(
      id: json['id'],
      name: json['name'],
      player: json['player'],
      team: json['team']);
}
