import 'package:material_ui/material_ui.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:ui_library/widgets/visual_layouts/android_navigation_safe_area.dart';

Future<T?> showGenericBottomSheet<T>(
  BuildContext context, {
  required Widget child,
  Color backgroundColor = Colors.white,
  bool isDismissible = false,
  bool enableDrag = false,
  double scrollControlDisabledMaxHeightRatio = .95,
  // Web-only fix: without an interceptor, a tap on the sheet also falls
  // through to a platform view (e.g. a map) sitting behind it.
  bool hasPointerInterceptor = false,
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
    builder: (builder) {
      final content = AndroidNavigationSafeArea(
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          child: child,
        ),
      );
      return hasPointerInterceptor
          ? PointerInterceptor(child: content)
          : content;
    },
  );
}
