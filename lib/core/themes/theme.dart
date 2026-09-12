import 'package:material_ui/material_ui.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/utils/ui_helpers.dart';

part 'theme_data.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: colorScheme,
  fontFamily: 'Poppins',
  useMaterial3: true,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
  ),
  scaffoldBackgroundColor: AppColors.white,
  inputDecorationTheme: inputDecorationTheme,
  checkboxTheme: checkBoxThemeData,
  listTileTheme: listTileThemeData,
  switchTheme: switchThemeData,
);
