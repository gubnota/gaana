import 'package:flutter/material.dart';
import 'gaana_notifier.dart'; // Base class that supports callback registration.
/*
now I need to write plot_notifier with a key = 'graph1' for the first graph.
There should be two instances, one could be from Repository layer, the other from PetrolUseCase.
there is a func that feeds Repository with new dots. These dots are List<Offset>.
there are methods in plot notifier to add a new dot and to clean all dots.
PetrolUseCase should initiate FillTheTank by Repository
After tank is filled (within one sec timeout), it calls a callback at PetrolUseCase
Then PetrolUseCase start generating new values by calling Repository another method genval()
and adds this value to a plot_notifier.
genval() works the following way: it checks with a previously generated value's x, increments one in x axis, and as for y:
y=10\cdot \sin \left( \frac{x}{4} \right) + Random(0,5)

When it reaches y=-8 somewhere on the graph it prints out a message and cleans all Offset dots plot_notifier and starts over again.

class GaanaNotifier extends ChangeNotifier {
  /// Register a callback with a unique key.
  void register(String key, GaanaCallback callback) {
    _callbacks[key] = callback;
  }
  /// Deregister a callback by its key.
  void deregister(String key) {
    _callbacks.remove(key);
  }
  /// Remove all callbacks.
  void clear() {
    _callbacks.clear();
  }}

*/

class PlotNotifier extends GaanaNotifier {
  final List<Offset> dots = [];

  PlotNotifier({super.key = "graph1"});

  /// Adds a new dot to the plot and notifies callbacks.
  void addDot(Offset dot) {
    dots.add(dot);
    notify();
  }

  /// Clears all dots and notifies callbacks.
  void clean() {
    dots.clear();
    notify();
  }
}

/*
    // For plotting, create PlotNotifier with key 'graph1'
      plotNotifier = PlotNotifier();
      GaanaService.add(plotNotifier);
    // For demonstration, instantiate PlotRepository and PetrolUseCase.
    final repository = PlotRepository();
    final petrolUseCase = PetrolUseCase(repository: repository, plotNotifier: plotNotifier);
    // Start the petrol use case if not already started.
    petrolUseCase.start();
 */
