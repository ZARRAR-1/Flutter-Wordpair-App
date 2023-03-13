import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'favourites_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      // context is an object ob BuildContext,
      //it stores the current state of the app by calling MyAppState constructor repeatitively
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  // ↓ Added this.
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  // ↓ Added the code below.
  var favorites = <WordPair>[]; // NEW THING: List of type WordPair
  // var fav = new WordPair(); //Can't be Done
  // var fav2 = WordPair; // FINE

  //You also added a new method, toggleFavorite(),
  // which either removes the current word pair from the list of favorites
  // (if it's already there), or adds it (if it isn't there yet).
  // In either case, the code calls notifyListeners(); afterwards
  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

// class MyHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     var appState = context.watch<MyAppState>();
//
//     var pair = appState.current;                 // ← Added this.
//
//     // ↓ Added this.
//     IconData icon;
//     if (appState.favorites.contains(pair)) {
//       icon = Icons.favorite; //Filled Icon
//     } else {
//       icon = Icons.favorite_border; //UnFilled Icon
//     }
//
//     return Scaffold(
//       body: SafeArea(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,  // ← Added this
//             children: [
//               Text('A random word:'),
//
//               // Text(appState.current.asLowerCase),
//
//               BigCard(pair: pair),
//
//               Row(
//                 // mainAxisAlignment: MainAxisAlignment.center,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//
//                   // ↓ Added this.
//                   ElevatedButton.icon(
//                       onPressed: () {
//                         // print('Button Pressed');
//                         appState.toggleFavorite();
//                       },
//                     icon: Icon(icon),
//                     label: Text('Like'),
//                   ),
//
//
//                   ElevatedButton(
//                       onPressed: () {
//                         // print('Button Pressed');
//                         appState.getNext();
//                       }
//                       ,
//                       child: Text('Next Word')
//                   ),
//
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndexNum = 0; // ← Added this property.

  @override
  Widget build(BuildContext context) {
    // ↓ Added the code below.
    Widget page;

    switch (selectedIndexNum) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndexNum');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: SafeArea(
          child: Row(
            children: [
              SafeArea(
                child: Expanded(
                  child: NavigationRail(
                    trailing: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(child: Text('\n\nDeveloped By:\nSNOWLEOPARDS', style:  TextStyle(fontSize: 10, color: Colors.black54,fontWeight: FontWeight.bold))),
                    ),
                    elevation: 20, //Creates a shadow
                    // extended: false,
                    // extended: true,
                    extended: constraints.maxWidth >= 600,
                    // ← Added Here.
                    destinations:[
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label: Text('Home'),

                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.favorite),
                        label: Text('Favorites'),
                      ),
                    ],
                    // selectedIndex: 0,
                    selectedIndex: selectedIndexNum,
                    // ← Change to this.

                    // When the onDestinationSelected callback is called,
                    // instead of merely printing the new value to console,
                    // you assign it to selectedIndexNum inside a setState() call.
                    // This call is similar to the notifyListeners() method
                    // used previously—it makes sure that the UI updates:
                    onDestinationSelected: (value) {
                      // print('selected: $value');

                      // ↓ Replaced print with this.
                      setState(() {
                        selectedIndexNum = value;
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  // child: GeneratorPage(),

                  child: page, // ← Added Here.
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;

    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: () {
                  appState.getNext();
                },
                icon: Icon(Icons.navigate_next),
                label: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context); // ← Added this.

    return Card(
      color: theme.colorScheme.primary, // ← And also Added this.
      elevation: 20, //increases cards shadow
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            pair.asPascalCase,
            style: theme.textTheme.displayMedium,
          ),
        ),
      ),
    );
  }
}
