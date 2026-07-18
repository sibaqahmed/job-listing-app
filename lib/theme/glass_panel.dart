import 'dart:ui';
import 'package:flutter/material.dart';

Widget glassPanel({
  required Widget child,
  double blur = 10,
  EdgeInsets padding = const EdgeInsets.all(12),
  double radius = 18,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
      child: Builder(builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        // subtle tint depending on theme
        final color = isDark ? Colors.white.withOpacity(0.03) : Colors.white.withOpacity(0.6);
        return Container(
          padding: padding,
          color: color,
          child: child,
        );
      }),
    ),
  );
}
