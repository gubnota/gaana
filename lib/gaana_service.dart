import 'package:flutter/foundation.dart';
import 'composite_notifier.dart';

typedef GaanaCallback = void Function(CompositeNotifier notifier);

class GaanaService {
  // The singleton CompositeNotifier instance.
  static final CompositeNotifier _instance = CompositeNotifier([]);

  static CompositeNotifier get instance => _instance;

  /// Retrieve a notifier of type T. if Key is provided only notifier of a given key
  static T? get<T extends Listenable>({
    bool Function(T)? predicate,
    String? key,
  }) {
    return _instance.get<T>(predicate: predicate, key: key);
  }

  /// Add a notifier.
  static void add(Listenable notifier) {
    _instance.add(notifier);
  }

  /// Remove a notifier.
  static void remove(Listenable notifier) {
    _instance.remove(notifier);
  }

  /// Clean all notifiers.
  static void clean() {
    _instance.clean();
  }

  // /// Update the composite using a callback.
  // static void update(GaanaCallback callback) {
  //   callback(_instance);
  //   _instance.notifyListeners();
  // }
}
