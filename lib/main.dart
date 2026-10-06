import 'package:flutter/material.dart';

/// Starts the application by running the root MYAPP widget.
void main() {
  runApp(const MyApp());
}

/// The font size shared by every Text widget on the student info screen.
///
/// Change this value while the app is running for example from 30.0 to
/// 60.0 and save the file to watch Flutter hot-reload the new size.


/// The root widget of the whole application.
///
/// This is a StatelessWidget because the app itself never changes while it
/// runs — it builds the MaterialApp once and shows _MyStudentInfo as its
/// home screen.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// Builds the MaterialApp, applies the theme, and sets the home screen
  /// to the student info page.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const _MyStudentInfo(),
    );
  }
}

/// Shows the student's name and number, the course code, and the lab number.
///
/// This is a StatelessWidget because the information it displays — name,
/// student number and course code — never changes while the program runs.
class _MyStudentInfo extends StatelessWidget {
  const _MyStudentInfo();

  /// Builds the screen: an APPBar plus a centered Column of Text
  /// widgets, each drawn at myFontSize.
  @override
  Widget build(BuildContext context) {
    double myFontSize = 20.0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Flutter Demo Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'My name is: Benjamin Mugenga - 041175488',
              style: TextStyle(fontSize: myFontSize),
            ),
            Text(
              'The course is CST2335',
              style: TextStyle(fontSize: myFontSize),
            ),
            Text(
              'Lab Assignment 1',
              style: TextStyle(fontSize: myFontSize),
            ),
          ],
        ),
      ),
    );
  }
}