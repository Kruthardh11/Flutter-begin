import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_integrate/api/api_page.dart';
import 'package:firebase_integrate/crud/sport_details.dart';
import 'package:firebase_integrate/form/form_page_one.dart';
import 'package:firebase_integrate/api/http_crud.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
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
        ));
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
                height:
                    20), // Add spacing between ListTile and user information
            Text(' ${user.displayName ?? ''}'),
            Text(' ${user.email}'),
            const SizedBox(
                height: 20), // Add spacing between user information and button
            ElevatedButton(
              onPressed: () {
                // Navigate to FormPageOne
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FormPageOne(
                      userName: user.displayName,
                      email: user.email,
                    ),
                  ),
                );
              },
              child: const Text('Go to FormPageOne'),
            ),
            const SizedBox(
                height: 20), // Add spacing between user information and button
            ElevatedButton(
              onPressed: () {
                // Navigate to FormPageOne
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SportDetails(),
                  ),
                );
              },
              child: const Text('Go to Fav Sport page'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to FormPageOne
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HttpCrud(),
                  ),
                );
              },
              child: const Text('Go to Fav Sport page'),
            ),
            const SizedBox(
                height: 20), // Add spacing between user information and button
            ElevatedButton(
              onPressed: () {
                // Navigate to ApiPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ApiPage(),
                  ),
                );
              },
              child: const Text('Manga Page'),
            ),
            const SizedBox(
                height: 20), // Add spacing between button and "Sign Out" button
            ElevatedButton(
              onPressed: signOut,
              child: const Text('Sign Out'),
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // centering the content
          children: <Widget>[
            const Text(
              'Sign In to continue',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20), // Add spacing between text and button
            ElevatedButton(
              onPressed: signIn,
              child: const Text('Sign In'),
            ),
          ],
        ),
      );
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
