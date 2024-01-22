import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pathpal/colors.dart';

TextTheme appTextTheme() {
  return TextTheme(
    displayLarge: GoogleFonts.notoSansKr(
        fontSize: 94, 
        fontWeight: FontWeight.w300, 
        letterSpacing: -1.5
        ),
    displayMedium: GoogleFonts.notoSansKr(
        fontSize: 59,
        fontWeight: FontWeight.w300, 
        letterSpacing: -0.5
        ),
    displaySmall:GoogleFonts.notoSansKr(
      fontSize: 47, 
      fontWeight: FontWeight.w400
      ),
    headlineMedium: GoogleFonts.notoSansKr(
        fontSize: 33, 
        fontWeight: FontWeight.w400, 
        letterSpacing: 0.25
        ),
    headlineSmall:GoogleFonts.notoSansKr(
          fontSize: 24, 
          fontWeight: FontWeight.w400
          ),
    titleLarge: GoogleFonts.notoSansKr(
        fontSize: 20, 
        fontWeight: FontWeight.w500, 
        letterSpacing: 0.15
        ),
    titleMedium: GoogleFonts.notoSansKr(
        fontSize: 16, 
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15
        ),
    titleSmall: GoogleFonts.notoSansKr(
        fontSize: 14, 
        fontWeight: FontWeight.w500, 
        letterSpacing: 0.1
        ),
    bodyLarge: GoogleFonts.notoSansKr(
        fontSize: 16, 
        fontWeight: FontWeight.w400, 
        letterSpacing: 0.5
        ),
    bodyMedium: GoogleFonts.notoSansKr(
        fontSize: 14, 
        fontWeight: FontWeight.w400, 
        letterSpacing: 0.25
        ),
    labelLarge: GoogleFonts.notoSansKr(
        fontSize: 14, 
        fontWeight: FontWeight.w500, 
        letterSpacing: 1.25
        ),
    bodySmall: GoogleFonts.notoSansKr(
        fontSize: 12, 
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4
        ),
    labelSmall: GoogleFonts.notoSansKr(
        fontSize: 10, 
        fontWeight: FontWeight.w400, 
        letterSpacing: 1.5
        ),
  );
}

ColorScheme appColorScheme(){
  return ColorScheme(
    brightness: Brightness.light,
    primary: mainAccentColor,
    onPrimary: mainAccentColor,
    secondary: subAccentColor,
    onSecondary: subAccentColor,
    background: background,
    onBackground: gray900,
    surface: Colors.white,
    onSurface: gray900,
    outline: gray200,
    error: red900,
    onError: red900,
  );
}
