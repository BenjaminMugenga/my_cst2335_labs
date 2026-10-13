import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 4',
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

  // The current language ("en" = English, "fr" = French)
  String _language = "en";

  // Secure storage for the login name and password
  final EncryptedSharedPreferences _prefs = EncryptedSharedPreferences();

  // Every piece of text on the screen, in both languages
  final Map<String, Map<String, String>> _text = {
    "en": {
      "title": "Login Page",
      "loginName": "Login name",
      "password": "Password",
      "loginButton": "Login",
      "switchButton": "Français",
      "dialogTitle": "Save login?",
      "dialogMessage": "Would you like to save your login name and password for next time?",
      "yes": "Yes",
      "no": "No",
      "loaded": "Your previous login name and password have been loaded.",
    },
    "fr": {
      "title": "Page de connexion",
      "loginName": "Nom d'utilisateur",
      "password": "Mot de passe",
      "loginButton": "Connexion",
      "switchButton": "English",
      "dialogTitle": "Enregistrer la connexion ?",
      "dialogMessage": "Voulez-vous enregistrer votre nom d'utilisateur et votre mot de passe pour la prochaine fois ?",
      "yes": "Oui",
      "no": "Non",
      "loaded": "Votre nom d'utilisateur et votre mot de passe précédents ont été chargés.",
    },
  };

  // Looks up a word in the current language
  String t(String key) {
    return _text[_language]![key]!;
  }

  // Flips between English and French
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
    _loadLogin(); // load saved login name and password
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

    // Change the picture and redraw the screen
    setState(() {
      if (password == "good") {
        imageSource = "images/light-bulb.png";
      } else {
        imageSource = "images/stop-sign.png";
      }
    });

    // Ask if the user wants to save their login
    _showSaveDialog();
  }

  // The AlertDialog asking to save the login name and password
  void _showSaveDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(t("dialogTitle")),
          content: Text(t("dialogMessage")),
          actions: [
            // "No" button: erase saved data
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _clearLogin();
              },
              child: Text(t("no")),
            ),
            // "Yes" button: save the strings
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _saveLogin();
              },
              child: Text(t("yes")),
            ),
          ],
        );
      },
    );
  }

  // "Yes" was pressed: save both strings
  void _saveLogin() async {
    await _prefs.setString("loginName", _loginController.text);
    await _prefs.setString("password", _passwordController.text);
  }

  // "No" was pressed: erase anything that was saved
  void _clearLogin() async {
    await _prefs.clear();
  }
  // Runs at startup: load saved strings, if there are any
  void _loadLogin() async {
    String savedLogin = await _prefs.getString("loginName");
    String savedPassword = await _prefs.getString("password");

    // Only fill the fields if something was actually saved
    if (savedLogin.isNotEmpty && savedPassword.isNotEmpty) {
      _loginController.text = savedLogin;
      _passwordController.text = savedPassword;

      // Make sure the page is still on screen before showing the Snackbar
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t("loaded"))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(t("title")),
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