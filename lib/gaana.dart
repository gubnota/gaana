import 'package:flutter/widgets.dart';

class CompositeNotifier extends ChangeNotifier {
  final List<Listenable> _notifiers;

  CompositeNotifier(List<Listenable> notifiers)
    : _notifiers = List.from(notifiers) {
    for (final notifier in _notifiers) {
      notifier.addListener(_onChildChanged);
    }
  }

  void _onChildChanged() {
    // Simply forward the notification.
    notifyListeners();
  }

  /// Add a new notifier if one of that type does not already exist.
  void add(Listenable notifier) {
    // Check if a notifier of the same runtimeType is already present.
    if (!_notifiers.any((n) => n.runtimeType == notifier.runtimeType)) {
      _notifiers.add(notifier);
      notifier.addListener(_onChildChanged);
      notifyListeners();
    }
  }

  /// Remove a notifier.
  void remove(Listenable notifier) {
    notifier.removeListener(_onChildChanged);
    _notifiers.remove(notifier);
    notifyListeners();
  }

  /// Returns the first notifier of type T that matches [predicate] (if given),
  /// or null if none is found.
  T? get<T extends Listenable>({bool Function(T)? predicate}) {
    for (final notifier in _notifiers) {
      if (notifier is T) {
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

/// Extension on BuildContext so you can easily retrieve the notifier.
extension GaanaExtension on BuildContext {
  CompositeNotifier get gaana {
    // access state by context.gaana
    final widget = dependOnInheritedWidgetOfExactType<Gaana>();
    if (widget == null || widget.notifier == null) {
      throw Exception("No Gaana found in context");
    }
    return widget.notifier!;
  }
}

class Gaana extends InheritedNotifier<CompositeNotifier> {
  Gaana({super.key, CompositeNotifier? notifier, required super.child})
    : super(notifier: notifier ?? CompositeNotifier([]));

  /// Helper method to get the composite notifier.
  static CompositeNotifier of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<Gaana>();
    if (result == null || result.notifier == null) {
      throw Exception("No Gaana found in context");
    }
    return result.notifier!;
  }
}
