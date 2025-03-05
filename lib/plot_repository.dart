import 'dart:async';
import 'dart:math';
import 'dart:ui';

class PlotRepository {
  final Random random = Random();

  /// Simulates a process to "fill the tank" (e.g. preload initial data).
  Future<void> fillTheTank(VoidCallback callback) async {
    await Future.delayed(const Duration(seconds: 1));
    callback();
  }

  /// Generates a new dot based on the previous dot.
  /// Increments x by 1 and computes:
  ///    y = 10 * sin(x/4) + Random(0, 5)
  Offset genVal(Offset previous) {
    final newX = previous.dx + 1;
    final newY = 10 * sin(newX / 4) + random.nextDouble() * 5;
    return Offset(newX, newY);
  }
}
