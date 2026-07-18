import 'package:flutter/material.dart';

class GradientScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget body;
  final Widget? bottomNavigationBar;
  final Color? overrideTop;
  final Color? overrideMiddle;
  final Color? overrideBottom;

  const GradientScaffold({
    Key? key,
    this.appBar,
    this.floatingActionButton,
    required this.body,
    this.bottomNavigationBar,
    this.overrideTop,
    this.overrideMiddle,
    this.overrideBottom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Default palettes
    final lightTop = const Color(0xFFF8FBFF);
    final lightMiddle = const Color(0xFFF2F7FF);
    final lightBottom = const Color(0xFFEAF3FF);

    final darkTop = const Color(0xFF08120F);
    final darkMiddle = const Color(0xFF10211D);
    final darkBottom = const Color(0xFF16352D);

    final top = overrideTop ?? (isDark ? darkTop : lightTop);
    final middle = overrideMiddle ?? (isDark ? darkMiddle : lightMiddle);
    final bottom = overrideBottom ?? (isDark ? darkBottom : lightBottom);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [top, middle, bottom],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(child: body),
      ),
    );
  }
}
