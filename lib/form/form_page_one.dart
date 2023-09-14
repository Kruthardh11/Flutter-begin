import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FormPageOne extends StatefulWidget {
  final String? userName;
  final String? email;

  const FormPageOne({Key? key, this.email, this.userName}) : super(key: key);

  @override
  State<FormPageOne> createState() => _FormPageOneState();
}

class _FormPageOneState extends State<FormPageOne> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Getting the instance of the collection
  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  String? _userName;
  String? _userEmail;
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
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
              ElevatedButton(
                onPressed: () async {
                  // Logic to validate form key and write data into firestore db
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    try {
                      // Process and submit the form data
                      await users.add({
                        'name': _userName,
                        'email': _userEmail,
                        'age': _ageController
                            .text, // Use .text to get the text from controllers
                        'city': _cityController.text,
                        'password': _passwordController.text,
                        'favSport': _favoriteSports,
                        'gender': _genderController.text,
                      });
                      // Show success SnackBar
                      Get.snackbar(
                        "Success",
                        "Your information has been logged",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green.withOpacity(0.2),
                        colorText: Colors.green,
                      );
                    } catch (error) {
                      // Show error SnackBar
                      Get.snackbar(
                        "Failed",
                        "Some problem occurred",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red.withOpacity(0.2),
                        colorText: Colors.black,
                      );
                    }
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
