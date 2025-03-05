import 'dart:async';
import 'dart:ui';
import 'plot_repository.dart';
import 'plot_notifier.dart';

class PetrolUseCase {
  final PlotRepository repository;
  final PlotNotifier plotNotifier;
  Timer? _timer;
  Offset? _lastDot;

  PetrolUseCase({required this.repository, required this.plotNotifier});

  /// Initiates the process:
  /// 1. Fills the tank (simulated delay).
  /// 2. Then starts generating new dots periodically.
  /// If a dot’s y value is >= 11, prints a message and resets the plot.
  void start() {
    repository.fillTheTank(() {
      // Set an initial dot (choose a starting point, for example x=0, y=10)
      _lastDot = const Offset(0, 10);
      plotNotifier.addDot(_lastDot!);
      // Start generating new dots periodically.
      _timer = Timer.periodic(const Duration(milliseconds: 50), (_) {
        if (_lastDot == null) return;
        final newDot = repository.genVal(_lastDot!);
        // If the new dot's y is <= -8, print message and reset.
        if (newDot.dy >= 11) {
          // debugPrint("y reached 11; resetting plot.");
          // plotNotifier.clean();
          // _lastDot = const Offset(0, 10); // Reset starting point.
          // plotNotifier.addDot(_lastDot!);
        } else {
          _lastDot = newDot;
          plotNotifier.addDot(newDot);
        }
      });
    });
  }

  void stop() {
    _timer?.cancel();
  }
}
