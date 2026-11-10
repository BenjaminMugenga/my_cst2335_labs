import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'AppLocalizations.dart';
import 'AppDatabase.dart'; // gives us AppDatabase AND the generated Contact class

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  /// Call this from anywhere to switch the app's language.
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.changeLanguage(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en', 'CA');

  void changeLanguage(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Week 8 Lab',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // ----- Translation setup -----
      locale: _locale,
      supportedLocales: const [
        Locale('en', 'CA'),
        Locale('fr', 'CA'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  // The database (opened once when the page is created)
  late AppDatabase db;

  // The data behind the ListView
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();

    db = AppDatabase(); // open the database
    loadContacts(); // MARK 2: reload what was saved before
  }

  /// MARK 2: runs SELECT * FROM ContactTable and puts the rows in the list.
  Future<void> loadContacts() async {
    List<Contact> saved = await db.getAllContacts().get();
    setState(() {
      contacts = saved;
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    db.close(); // close the database when the page is destroyed
    super.dispose();
  }

  /// Short helper so we can write t("key") instead of the long version.
  String t(String key) {
    return AppLocalizations.of(context)!.translate(key);
  }

  /// "Enter" button: save to the database, add to the list, clear the fields.
  Future<void> addContact() async {
    String first = _firstNameController.text.trim();
    String last = _lastNameController.text.trim();
    String phone = _phoneController.text.trim();
    String email = _emailController.text.trim();

    if (first.isEmpty || last.isEmpty || phone.isEmpty || email.isEmpty) {
      // Path: a field is empty -> do not add, tell the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t('fill_all_fields'))),
      );
    } else {
      // MARK 1: the generated INSERT function. It returns the new row's id.
      int newId = await db.saveContact(first, last, phone, email);

      // Keep the id in the list item so we can delete it from the DB later
      setState(() {
        contacts.add(Contact(
          id: newId,
          firstName: first,
          lastName: last,
          phone: phone,
          email: email,
        ));
      });
      _firstNameController.clear();
      _lastNameController.clear();
      _phoneController.clear();
      _emailController.clear();
    }
  }

  /// Long-press on a row: ask if the user wants to delete it.
  void showDeleteDialog(int index) {
    Contact contact = contacts[index];

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(t('delete_title')),
          content: Text(
              '${t('delete_question')} ${contact.firstName} ${contact.lastName}?'),
          actions: [
            // YES -> delete from DB, remove from list, close dialog
            TextButton(
              onPressed: () async {
                // MARK 3: DELETE FROM ContactTable WHERE id = :id
                await db.deleteContact(contact.id);
                setState(() {
                  contacts.removeAt(index);
                });
                if (dialogContext.mounted) Navigator.pop(dialogContext);
              },
              child: Text(t('yes')),
            ),
            // NO -> just close dialog, list stays the same
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(t('no')),
            ),
          ],
        );
      },
    );
  }

  /// Switches between English and French.
  void toggleLanguage() {
    String current = Localizations.localeOf(context).languageCode;
    if (current == 'en') {
      MyApp.setLocale(context, const Locale('fr', 'CA'));
    } else {
      MyApp.setLocale(context, const Locale('en', 'CA'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(t('app_title')),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: toggleLanguage,
            child: Text(t('switch_language')),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListPage(),
      ),
    );
  }

  /// The page with the 4 TextFields, the Enter button and the ListView.
  // ignore: non_constant_identifier_names
  Widget ListPage() {
    return Column(
      children: [
        TextField(
          controller: _firstNameController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: t('first_name'),
            hintText: t('type_here'),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _lastNameController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: t('last_name'),
            hintText: t('type_here'),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: t('phone'),
            hintText: t('type_here'),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: t('email'),
            hintText: t('type_here'),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: addContact,
          child: Text(t('enter')),
        ),
        const SizedBox(height: 12),

        // Expanded = the list takes the rest of the screen height
        Expanded(
          child: contacts.isEmpty
          // Path: empty list -> show message
              ? Center(child: Text(t('empty_list')))
          // Path: list has items -> show ListView
              : ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (BuildContext context, int rowNum) {
              Contact c = contacts[rowNum];
              return ListTile(
                title: Text('${c.firstName} ${c.lastName}'),
                subtitle: Text('${c.phone} • ${c.email}'),
                onLongPress: () {
                  showDeleteDialog(rowNum);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}