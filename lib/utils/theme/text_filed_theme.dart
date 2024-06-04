import 'package:ais_visualizer/utils/constants/colors.dart';
import 'package:ais_visualizer/utils/theme/text_theme.dart';
import 'package:flutter/material.dart';

class AppTextFormFieldTheme {
  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 2,
    prefixIconColor: AppColors.grey,
    suffixIconColor: AppColors.secondary,
    labelStyle: AppTextTheme.lightTheme.bodyLarge,
    floatingLabelStyle: AppTextTheme.lightTheme.headlineMedium,
    hintStyle: AppTextTheme.lightTheme.labelSmall,
    errorStyle: AppTextTheme.lightTheme.labelMedium!.copyWith(fontSize: 12),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: AppColors.borderSecondary,
        width: 1,
      ),
    ),

    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: AppColors.borderSecondary,
        width: 1,
      ),
    ),

    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: AppColors.borderHighlighted,
        width: 1,
      ),
    ),

    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: AppColors.error,
        width: 1,
      ),
    ),

    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: AppColors.error,
        width: 1,
      ),
    ),
  );
}
