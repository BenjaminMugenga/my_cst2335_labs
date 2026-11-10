import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'DataRepository.dart';
import 'Translations.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();

    // Put the loaded data from the repository into the TextFields
    _firstNameController = TextEditingController(text: DataRepository.firstName);
    _lastNameController = TextEditingController(text: DataRepository.lastName);
    _phoneController = TextEditingController(text: DataRepository.phoneNumber);
    _emailController = TextEditingController(text: DataRepository.emailAddress);

    // Save every time the text changes
    _firstNameController.addListener(_saveFields);
    _lastNameController.addListener(_saveFields);
    _phoneController.addListener(_saveFields);
    _emailController.addListener(_saveFields);

    // Show "Welcome Back <name>" SnackBar after the page is drawn
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${translate("welcomeBack")} ${DataRepository.loginName}"),
        ),
      );
    });
  }

  // Listener: copy the text into the repository, then save it
  void _saveFields() {
    DataRepository.firstName = _firstNameController.text;
    DataRepository.lastName = _lastNameController.text;
    DataRepository.phoneNumber = _phoneController.text;
    DataRepository.emailAddress = _emailController.text;
    DataRepository.saveData();
  }

  // Open tel: / sms: / mailto: — or show an AlertDialog if not supported
  Future<void> _launchOrAlert(String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (BuildContext ctx) => AlertDialog(
          title: Text(translate("notSupportedTitle")),
          content: Text("${translate("notSupportedMsg")} $url"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(translate("ok")),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(translate("profileTitle")),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                switchLanguage();
              });
            },
            child: Text(translate("switchButton")),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Text at the top: "Welcome Back <name>"
              Text(
                "${translate("welcomeBack")} ${DataRepository.loginName}",
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 16),

              // First Name
              TextField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: translate("firstName"),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Last Name
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: translate("lastName"),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Phone Number + Telephone + SMS buttons
              Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: translate("phoneNumber"),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _launchOrAlert("tel:${_phoneController.text}"),
                    child: const Icon(Icons.phone),
                  ),
                  ElevatedButton(
                    onPressed: () => _launchOrAlert("sms:${_phoneController.text}"),
                    child: const Icon(Icons.sms),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Email address + mail button
              Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: translate("emailAddress"),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _launchOrAlert("mailto:${_emailController.text}"),
                    child: const Icon(Icons.mail),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}