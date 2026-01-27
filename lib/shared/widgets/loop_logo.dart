import 'package:flutter/material.dart';

/// Loop logo widget - programmatic version of the app icon
/// Shows "Loop" text with the "oo" styled as a toggle switch
class LoopLogo extends StatelessWidget {
  final double size;
  final Color? textColor;
  final Color accentColor;

  const LoopLogo({
    super.key,
    this.size = 48,
    this.textColor,
    this.accentColor = const Color(0xFF4CAF50), // Green accent
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final foreground = textColor ?? (isDark ? Colors.white : Colors.black);

    return CustomPaint(
      size: Size(size * 2.5, size),
      painter: _LoopLogoPainter(
        textColor: foreground,
        accentColor: accentColor,
      ),
    );
  }
}

class _LoopLogoPainter extends CustomPainter {
  final Color textColor;
  final Color accentColor;

  _LoopLogoPainter({
    required this.textColor,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = textColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.height * 0.06
      ..strokeCap = StrokeCap.round;

    final h = size.height;
    final w = size.width;

    // Letter L
    final lStartX = w * 0.05;
    final lTopY = h * 0.25;
    final lBottomY = h * 0.75;
    final lWidth = w * 0.12;

    // Vertical line of L
    canvas.drawLine(
      Offset(lStartX, lTopY),
      Offset(lStartX, lBottomY),
      paint,
    );
    // Horizontal line of L
    canvas.drawLine(
      Offset(lStartX, lBottomY),
      Offset(lStartX + lWidth, lBottomY),
      paint,
    );

    // Toggle switch (the "oo" part)
    final toggleLeft = w * 0.20;
    final toggleRight = w * 0.55;
    final toggleCenterY = h * 0.55;
    final toggleHeight = h * 0.28;
    final toggleRadius = toggleHeight / 2;

    // Draw toggle track (rounded rectangle)
    final toggleRect = RRect.fromRectAndRadius(
      Rect.fromLTRB(
        toggleLeft,
        toggleCenterY - toggleRadius,
        toggleRight,
        toggleCenterY + toggleRadius,
      ),
      Radius.circular(toggleRadius),
    );
    canvas.drawRRect(toggleRect, paint);

    // Draw toggle knob (filled circle on right side - "ON" position)
    final knobPaint = Paint()
      ..color = textColor
      ..style = PaintingStyle.fill;
    final knobCenterX = toggleRight - toggleRadius - paint.strokeWidth / 2;
    canvas.drawCircle(
      Offset(knobCenterX, toggleCenterY),
      toggleRadius * 0.7,
      knobPaint,
    );

    // Draw "ON" text inside toggle
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'ON',
        style: TextStyle(
          color: accentColor,
          fontSize: h * 0.12,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        toggleLeft + toggleRadius * 0.5,
        toggleCenterY - textPainter.height / 2,
      ),
    );

    // Letter p
    final pStartX = w * 0.60;
    final pTopY = h * 0.35;
    final pBottomY = h * 0.85;
    final pCircleRadius = h * 0.18;

    // Vertical line of p (descender)
    canvas.drawLine(
      Offset(pStartX, pTopY),
      Offset(pStartX, pBottomY),
      paint,
    );

    // Circle of p
    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(pStartX + pCircleRadius, h * 0.52),
        radius: pCircleRadius,
      ),
      -1.57, // Start from top
      3.14 * 2, // Full circle
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Simple Loop icon for use in small spaces (like app bar)
class LoopIcon extends StatelessWidget {
  final double size;
  final Color? color;

  const LoopIcon({
    super.key,
    this.size = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = color ?? theme.colorScheme.primary;

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _LoopIconPainter(color: iconColor),
      ),
    );
  }
}

class _LoopIconPainter extends CustomPainter {
  final Color color;

  _LoopIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.12
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;
    final radius = h * 0.25;

    // Draw toggle switch shape (simplified loop icon)
    final toggleRect = RRect.fromRectAndRadius(
      Rect.fromLTRB(w * 0.1, h * 0.3, w * 0.9, h * 0.7),
      Radius.circular(radius),
    );
    canvas.drawRRect(toggleRect, paint);

    // Draw knob
    final knobPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(w * 0.7, h * 0.5),
      radius * 0.6,
      knobPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
