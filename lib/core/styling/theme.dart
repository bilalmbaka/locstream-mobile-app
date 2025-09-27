import 'package:flutter/material.dart';

import '../constants/constants.dart';
import 'colors.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
    primaryColor: AppColors.primaryColor,
    fontFamily: AppConstants.nunitoFontFamily,
    appBarTheme: AppBarTheme(backgroundColor: AppColors.white),
    scaffoldBackgroundColor: AppColors.white,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        backgroundColor: WidgetStateProperty.resolveWith((
          Set<WidgetState> state,
        ) {
          if (state.contains(WidgetState.disabled)) {
            return AppColors.primaryColor.withOpacity(.5);
          }

          return AppColors.primaryColor;
        }),
        fixedSize: WidgetStateProperty.all(Size(double.infinity, 45)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        backgroundColor: WidgetStateProperty.all(AppColors.transparent),
        side: WidgetStateProperty.all(
          BorderSide(color: AppColors.primaryColor),
        ),
        fixedSize: WidgetStateProperty.all(Size(double.infinity, 45)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      outlineBorder: BorderSide(color: AppColors.stroke),
      hintStyle: TextStyle(
        fontSize: 12,
        color: Colors.grey,
        fontWeight: FontWeight.w300,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: AppColors.stroke),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: AppColors.stroke),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: AppColors.stroke),
      ),
    ),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryColor,
      brightness: Brightness.dark,
    ),
    primaryColor: AppColors.primaryColor,
    dialogTheme: DialogThemeData(backgroundColor: AppColors.dialogColor),
    fontFamily: AppConstants.nunitoFontFamily,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.transparent,
      elevation: 0,
      foregroundColor: AppColors.transparent,
    ),
    scaffoldBackgroundColor: AppColors.primaryColor,
    progressIndicatorTheme: ProgressIndicatorThemeData(color: AppColors.white),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        backgroundColor: WidgetStateProperty.resolveWith((
          Set<WidgetState> state,
        ) {
          if (state.contains(WidgetState.disabled)) {
            return AppColors.ladingPageGradientGreen.withOpacity(.5);
          }

          return AppColors.ladingPageGradientGreen;
        }),
        fixedSize: WidgetStateProperty.all(Size(double.infinity, 45)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        backgroundColor: WidgetStateProperty.all(AppColors.transparent),
        side: WidgetStateProperty.all(
          BorderSide(color: AppColors.ladingPageGradientGreen),
        ),
        fixedSize: WidgetStateProperty.all(Size(double.infinity, 45)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      outlineBorder: BorderSide(color: AppColors.inputBorder),
      hintStyle: TextStyle(
        fontSize: 12,
        color: Colors.grey,
        fontWeight: FontWeight.w300,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: AppColors.inputBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: AppColors.inputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: AppColors.primaryColor80),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: AppColors.text3),
      ),
    ),
  );
}
