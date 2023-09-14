import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_integrate/api/http_crud.dart';
import 'package:firebase_integrate/crud/sport_details.dart';
import 'package:firebase_integrate/dashboard/dashboard.dart';
import 'package:firebase_integrate/form/form_page_one.dart';
import 'package:firebase_integrate/routing/route_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyC36_6GMvkpinY3YMvlxuPQi8Fvogk5hoo',
      appId: '1:625310299583:android:a96427e5ce98bf3857dd0a',
      messagingSenderId: '625310299583',
      projectId: 'flutterdb-1a2a7',
    ),
  );
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
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
        MyAppRouteConstants.formRouteName: (context) => FormPageOne(),
        MyAppRouteConstants.sportsRouteName: (context) => SportDetails(),
        MyAppRouteConstants.httpRouteName: (context) => HttpCrud(),
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
  GoogleSignInAccount? _currentUser;
  String? userEmail;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
    if (user != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ListTile(
              title: Center(
                child: GoogleUserCircleAvatar(
                  identity: user,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(' ${user.displayName ?? ''}'),
            Text(' ${user.email}'),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to FormPageOne using Navigator
                if (user != null) {
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
                }
              },
              child: const Text('User Details Form'),
            ),
            const SizedBox(
              height: 20,
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     // Navigate to sports using Navigator
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const SportDetails(),
            //       ),
            //     );
            //   },
            //   child: const Text('Go to Fav Sport page'),
            // ),
            // const SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () {
            //     // Navigate to http requests using Navigator
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const HttpCrud(),
            //       ),
            //     );
            //   },
            //   child: const Text('http requests'),
            // ),
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
              Icons.people_alt_outlined, // Display a contact icon for API login
              size: 48.0,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(' ${userEmail ?? ''}'), // Display userEmail
            const SizedBox(
              height: 20,
            ),
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
              child: const Text('Go to FormPageOne'),
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
            )
            // ... Rest of your code ...
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
            ElevatedButton(
              onPressed: signIn,
              child: Text('Continue with Google'),
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
        print(email);
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
