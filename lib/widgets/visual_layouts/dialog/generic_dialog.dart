import 'package:flutter/material.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/utils/screen_util/screen_util.dart';
import 'package:ui_library/utils/ui_helpers.dart';
import 'package:ui_library/widgets/user_inputs/button/base_icon_button.dart';
import 'package:ui_library/widgets/visual_layouts/base_text.dart';
import 'package:ui_library/widgets/visual_layouts/divider/base_divider.dart';

Future<T?> showGenericDialog<T>(
  BuildContext context, {
  required String title,
  double? dialogHeight,

  /// This method lets you access the dialog context.
  Function(BuildContext dialogContext)? onDialogShown,
  Function()? onDialogDismissed,
  required List<Widget> children,
}) => showDialog(
  context: context,
  barrierDismissible: false,
  barrierColor: AppColors.black.withAlpha(204), // 80% opacity
  builder: (builderContext) {
    onDialogShown?.call(builderContext);
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.zero,
      content: SizedBox(
        height: dialogHeight,
        width: ScreenUtil.I.getResponsiveValue(
          base: 45.widthPart(),
          screens: {
            {.compact, .phone}: 95.widthPart(),
            {.tablet}: 70.widthPart(),
            {.largeTablet}: 60.widthPart(),
          },
        ),
        child: Stack(
          children: [
            Padding(
              padding: UIHelpers.paddingH24V36,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BaseText.heading3(title, color: AppColors.black),
                  BaseDivider(padding: UIHelpers.paddingV24),
                  ...children,
                ],
              ),
            ),
            Positioned(
              top: 18,
              right: 18,
              child: BaseIconButton(
                onPressed: () {
                  Navigator.pop(builderContext);
                  onDialogDismissed?.call();
                },
                icon: Icon(Icons.close, size: 32),
                padding: EdgeInsets.zero,
                disableSplash: true,
              ),
            ),
          ],
        ),
      ),
    );
  },
);
