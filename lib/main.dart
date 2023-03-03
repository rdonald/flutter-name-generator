import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:english_words/english_words.dart';

void main() {
  // Tells Flutter to run the app defined in MainApp
  runApp(const MainApp());
}

/* 
* Widgets are the elements from which you build every Flutter app. As you can see, even the app itself is a widget.
* The code in MyApp sets up the whole app. It creates the app-wide state, names the app, defines 
* the visual theme, and sets the "home" widget—the starting point of your app.
*/
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // The state is created and provided to the whole app using a ChangeNotifierProvider. This allows any widget to get state
    return ChangeNotifierProvider(
        create: (context) => MyAppState(),
        child: MaterialApp(
          title: 'Name Generator',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          ),
          home: MyHomePage(),
        ));
  }
}

/*
* Simple State managment class, ChangeNotifier can notify other widgets about it's own changes. For example,
* if the word pairing changes some of the widgets in the app need to know this.
*/
class MyAppState extends ChangeNotifier {
  // Pair random word
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    // notifyListeners() is a method of ChangeNotifier that ensures that anyone watching MyAppState is notified
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              extended: false,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.favorite),
                  label: Text('Favorites'),
                ),
              ],
              selectedIndex: 0,
              onDestinationSelected: (value) {
                print('selected: $value');
              },
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: GeneratorPage(),
            ),
          ),
        ],
      ),
    );
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
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
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
    var theme = Theme.of(context);
    // By using theme.textTheme, you access the app's font theme
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(pair.asLowerCase,
            style: style, semanticsLabel: pair.asPascalCase),
      ),
    );
  }
}
