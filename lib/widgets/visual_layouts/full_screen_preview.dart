import 'package:material_ui/material_ui.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/widgets/user_inputs/button/base_icon_button.dart';

/// Wraps [child] so tapping it opens a full-screen, dismissible preview
/// overlay - handy for lightboxing images or other media on tap.
class FullScreenPreview extends StatelessWidget {
  const FullScreenPreview({super.key, required this.child, this.baseChild});

  /// The widget to be displayed in the full-screen preview.
  final Widget child;

  /// The widget to be displayed in the base (unexpanded) state.
  /// Defaults to [child].
  final Widget? baseChild;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        late final OverlayEntry overlayEntry;
        overlayEntry = OverlayEntry(
          builder: (context) => SafeArea(
            child: Material(
              color: Colors.black,
              child: Stack(
                children: [
                  Center(child: child),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: BaseIconButton(
                      onPressed: () => overlayEntry.remove(),
                      icon: const Icon(Icons.close, color: AppColors.white),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        Overlay.of(context, rootOverlay: true).insert(overlayEntry);
      },
      child: baseChild ?? child,
    );
  }
}
