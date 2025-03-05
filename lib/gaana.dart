import 'package:flutter/widgets.dart';
import 'composite_notifier.dart';
export 'gaana_service.dart';
export 'gaana_notifier.dart';

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
