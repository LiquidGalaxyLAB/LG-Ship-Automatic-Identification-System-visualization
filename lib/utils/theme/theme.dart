import 'package:ais_visualizer/utils/theme/text_filed_theme.dart';
import 'package:ais_visualizer/utils/theme/text_theme.dart';
import 'package:ais_visualizer/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Montserrat',
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.primaryBackground,
    textTheme: AppTextTheme.lightTheme,
    inputDecorationTheme: AppTextFormFieldTheme.lightInputDecorationTheme,
  );
}