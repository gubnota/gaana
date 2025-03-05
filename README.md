<p align="center">
	<img src="https://github.com/user-attachments/assets/0b5831cc-55ed-402a-a9f2-2b9f673364be" alt="Package Logo" />
</p>
<p align="center">
	<a href="https://opensource.org/licenses/MIT" rel="noopener" target="_blank"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="MIT License Badge"></a>
	<a href="https://github.com/EdsonBueno/infinite_scroll_pagination" rel="noopener" target="_blank"><img src="https://img.shields.io/badge/platform-flutter-ff69b4.svg" alt="Flutter Platform Badge"></a>
</p>

---
# Gaana App State management
A monolithic state machine using an InheritedWidget and a composite of Listenable objects.
It can replace ThemeProvider
Managing complex state in a Flutter app can be eased by libraries like BLoC, Provider, or Riverpod. However, for a deeper understanding or simply for the sake of simplicity and control you might want to build your own state management system from scratch without any external dependencies. This extension demonstrates one such approach by leveraging Flutter’s built‑in `InheritedWidget` and `Listenable` objects.


![video](https://github.com/user-attachments/assets/72c45221-1be8-49af-9a79-d42727429a5c)


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
  "Mark",
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


## Accessing Controllers
In any widget, you can retrieve a specific controller by using helper methods. For example:
```dart
final usersNotifier = Gaana.of(context).get<UsersNotifier>();
```

## Reacting to Changes
When any of your controllers change (e.g., when UsersNotifier shuffles the list), the CompositeNotifier calls notifyListeners(), causing the AppState to rebuild its dependents. This way, your UI stays in sync with your app state—all without relying on any external state management library.

## GaanaService listeners and hooks
Gaana is tightly coupled to UI and it's hard to implement larger apps without using streams. If you use `GaanaService.instance` singletone instead of `CompositeNotifier()` you can overcome these difficulties.
```dart
  final compositeNotifier = GaanaService.instance;
  compositeNotifier.add(usersNotifier);
  runApp(Gaana(child: const MyApp(), notifier: compositeNotifier));
// this will return true
GaanaService.instance.get<UsersNotifier>() ==
Gaana.of(context).get<UsersNotifier>() == gaana.context.get<UsersNotifier>();
GaanaService.instance.add(GaanaNotifier())

GaanaService.instance.add(GaanaNotifier(key: "unique1"));
GaanaNotifier? notifier = GaanaService.instance.get(key: "unique1");
notifier?.register("some_class_to_be_notified", () => print("callback"));
notifier?.addListener(() => {print("notifies its listeners")});
```
This way you can set multiple notifiers and modify reactive UI data from anywhere else.
Maybe it's not the optimal solution for larger apps since each notifier slows down reactiveness.