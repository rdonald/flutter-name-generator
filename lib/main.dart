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
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // build method is called automatically every time a widget is changed. So the widget is up to date.

    // Tracks changes in the app state using the watch method.
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    // Every build method must return a widget or a nested tree of widgets.
    return Scaffold(
      // Column is a basic layout widget in Flutter. It takes any number of children and puts them in a column from top to bottom
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          // Takes appState, and accesses the only member of that class, current word pair
          BigCard(pair: pair),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              appState.getNext();
            },
            child: Text('Next'),
          )
        ]),
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
