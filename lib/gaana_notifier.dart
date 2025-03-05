import 'package:flutter/foundation.dart';

typedef GaanaCallback = void Function();

class GaanaNotifier extends ChangeNotifier {
  final Map<String, GaanaCallback> _callbacks = {};
  final String key;
  GaanaNotifier({this.key = "generic"});

  /// Register a callback with a unique key.
  /// you can use addListener() as well
  void register(String key, GaanaCallback callback) {
    _callbacks[key] = callback;
  }

  /// Deregister a callback by its key.
  /// you can use removeListener() as well
  void deregister(String key) {
    _callbacks.remove(key);
  }

  /// Remove all callbacks.
  void clear() {
    _callbacks.clear();
  }

  /// Instead of notifyListeners(), call notify() which triggers
  /// all registered callbacks and then notifies Flutter.
  void notify() {
    for (final callback in _callbacks.values) {
      callback();
    }
    notifyListeners();
  }
}
