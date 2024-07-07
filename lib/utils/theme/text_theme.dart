import 'package:ais_visualizer/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class AppTextTheme {
  AppTextTheme._();

  static TextTheme lightTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
    headlineMedium: const TextStyle().copyWith(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
    headlineSmall: const TextStyle().copyWith(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textSecondary),

    bodyLarge: const TextStyle().copyWith(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
    bodyMedium: const TextStyle().copyWith(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
    bodySmall: const TextStyle().copyWith(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textPrimary),

    labelLarge: const TextStyle().copyWith(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textWhite),
    labelMedium: const TextStyle().copyWith(fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.error),
    labelSmall: const TextStyle().copyWith(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.grey),

    titleMedium: const TextStyle().copyWith(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.secondary),
    
  );
}
