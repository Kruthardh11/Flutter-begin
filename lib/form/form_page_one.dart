import 'dart:io';
import 'package:firebase_integrate/dashboard/dashboard.dart';
import 'package:firebase_integrate/form/edit.dart';
import 'package:firebase_integrate/form/form_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';

class FormPageOne extends StatefulWidget {
  final String? userName;
  final String? email;

  const FormPageOne({
    Key? key,
    this.email,
    this.userName,
  }) : super(key: key);

  @override
  State<FormPageOne> createState() => _FormPageOneState();
}

class _FormPageOneState extends State<FormPageOne> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Getting the instance of the collection
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  //getting the Hive Box for local storage
  final formData = Hive.box<FormModel>('formData');

  String? _userName;
  String? _userEmail;
  late Stream<ConnectivityResult> connectivityStream;

  bool isOnline = false;
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  String? _selectedCity = 'Select City';
  String? _selectedGender = 'Male'; // Store selected gender
  final List<String> _favoriteSports = [];

  final List<String> _genderOptions = ['Male', 'Female', 'Other'];
  final List<String> _sportsOptions = [
    'Football',
    'Baseball',
    'Basketball',
    'Cricket',
    'Other'
  ];

  final List<String> _cityOptions = [
    'Select City',
    'New York',
    'Los Angeles',
    'Chicago',
    'Houston',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    // Setting username and email on page load
    _userName = widget.userName;
    _userEmail = widget.email;
    connectivityStream = Connectivity().onConnectivityChanged;
    checkConnectivity();
  }

  Future<void> checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      isOnline = (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi);
    });
  }

  File? _selectedImage;
  String? imageURL;
  Future<void> getImageGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    } else {
      print("BAlls");
    }
  }

  Future<void> _captureImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final selectedImageFile = File(pickedFile.path);

      if (mounted) {
        setState(() {
          _selectedImage = selectedImageFile;
        });
      }

      print(_selectedImage);
    } else {
      // The user canceled capturing an image.
      print("Image capture canceled");
    }
  }

  Future<void> uploadImageToFirebase(File imageFile) async {
    try {
      //getting the timestamp to give the file a unique name
      var timestamp = DateTime.now().millisecondsSinceEpoch;
      //defining the path to the stored image
      var path = 'files/image_$timestamp.jpg';
      //getting the file that needs to be uploaded
      final file = File(_selectedImage!.path);
      //getting the instance of folder in firebase
      final ref = FirebaseStorage.instance.ref().child(path);
      //uploading the image
      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask.whenComplete(() {});

      final urlDownload = await snapshot.ref.getDownloadURL();
      imageURL = urlDownload;
      if (kDebugMode) {
        print(urlDownload);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading image to Firebase Storage: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
        stream: connectivityStream,
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: Text(isOnline ? "Online" : "Offline"),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      initialValue: _userName, // Set the initial value
                      decoration: const InputDecoration(
                        labelText: 'User name',
                      ),
                      readOnly: true, // Make it read-only
                    ),

                    // Text field to display _userEmail
                    TextFormField(
                      initialValue: _userEmail, // Set the initial value
                      decoration: const InputDecoration(
                        labelText: 'User Email',
                      ),
                      readOnly: true, // Make it read-only
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Age'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter your age';
                        }
                        return null;
                      },
                      controller: _ageController,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                      controller: _passwordController,
                    ),
                    const Padding(padding: EdgeInsets.all(10)),
                    const Text('Gender'),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _genderOptions
                          .map(
                            (gender) => Row(
                              children: [
                                Radio(
                                  value: gender,
                                  groupValue: _selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedGender = value.toString();
                                      _genderController.text = value.toString();
                                    });
                                  },
                                ),
                                Text(gender),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 16.0),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'City'),
                      items: _cityOptions
                          .map((city) => DropdownMenuItem<String>(
                                value: city,
                                child: Text(city),
                              ))
                          .toList(),
                      onChanged: (String? value) {
                        setState(() {
                          _selectedCity = value;
                          _cityController.text = value.toString();
                        });
                      },
                      value: _selectedCity,
                      validator: (value) {
                        if (value == 'Select City') {
                          return 'Please select a city';
                        }
                        return null;
                      },
                    ),
                    const Padding(padding: EdgeInsets.all(10)),
                    const Text('Favorite Sports'),
                    Column(
                      children: _sportsOptions
                          .map((sport) => CheckboxListTile(
                                title: Text(sport),
                                value: _favoriteSports.contains(sport),
                                onChanged: (value) {
                                  setState(() {
                                    if (value != null) {
                                      if (_favoriteSports.contains(sport)) {
                                        _favoriteSports.remove(sport);
                                      } else {
                                        _favoriteSports.add(sport);
                                      }
                                    }
                                  });
                                },
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 16.0),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.photo_library),
                          onPressed: getImageGallery,
                          tooltip: 'Pick Image from Gallery',
                        ),
                        IconButton(
                          icon: const Icon(Icons.camera_alt),
                          onPressed: _captureImage,
                          tooltip: 'Capture Image from Camera',
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.all(16.0),
                      child: _selectedImage != null
                          ? Image.file(
                              _selectedImage!,
                              height: 350,
                              width: 350,
                            )
                          // Display the selected image
                          : const Text('No image selected'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (isOnline) {
                          // Logic to validate form key and write data into firestore db
                          if (_formKey.currentState?.validate() ?? false) {
                            _formKey.currentState?.save();
                            try {
                              // Process and submit the form data
                              await uploadImageToFirebase(_selectedImage!);
                              final timestamp = Timestamp.now();
                              await users.add({
                                'name': _userName,
                                'email': _userEmail,
                                'age': _ageController
                                    .text, // Use .text to get the text from controllers
                                'city': _cityController.text,
                                'password': _passwordController.text,
                                'favSport': _favoriteSports,
                                'gender': _genderController.text,
                                'timestamp': timestamp,
                                'imageURL': imageURL,
                              });

                              // Show success SnackBar
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text("Data stored ONLINE"),
                                  backgroundColor:
                                      Colors.green.withOpacity(0.2),
                                  duration: const Duration(
                                      seconds:
                                          3), // Adjust the duration as needed
                                ),
                              );
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => Dashboard(
                                      email:
                                          _userEmail), // Replace 'Dashboard' with your actual widget
                                ),
                              );
                            } catch (error) {
                              // Show error SnackBar
                              print(error);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "Some problem occurred: $error"), // Include the error message
                                  backgroundColor: Colors.red.withOpacity(0.2),
                                  duration: const Duration(
                                      seconds:
                                          3), // Adjust the duration as needed
                                ),
                              );
                            }
                          }
                        } else {
                          formData.put(
                              "key_$_ageController.",
                              FormModel(
                                  name: _userName!,
                                  age: _ageController.text,
                                  city: _cityController.text,
                                  email: _userEmail!,
                                  gender: _genderController.text,
                                  favSport: _favoriteSports,
                                  password: _passwordController.text));
                          var path = formData.path;
                          print(path);
                          print("OFFLINE data logged!");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text("Data stored offline"),
                              backgroundColor: Colors.green.withOpacity(0.2),
                              duration: const Duration(
                                  seconds: 3), // Adjust the duration as needed
                            ),
                          );
                        }
                      },
                      child: const Text('Submit'),
                    ),
                    FloatingActionButton(onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) =>
                              const Edit(), // Replace 'Dashboard' with your actual widget
                        ),
                      );
                    })
                  ],
                ),
              ),
            ),
          );
        });
  }
}
