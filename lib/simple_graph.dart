import 'dart:math';

import 'package:flutter/material.dart';

class SimpleGraph extends StatelessWidget {
  final List<Offset> data;
  final double height;
  final EdgeInsets padding;

  const SimpleGraph({
    super.key,
    required this.data,
    this.height = 300,
    this.padding = const EdgeInsets.all(30),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.lightBlue[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final graphSize = Size(constraints.maxWidth, height);
          return CustomPaint(
            size: graphSize,
            painter: _GraphPainter(data: data, padding: padding),
          );
        },
      ),
    );
  }
}

class _GraphPainter extends CustomPainter {
  final List<Offset> data;
  final EdgeInsets padding;

  _GraphPainter({required this.data, required this.padding});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    // Define drawing area dimensions.
    final drawWidth = size.width - padding.left - padding.right;
    final drawHeight = size.height - padding.top - padding.bottom;

    // Determine data range.
    final minX = data.map((p) => p.dx).reduce(min);
    final maxX = data.map((p) => p.dx).reduce(max);
    final minY = data.map((p) => p.dy).reduce(min);
    final maxY = data.map((p) => p.dy).reduce(max);

    final xRange = maxX - minX;
    final yRange = maxY - minY;

    // Scale factors.
    final scaleX = xRange == 0 ? 1.0 : drawWidth / xRange;
    final scaleY = yRange == 0 ? 1.0 : drawHeight / yRange;

    // Map data points to canvas coordinates.
    final scaledPoints =
        data.map((p) {
          final x = padding.left + (p.dx - minX) * scaleX;
          // Invert y so that larger data values appear lower.
          final y = padding.top + drawHeight - (p.dy - minY) * scaleY;
          return Offset(x, y);
        }).toList();

    // Determine the x-axis (y=0) position.
    double xAxisY;
    if (minY <= 0 && 0 <= maxY) {
      xAxisY = padding.top + drawHeight - ((0 - minY) * scaleY);
    } else if (0 < minY) {
      // All values are positive; x-axis at bottom.
      xAxisY = size.height - padding.bottom;
    } else {
      // All values are negative; x-axis at top.
      xAxisY = padding.top;
    }

    // Compute fraction of drawing area for the x-axis.
    final fraction = ((xAxisY - padding.top) / drawHeight).clamp(0.0, 1.0);

    // Create a gradient with a hard transition at y=0.
    final lineShader = LinearGradient(
      colors: [Colors.blue, Colors.blue, Colors.red, Colors.red],
      stops: [0.0, fraction, fraction, 1.0],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ).createShader(
      Rect.fromLTWH(padding.left, padding.top, drawWidth, drawHeight),
    );

    // Draw grid lines.
    final gridPaint =
        Paint()
          ..color = Colors.blue.withValues(alpha: .3)
          ..strokeWidth = 1;
    const int gridLines = 5;
    // Horizontal grid lines and labels.
    for (int i = 0; i <= gridLines; i++) {
      final y = padding.top + i * (drawHeight / gridLines);
      canvas.drawLine(
        Offset(padding.left, y),
        Offset(size.width - padding.right, y),
        gridPaint,
      );
      // Calculate corresponding data y value.
      final dataY = maxY - (i / gridLines) * yRange;
      final textSpan = TextSpan(
        text: dataY.toStringAsFixed(1),
        style: const TextStyle(color: Colors.blue, fontSize: 10),
      );
      final tp = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
      tp.layout();
      // Position label to the left of the y-axis.
      tp.paint(canvas, Offset(padding.left - tp.width - 4, y - tp.height / 2));
    }
    // Vertical grid lines.
    for (int i = 0; i <= gridLines; i++) {
      final x = padding.left + i * (drawWidth / gridLines);
      canvas.drawLine(
        Offset(x, padding.top),
        Offset(x, size.height - padding.bottom),
        gridPaint,
      );
      // You could add x-axis labels similarly if needed.
    }

    // Draw axes (blue, with some opacity).
    final axisPaint =
        Paint()
          ..color = Colors.blue.withValues(alpha: .7)
          ..strokeWidth = 1;
    // X-axis at computed y position.
    canvas.drawLine(
      Offset(padding.left, xAxisY),
      Offset(size.width - padding.right, xAxisY),
      axisPaint,
    );
    // Y-axis at left.
    canvas.drawLine(
      Offset(padding.left, padding.top),
      Offset(padding.left, size.height - padding.bottom),
      axisPaint,
    );

    // Create a spline path with Catmull-Rom interpolation.
    final path = _catmullRomSplinePath(scaledPoints);
    final linePaint =
        Paint()
          ..shader = lineShader
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke;
    canvas.drawPath(path, linePaint);

    // Draw dots: hollow circles with light blue fill and dark blue border.
    final fillPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;
    final borderPaint =
        Paint()
          ..color = Colors.blue[900]!
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;
    for (final point in scaledPoints) {
      canvas.drawCircle(point, 4, fillPaint);
      canvas.drawCircle(point, 4, borderPaint);
    }
  }

  /// Returns a Catmull-Rom spline path given a list of points.
  Path _catmullRomSplinePath(List<Offset> points) {
    final path = Path();
    if (points.length < 2) return path;
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 0; i < points.length - 1; i++) {
      final p0 = i == 0 ? points[i] : points[i - 1];
      final p1 = points[i];
      final p2 = points[i + 1];
      final p3 = (i + 2 < points.length) ? points[i + 2] : points[i + 1];
      final cp1 = p1 + (p2 - p0) / 6;
      final cp2 = p2 - (p3 - p1) / 6;
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p2.dx, p2.dy);
    }
    return path;
  }

  @override
  bool shouldRepaint(covariant _GraphPainter oldDelegate) {
    return oldDelegate.data != data || oldDelegate.padding != padding;
  }
}
