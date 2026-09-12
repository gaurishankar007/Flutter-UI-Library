import 'package:material_ui/material_ui.dart';

Future<T?> showGenericBottomSheet<T>(
  BuildContext context, {
  required Widget child,
  Color backgroundColor = Colors.white,
  bool isDismissible = false,
  bool enableDrag = false,
  double scrollControlDisabledMaxHeightRatio = .95,
}) async {
  return await showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.white,
    barrierColor: const Color(0XFF1D1B20).withAlpha(153),
    useSafeArea: true,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    scrollControlDisabledMaxHeightRatio: scrollControlDisabledMaxHeightRatio,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
    ),
    builder: (builder) => ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
      child: child,
    ),
  );
}
