import 'package:flutter/material.dart';
import 'gaana_notifier.dart'; // Base class that supports callback registration

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
