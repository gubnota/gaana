
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
      initialRoute: '/',
      themeMode: context.gaana.get<ThemeProvider>()?.themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      routes: {'/': (context) => GaanaExample()},
    );
  }
}
```