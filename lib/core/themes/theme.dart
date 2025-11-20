import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../utils/ui_helpers.dart';

part 'theme_data.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: colorScheme,
  fontFamily: "Poppins",
  useMaterial3: true,
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
  ),
  scaffoldBackgroundColor: AppColors.white,
  inputDecorationTheme: inputDecorationTheme,
  checkboxTheme: checkBoxThemeData,
  listTileTheme: listTileThemeData,
  switchTheme: switchThemeData,
);
