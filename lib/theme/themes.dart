import 'package:flutter/material.dart';

const Color _primary = Color(0xFF2563EB); // Modern Blue
const Color _secondary = Color(0xFF14B8A6); // Elegant Teal
const Color _backgroundLight = Color(0xFFEAF3FF);
const Color _surfaceLight = Colors.white;

const Color _backgroundDark = Color(0xFF0B1120);
const Color _surfaceDark = Color(0xFF111827);
const Color _cardDark = Color(0xFF1E293B);

const Color _textLight = Color(0xFF111827);
const Color _textDark = Color(0xFFF8FAFC);

class AppThemes {
  static ThemeData lightTheme() {
    final colorScheme = ColorScheme.light(
      primary: _primary,
      secondary: _secondary,
      surface: _surfaceLight,
      background: _backgroundLight,
      onBackground: _textLight,
      onSurface: _textLight,
      onPrimary: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _backgroundLight,
      cardColor: _surfaceLight,
      dividerColor: Colors.grey.shade200,
      splashFactory: InkRipple.splashFactory,
      visualDensity: VisualDensity.adaptivePlatformDensity,

      // AppBar: transparent modern look
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: _textLight,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
      ),

      tabBarTheme: TabBarThemeData(
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 15,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: _primary.withOpacity(.12),
        ),
      ),

      // Card theme: flat base, we will wrap cards with a container for shadow
      cardTheme: CardThemeData(
        elevation: 0,
        margin: const EdgeInsets.all(8),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          minimumSize: const Size(double.infinity, 54),
          backgroundColor: _primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),

      // Floating action button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 2,
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),

      // Text theme (sizes and letterSpacing)
      textTheme: TextTheme(
        displayLarge: TextStyle(fontSize: 48, fontWeight: FontWeight.w800, color: _textLight),
        headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: _textLight),
        headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: _textLight),
        headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: _textLight),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: _textLight, letterSpacing: -0.3),
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: _textLight, letterSpacing: -0.3),
        bodyLarge: TextStyle(fontSize: 16, color: _textLight),
        bodyMedium: TextStyle(fontSize: 15, color: _textLight),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _textLight),
      ),

      // Input fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: _primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      ),

      // Chips
      chipTheme: ChipThemeData(
        backgroundColor: Colors.blue.shade50,
        selectedColor: _primary,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        shape: const StadiumBorder(),
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.all(_primary),
        trackColor: MaterialStateProperty.all(_primary.withOpacity(.35)),
      ),

      // Navigation bar
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        indicatorColor: _primary.withOpacity(.15),
        elevation: 0,
        labelTextStyle: MaterialStateProperty.all(const TextStyle(fontWeight: FontWeight.w600)),
      ),

      // Icon theme
      iconTheme: const IconThemeData(size: 22, color: _textLight),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 0,
      ),

      // Page transitions
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      }),
    );
  }

  static ThemeData darkTheme() {
    final colorScheme = ColorScheme.dark(
      primary: _primary,
      secondary: _secondary,
      surface: _surfaceDark,
      background: _backgroundDark,
      onBackground: _textDark,
      onSurface: _textDark,
      onPrimary: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _backgroundDark,
      cardColor: _cardDark,
      dividerColor: Colors.grey.shade800,
      splashFactory: InkRipple.splashFactory,
      visualDensity: VisualDensity.adaptivePlatformDensity,

      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: _textDark,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
      ),

      cardTheme: CardThemeData(
        elevation: 0,
        margin: const EdgeInsets.all(8),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          minimumSize: const Size(double.infinity, 54),
          backgroundColor: _primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 2,
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),

      textTheme: TextTheme(
        displayLarge: TextStyle(fontSize: 48, fontWeight: FontWeight.w800, color: _textDark),
        headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: _textDark),
        headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: _textDark),
        headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: _textDark),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: _textDark, letterSpacing: -0.3),
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: _textDark, letterSpacing: -0.3),
        bodyLarge: TextStyle(fontSize: 16, color: _textDark),
        bodyMedium: TextStyle(fontSize: 15, color: _textDark),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _textDark),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: _primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: Colors.blue.shade900.withOpacity(.08),
        selectedColor: _primary,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        shape: const StadiumBorder(),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.all(_primary),
        trackColor: MaterialStateProperty.all(_primary.withOpacity(.35)),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        indicatorColor: _primary.withOpacity(.15),
        elevation: 0,
        labelTextStyle: MaterialStateProperty.all(const TextStyle(fontWeight: FontWeight.w600)),
      ),

      iconTheme: const IconThemeData(size: 22, color: _textDark),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 0,
      ),

      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      }),
    );
  }
}
