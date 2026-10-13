import 'package:flutter/material.dart';
import 'DataRepository.dart'; // WEEK 5
import 'ProfilePage.dart';    // WEEK 5
import 'Translations.dart';   // WEEK 5

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 5',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      // WEEK 5: two pages, navigated by name (replaces home:)
      initialRoute: '/loginPage',
      routes: {
        '/loginPage': (context) => const MyHomePage(),
        '/profilePage': (context) => const ProfilePage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Controllers let us read what the user typed
  late TextEditingController _loginController;
  late TextEditingController _passwordController;

  // Which picture to show. Starts as the question mark.
  var imageSource = "images/question-mark.png";

  @override
  void initState() {
    super.initState();
    _loginController = TextEditingController();
    _passwordController = TextEditingController();

    // WEEK 5: start loading the saved profile data as soon as the app opens
    DataRepository.loadData();
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Runs when the Login button is pressed
  void _login() {
    String password = _passwordController.text;

    if (password == "good") {
      setState(() {
        imageSource = "images/light-bulb.png";
      });

      // WEEK 5: remember the login name and go to the second page
      DataRepository.loginName = _loginController.text;
      Navigator.pushNamed(context, '/profilePage').then((_) {
        // When we come back, redraw in case the language was changed
        setState(() {});
      });
    } else {
      setState(() {
        imageSource = "images/stop-sign.png";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(translate("title")),
        // Language switch button in the top-right corner
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                switchLanguage(); // WEEK 5: from Translations.dart
              });
            },
            child: Text(translate("switchButton")),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Login name field
                TextField(
                  controller: _loginController,
                  decoration: InputDecoration(
                    labelText: translate("loginName"),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                // Password field (hidden text)
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: translate("password"),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                // Login button
                ElevatedButton(
                  onPressed: _login,
                  child: Text(translate("loginButton")),
                ),
                const SizedBox(height: 16),
                // The 300 x 300 image
                Image.asset(
                  imageSource,
                  width: 300,
                  height: 300,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}