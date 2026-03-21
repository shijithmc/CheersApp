import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // HTML: --or:#E07A3A; --ord:#C1440E; --obg:#3B1A0A
  static const primary = Color(0xFFE07A3A);
  static const primaryDark = Color(0xFFC1440E);
  static const topBarBg = Color(0xFF3B1A0A);

  // HTML: --bg:#FFFFFF; --pgbg:#F5F5F5
  static const background = Color(0xFFF5F5F5);
  static const white = Color(0xFFFFFFFF);

  // HTML: --tx:#1A1A1A; --tx2:#555; --tx3:#999
  static const textPrimary = Color(0xFF1A1A1A);
  static const textSecondary = Color(0xFF555555);
  static const textHint = Color(0xFF999999);

  static const border = Color(0xFFE8E8E8);
  static const green = Color(0xFF27AE60);
  static const red = Color(0xFFE74C3C);
  static const accent = Color(0xFFF39C12);

  // Status colors
  static const statusLive = Color(0xFFE74C3C);
  static const statusNew = Color(0xFF27AE60);
  static const statusJoin = Color(0xFF2980B9);
  static const statusComing = Color(0xFFE07A3A);
  static const statusOffers = Color(0xFF27AE60);

  static ThemeData get theme => ThemeData(
        brightness: Brightness.light,
        primaryColor: primary,
        scaffoldBackgroundColor: background,
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
        colorScheme: const ColorScheme.light(
          primary: primary,
          secondary: accent,
          surface: white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: topBarBg,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: white,
          selectedItemColor: primary,
          unselectedItemColor: textHint,
        ),
      );

  static Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'live':
        return statusLive;
      case 'new':
        return statusNew;
      case 'join':
        return statusJoin;
      case 'coming':
        return statusComing;
      case 'offers':
        return statusOffers;
      case 'luuching':
      case 'launching':
        return primary;
      case 'free':
        return primary;
      default:
        return primary;
    }
  }
}
