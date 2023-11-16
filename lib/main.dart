import 'dart:convert';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_integrate/Controllers/online_status.dart';
import 'package:firebase_integrate/Google%20lens%20clone/main_lens.dart';
import 'package:firebase_integrate/crud/sports_info.dart';
import 'package:firebase_integrate/dashboard/dashboard.dart';
import 'package:firebase_integrate/form/form_model.dart';
import 'package:firebase_integrate/form/form_page_one.dart';
import 'package:firebase_integrate/maps/main_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyC36_6GMvkpinY3YMvlxuPQi8Fvogk5hoo',
      appId: '1:625310299583:android:a96427e5ce98bf3857dd0a',
      messagingSenderId: '625310299583',
      projectId: 'flutterdb-1a2a7',
      storageBucket: 'gs://flutterdb-1a2a7.appspot.com',
    ),
  );
  //Initializing Hive DataBase for offline/local storage of data
  await Hive.initFlutter();
// Register your adapter
  // Open the box and specify its type
  Hive.registerAdapter(FormModelAdapter());
  formData = await Hive.openBox<FormModel>('formData');
  // Initialize Firebase without options
  runApp(const MyApp());
}

final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
  "email",
]);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Your App Title',
      theme: ThemeData(
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String? userName;
  final String? email;
  const MyHomePage({Key? key, this.email, this.userName}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Stream<ConnectivityResult> connectivityStream;
  bool isOnline = false;
  GoogleSignInAccount? _currentUser;
  String? userEmail;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String connectionStatus = "Unknown";

  //getting the current user details
  @override
  void initState() {
    _googleSignIn.onCurrentUserChanged.listen((account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
    super.initState();
    connectivityStream = Connectivity().onConnectivityChanged;
    connectivityStream.listen((ConnectivityResult result) {
      setState(() {
        isOnline = (result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: const Text(""),
      ),
      body: Container(
        alignment: Alignment.center,
        child: _buildWidget(),
      ),
    );
  }

  Widget _buildWidget() {
    GoogleSignInAccount? user = _currentUser;
    return OnlineStatusWidget(child: Builder(
      builder: (context) {
        if (user != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                Text(' ${user.displayName ?? ''}'),
                Text(' ${user.email}'),
                const SizedBox(
                  height: 20,
                ),
                Text('Connection Status: ${isOnline ? "Online" : "Offline"}'),
                ElevatedButton(
                  onPressed: () {
                    //Navigate to FormPageOne using Navigator
                    String userEmail = user.email;
                    String userDisplayName = user.displayName ?? '';
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FormPageOne(
                          email: userEmail,
                          userName: userDisplayName,
                        ),
                      ),
                    );
                  },
                  child: const Text('Form'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    userEmail = user.email;
                    // Navigate to FormPageOne using Navigator
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Dashboard(
                                email: userEmail,
                              )),
                    );
                  },
                  child: const Text('Dashboard'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to FormPageOne using Navigator
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MainPage()),
                    );
                  },
                  child: const Text('map'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to FormPageOne using Navigator
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MainLens()),
                    );
                  },
                  child: const Text('Google Lens'),
                ),
                // Add spacing between button and "Sign Out" button
                ElevatedButton(
                  onPressed: signOut,
                  child: const Text('Sign Out'),
                ),
              ],
            ),
          );
        } else if (userEmail != null) {
          // User logged in using the API
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(
                  Icons
                      .people_alt_outlined, // Display a contact icon for API login
                  size: 48.0,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(' ${userEmail ?? ''}'), // Display userEmail
                const SizedBox(
                  height: 20,
                ),
                Text('Connection Status: ${isOnline ? "Online" : "Offline"}'),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to FormPageOne using Navigator
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FormPageOne(
                          email: userEmail,
                          userName:
                              '', // You can set a default user name here if needed
                        ),
                      ),
                    );
                  },
                  child: const Text('Form'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to FormPageOne using Navigator
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Dashboard(
                                email: userEmail,
                              )),
                    );
                  },
                  child: const Text('Dashboard'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to FormPageOne using Navigator
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MainPage()),
                    );
                  },
                  child: const Text('map'),
                )
              ],
            ),
          );
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Sign In to continue',
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text('Connection Status: ${isOnline ? "Online" : "Offline"}'),
                ElevatedButton(
                  onPressed: signIn,
                  child: const Text('Continue with Google'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    login(_emailController.text.toString(),
                        _passwordController.text.toString());
                  },
                  child: const Text('login'),
                ),
              ],
            ),
          );
        }
      },
    ));
  }

  //logic to login through email and password using API and http requests
  void login(String email, String password) async {
    try {
      Response response = await post(
        Uri.parse('https://reqres.in/api/login'),
        body: {'email': email, 'password': password},
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data);
        userEmail = email;
        if (kDebugMode) {
          print(email);
        }
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Dashboard(
                    email: email,
                  )),
        );
      } else {
        print('Request failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  //sign out logic
  void signOut() {
    _googleSignIn.disconnect();
  }

  //sign in logic with google account
  Future<void> signIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (e) {
      print(e);
    }
  }
}
