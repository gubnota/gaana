# Gaga App State management
A monolithic state machine using an InheritedWidget and a composite of Listenable objects.
It can replace ThemeProvider
Managing complex state in a Flutter app can be eased by libraries like BLoC, Provider, or Riverpod. However, for a deeper understanding or simply for the sake of simplicity and control you might want to build your own state management system from scratch without any external dependencies. This extension demonstrates one such approach by leveraging Flutter’s built‑in `InheritedWidget` and `Listenable` objects.


![video](https://github.com/user-attachments/assets/7917f9c5-03e2-43bf-93bd-ad4d4f385dc7)


## How to use
0. Wrap a desired part (or whole app) with Gaana widget:
```dart
runApp(Gaana(child: const MyApp()));
```
From anywhere in the code use `context.gaana` or `Gaana.of(context)` to access it.
`CompositeNotifier` – holder of all other notifiers – is created by default.

1. Then you need to define a notifier (a class should extend ValueNotifier or ChangeNotifier):

```dart
const List<String> exampleUsers = [
  "Helly",
  "Milchick",
  "Irving",
  "Ms.Cobel",
  "Kier",
];

class UsersNotifier extends ChangeNotifier {
  List<String> _users;
  UsersNotifier(this._users);
  List<String> get users => _users;
  /// Shuffles the list and notifies listeners.
  void shuffle() {
    _users.shuffle();
    notifyListeners();
  }
}
```
2. Then add that notifier to the pool (you can do it on Gaana initialization or later):
```dart
context.gaana.add(UsersNotifier(exampleUsers));
// or 
final users = UsersNotifier(exampleUsers);
runApp(Gaana(child: const MyApp(),notifier:CompositeNotifier([users])));
```
3. To access the users from within stateless widgets or anywhere where the context is available:
```dart
context.gaana.get<UsersNotifier>()?.users;
```

## Example
```dart
import 'package:flutter/material.dart';
import 'package:gaana/gaana.dart';
import 'package:gaana/example.dart';

void main() {
  final usersNotifier = UsersNotifier(exampleUsers);
  final compositeNotifier = CompositeNotifier([usersNotifier]);
  runApp(Gaana(child: const MyApp(), notifier: compositeNotifier));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Halves',
      initialRoute: '/',
      routes: {'/': (context) => GaanaExample()},
    );
  }
}
```
Or more advanced with ThemeProvider:
```dart
import 'package:flutter/material.dart';
import 'package:gaana/gaana.dart';
import 'package:gaana/example.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  void toggleTheme(bool isOn) {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setTheme(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}

void main() {
  final usersNotifier = UsersNotifier(exampleUsers);
  final themeNotifier = ThemeProvider();
  final compositeNotifier = CompositeNotifier([usersNotifier, themeNotifier]);
  runApp(Gaana(child: const MyApp(), notifier: compositeNotifier));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Halves',
      initialRoute: '/',
      themeMode: context.gaana.get<ThemeProvider>()?.themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      routes: {'/': (context) => GaanaExample()},
    );
  }
}
```

## Accessing Controllers
In any widget, you can retrieve a specific controller by using helper methods. For example:
```dart
final usersNotifier = Gaana.of(context).getNotifier<UsersNotifier>();
```

## Reacting to Changes
When any of your controllers change (e.g., when UsersNotifier shuffles the list), the CompositeNotifier calls notifyListeners(), causing the AppState to rebuild its dependents. This way, your UI stays in sync with your app state—all without relying on any external state management library.

## Disadvantages
Gaana is tightly coupled to UI and it's hard to implement larger apps witout using streams.

## Conclusion
This extension demonstrates a very simple, monolithic state management system built from scratch using Flutter’s InheritedWidget and Listenable interface.
It follows the SOLID principle of depending on abstractions (Listenable) and keeps the reactive code minimal.
If you want to understand the fundamentals of state management in Flutter or build your own lightweight solution, this approach is an excellent starting point.
Gaana uses Flutter’s built‑in InheritedWidget and Listenable (often via ChangeNotifier). But you need to access state via the widget tree (using BuildContext).
