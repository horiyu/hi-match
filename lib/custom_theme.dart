import 'package:flutter/material.dart';

ThemeData themeLight() {
  const primary = Color.fromARGB(255, 56, 106, 31);
  // テーマの基本設定
  final base = ThemeData(
    fontFamily: "Noto Sans JP",
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: primary,
      primary: primary,
      surface: primary,
      error: Colors.blue,
      surfaceContainerLow: Colors.orange,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(fontSize: 18),
      headlineMedium: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
    ),
  );

  return base.copyWith(
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
    ),
    floatingActionButtonTheme: base.floatingActionButtonTheme.copyWith(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    // scaffoldBackgroundColor: Colors.green,
  );
}
