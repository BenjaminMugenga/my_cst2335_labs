import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 3',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Week 3 Layouts'),
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
  // Style used for the 5 lines of text in the Column
  static const TextStyle headingStyle =
  TextStyle(fontSize: 22, fontWeight: FontWeight.bold);

  // Style used for the words drawn on top of the images
  static const TextStyle overlayStyle = TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.bold,
    backgroundColor: Colors.black54,
  );

  /// Builds ONE image: a Stack with the circle picture underneath
  /// and the text on top, placed wherever [position] says.
  Widget makeImage(String imagePath, String word, AlignmentGeometry position) {
    return Stack(
      alignment: position, // Alignment.center or Alignment.bottomCenter
      children: [
        CircleAvatar(
          backgroundImage: AssetImage(imagePath),
          radius: 45,
        ),
        Text(word, style: overlayStyle),
      ],
    );
  }

  /// Builds the title Text + the Row of 4 images.
  /// Returns a List so we can spread it into the Column with "...",
  /// which keeps every Text and Row as a direct child of the Column (8 items).
  List<Widget> makeRow(String title, List<String> images, List<String> words,
      AlignmentGeometry position) {
    List<Widget> pictures = [];
    for (int i = 0; i < images.length; i++) {
      pictures.add(makeImage(images[i], words[i], position));
    }

    return [
      Text(title, style: headingStyle),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: pictures,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start, // text on the left
          children: [
            // 1
            const Text('BROWSE CATEGORIES', style: headingStyle),
            // 2 + 3
            ...makeRow(
              'By Meat',
              [
                'images/beef.jpg',
                'images/chicken.jpg',
                'images/pork.jpg',
                'images/seafood.jpg'
              ],
              ['Beef', 'Chicken', 'Pork', 'Seafood'],
              Alignment.center, // text in the MIDDLE of the image
            ),
            // 4 + 5
            ...makeRow(
              'By Course',
              [
                'images/Main Dishes.jpg',
                'images/salad.jpg',
                'images/sidedish.jpg',
                'images/crockpot.jpg'
              ],
              ['Main Dishes', 'Salad Recipes', 'Side Dishes', 'Crockpot'],
              Alignment.bottomCenter, // text at the BOTTOM of the image
            ),
            // 6 + 7
            ...makeRow(
              'By Dessert',
              [
                'images/icecream.jpg',
                'images/Brownies.jpg',
                'images/Pies.jpg',
                'images/Cookies.jpg'
              ],
              ['Ice Cream', 'Brownies', 'Pies', 'Cookies'],
              Alignment.bottomCenter,
            ),
            // 8
            const Text('VIEW ALL RECIPES', style: headingStyle),
          ],
        ),
      ),
    );
  }
}