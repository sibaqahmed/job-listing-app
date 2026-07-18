import 'dart:ui';
import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final double radius;
  final bool withBorder;

  const AppCard({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.margin = const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    this.radius = 24,
    this.withBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 8,
            sigmaY: 8,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),

              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                  Colors.white.withOpacity(.08),
                  Colors.white.withOpacity(.03),
                ]
                    : [
                  Colors.white.withOpacity(.42),
                  Colors.white.withOpacity(.22),
                ],
              ),

              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(.10)
                    : Colors.white.withOpacity(.65),
                width: 1.1,
              ),

              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(.30)
                      : Colors.black.withOpacity(.08),
                  blurRadius: isDark ? 28 : 18,
                  spreadRadius: isDark ? 0 : 1,
                  offset: const Offset(0, 8),
                ),
              ],
            ),

            child: child,
          ),
        ),
      ),
    );
  }
}