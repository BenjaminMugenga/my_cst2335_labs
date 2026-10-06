import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 2',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const MyHomePage(title: 'Login Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Controllers let us read what the user typed
  late TextEditingController _loginController;
  late TextEditingController _passwordController;

  // Which picture to show. Starts as the question mark.
  var imageSource = "images/question-mark.png";

  // NEW: the current language ("en" = English, "fr" = French)
  String _language = "en";

  // NEW: every piece of text on the screen, in both languages
  final Map<String, Map<String, String>> _text = {
    "en": {
      "title": "Login Page",
      "loginName": "Login name",
      "password": "Password",
      "loginButton": "Login",
      "switchButton": "Français",
    },
    "fr": {
      "title": "Page de connexion",
      "loginName": "Nom d'utilisateur",
      "password": "Mot de passe",
      "loginButton": "Connexion",
      "switchButton": "English",
    },
  };

  // NEW: looks up a word in the current language
  String t(String key) {
    return _text[_language]![key]!;
  }

  // NEW: flips between English and French
  void _switchLanguage() {
    setState(() {
      if (_language == "en") {
        _language = "fr";
      } else {
        _language = "en";
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loginController = TextEditingController();
    _passwordController = TextEditingController();
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
    print("Password typed: $password");

    // Change the picture and redraw the screen
    setState(() {
      if (password == "good") {
        imageSource = "images/light-bulb.png";
      } else {
        imageSource = "images/stop-sign.png";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(t("title")),
        // NEW: language switch button in the top-right corner
        actions: [
          TextButton(
            onPressed: _switchLanguage,
            child: Text(t("switchButton")),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          // Lets the page scroll if the image doesn't fit
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Login name field
                TextField(
                  controller: _loginController,
                  decoration: InputDecoration(
                    labelText: t("loginName"),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                // Password field (hidden text)
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: t("password"),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                // Login button
                ElevatedButton(
                  onPressed: _login,
                  child: Text(t("loginButton")),
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