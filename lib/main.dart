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
      title: 'Week 9 Lab',
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

  // WEEK 9: the contact that was tapped. null = no details page showing.
  Contact? selectedItem;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();

    db = AppDatabase(); // open the database
    loadContacts(); // reload what was saved before
  }

  /// Runs SELECT * FROM ContactTable and puts the rows in the list.
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t('fill_all_fields'))),
      );
    } else {
      // INSERT returns the new row's id
      int newId = await db.saveContact(first, last, phone, email);

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

  /// WEEK 9 (task 3): delete the selected contact from the DB and the list,
  /// then hide the details page.
  Future<void> deleteSelected() async {
    if (selectedItem == null) return;
    int idToDelete = selectedItem!.id;

    await db.deleteContact(idToDelete); // DELETE FROM ContactTable WHERE id = :id

    setState(() {
      contacts.removeWhere((c) => c.id == idToDelete);
      selectedItem = null; // details disappear
    });
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
        child: reactiveLayout(), // WEEK 9: was ListPage()
      ),
    );
  }

  /// WEEK 9 (tasks 1 & 2): pick the layout based on screen size.
  // ignore: non_constant_identifier_names
  Widget reactiveLayout() {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;

    if ((width > height) && (width > 720)) {
      // Landscape / tablet / desktop: list on the left, details on the right
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 1, child: ListPage()),
          const SizedBox(width: 12),
          Expanded(flex: 1, child: DetailsPage()),
        ],
      );
    } else {
      // Phone / portrait: details replace the list
      if (selectedItem == null) {
        return ListPage();
      } else {
        return DetailsPage();
      }
    }
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
              ? Center(child: Text(t('empty_list')))
              : ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (BuildContext context, int rowNum) {
              Contact c = contacts[rowNum];
              return ListTile(
                title: Text('${c.firstName} ${c.lastName}'),
                subtitle: Text('${c.phone} • ${c.email}'),
                selected: selectedItem?.id == c.id,
                // WEEK 9 (task 1): tap instead of long-press
                onTap: () {
                  setState(() {
                    selectedItem = c;
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  /// WEEK 9: details of the selected contact, with Delete and Close buttons.
  // ignore: non_constant_identifier_names
  Widget DetailsPage() {
    if (selectedItem == null) {
      // Landscape with nothing selected: empty right side
      return const Center(child: Text(''));
    }

    Contact c = selectedItem!;

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${c.firstName} ${c.lastName}',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text('${t('phone')}: ${c.phone}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('${t('email')}: ${c.email}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Database id: ${c.id}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Task 3: Delete from list AND database
                ElevatedButton(
                  onPressed: deleteSelected,
                  child: const Text('Delete'),
                ),
                const SizedBox(width: 16),
                // Task 4: Close = just set selectedItem back to null
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedItem = null;
                    });
                  },
                  child: const Text('Close'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}