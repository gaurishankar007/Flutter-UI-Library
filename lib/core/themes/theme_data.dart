part of 'theme.dart';

/// Color Scheme
ColorScheme get colorScheme => ColorScheme.fromSeed(
  seedColor: AppColors.primary,
  primary: AppColors.primary,
  surface: AppColors.white,
  onSurface: AppColors.black87,
  error: AppColors.error,
);

/// InputDecoration Theme
OutlineInputBorder outlinedInputBorder(Color color) => OutlineInputBorder(
  borderRadius: UIHelpers.radiusC8,
  borderSide: BorderSide(color: color, width: 1.5),
);
InputDecorationTheme get inputDecorationTheme => InputDecorationTheme(
  filled: true,
  fillColor: Colors.transparent,
  hoverColor: AppColors.primary50,
  focusColor: AppColors.primary50,
  enabledBorder: outlinedInputBorder(AppColors.primary200),
  focusedBorder: outlinedInputBorder(AppColors.primary),
  errorBorder: outlinedInputBorder(AppColors.error),
  focusedErrorBorder: outlinedInputBorder(AppColors.error),
  disabledBorder: outlinedInputBorder(AppColors.primary250),
);

/// ListTile Theme
ListTileThemeData get listTileThemeData => const ListTileThemeData(
  contentPadding: EdgeInsets.zero,
  // If zero is given than it will take default top padding
  minVerticalPadding: 1,
  horizontalTitleGap: 0,
  minLeadingWidth: 0,
);

/// CheckBox Theme
CheckboxThemeData get checkBoxThemeData => CheckboxThemeData(
  fillColor: WidgetStateColor.resolveWith((state) {
    if (state.contains(WidgetState.disabled)) {
      return AppColors.primary250;
    } else if (state.contains(WidgetState.selected)) {
      return AppColors.primary;
    }
    return AppColors.white;
  }),
  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  visualDensity: VisualDensity(horizontal: -4, vertical: -4),
  shape: RoundedRectangleBorder(borderRadius: UIHelpers.radiusC2),
  side: WidgetStateBorderSide.resolveWith((states) {
    final borderSide = BorderSide(color: AppColors.primary, width: 2);
    if (states.contains(WidgetState.disabled)) {
      return borderSide.copyWith(color: AppColors.primary250);
    } else if (states.contains(WidgetState.hovered)) {
      bool isSelected = states.contains(WidgetState.selected);
      return borderSide.copyWith(
        color: isSelected ? AppColors.primary : AppColors.primary700,
      );
    }
    return borderSide;
  }),
);

/// Switch Theme
SwitchThemeData get switchThemeData => SwitchThemeData(
  trackColor: WidgetStateColor.resolveWith((states) {
    if (states.contains(WidgetState.disabled) &&
        states.contains(WidgetState.selected)) {
      return AppColors.primary250;
    } else if (states.contains(WidgetState.selected)) {
      return AppColors.primary;
    }
    return AppColors.white;
  }),
  thumbColor: WidgetStateColor.resolveWith((states) {
    if (states.contains(WidgetState.selected)) {
      return AppColors.white;
    } else if (states.contains(WidgetState.disabled)) {
      return AppColors.black38;
    }
    return AppColors.black87;
  }),
  trackOutlineColor: WidgetStateColor.resolveWith((states) {
    if (states.contains(WidgetState.disabled)) {
      bool isSelected = states.contains(WidgetState.selected);
      return isSelected ? AppColors.primary250 : AppColors.black38;
    } else if (states.contains(WidgetState.selected)) {
      return AppColors.primary;
    }
    return AppColors.black87;
  }),
  trackOutlineWidth: WidgetStatePropertyAll(4),
  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  padding: EdgeInsets.zero,
);
