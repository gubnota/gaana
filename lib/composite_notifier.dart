import 'package:flutter/foundation.dart';

import 'gaana_notifier.dart';

/// ChangeNotifier wrapper to combine several notifiers
class CompositeNotifier extends ChangeNotifier {
  final List<Listenable> _notifiers;

  CompositeNotifier(List<Listenable> notifiers)
    : _notifiers = List.from(notifiers) {
    for (final notifier in _notifiers) {
      notifier.addListener(_onChildChanged);
    }
  }

  void _onChildChanged() {
    notifyListeners();
  }

  /// Adds a new notifier.
  /// For GaanaNotifier, check if one with the same key already exists.
  void add(Listenable notifier) {
    if (notifier is GaanaNotifier) {
      if (_notifiers.any(
        (n) => n is GaanaNotifier && (n).key == notifier.key,
      )) {
        return;
      }
    } else {
      if (_notifiers.any((n) => n.runtimeType == notifier.runtimeType)) {
        return;
      }
    }
    _notifiers.add(notifier);
    notifier.addListener(_onChildChanged);
    notifyListeners();
  }

  /// Removes a notifier.
  /// For GaanaNotifier, only removes the one with the matching key.
  void remove(Listenable notifier) {
    if (notifier is GaanaNotifier) {
      _notifiers.removeWhere(
        (n) => n is GaanaNotifier && (n).key == notifier.key,
      );
    } else {
      _notifiers.remove(notifier);
    }
    notifier.removeListener(_onChildChanged);
    notifyListeners();
  }

  /// Returns the first notifier of type T that matches the optional [predicate] or key.
  /// if could also return a Notifier by its unique key
  T? get<T extends Listenable>({bool Function(T)? predicate, String? key}) {
    for (final notifier in _notifiers) {
      if (notifier is T) {
        if (notifier is GaanaNotifier && key != null) {
          if (notifier.key != key) continue;
        }
        if (predicate == null || predicate(notifier)) {
          return notifier;
        }
      }
    }
    return null;
  }

  List<Listenable> get notifiers => List.unmodifiable(_notifiers);

  /// Remove all notifiers and clear the list.
  void clean() {
    for (final notifier in _notifiers) {
      notifier.removeListener(_onChildChanged);
    }
    _notifiers.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    for (final notifier in _notifiers) {
      notifier.removeListener(_onChildChanged);
    }
    super.dispose();
  }
}
