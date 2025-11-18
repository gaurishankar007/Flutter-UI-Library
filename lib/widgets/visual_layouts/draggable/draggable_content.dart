import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../utils/screen_util/screen_util.dart';
import '../../../utils/ui_helpers.dart';
import '../base_text.dart';

/// A flexible, reusable widget that displays a draggable bottom sheet with dynamic sizing.
///
/// ## Use Cases:
/// - Use this widget when you want to present content in a bottom sheet that can be expanded or collapsed by the user.
/// - The widget is ideal for scenarios where you have a set of content that should always be visible (e.g., a summary or header),
///   and additional content that is only shown when the sheet is expanded (e.g., details, forms, or actions).
/// - The widget automatically calculates its minimum and maximum heights based on the content provided, ensuring a smooth UX.
/// - The bottom copyright widget is always shown at the bottom of the sheet.
class DraggableContent extends StatefulWidget {
  /// Widgets that are always visible in the sheet, regardless of expansion state.
  final List<Widget> alwaysVisibleChildren;

  /// Widgets that are only visible when the sheet is expanded.
  final List<Widget> expandedOnlyChildren;

  /// Callback method for getting the minimum and maximum heights of the content.
  final Function(double minHeight, double maxHeight)? onContentMeasured;

  const DraggableContent({
    super.key,
    required this.alwaysVisibleChildren,
    required this.expandedOnlyChildren,
    this.onContentMeasured,
  });

  @override
  State<DraggableContent> createState() => _DraggableContentState();
}

class _DraggableContentState extends State<DraggableContent> {
  final _draggableScrollableController = DraggableScrollableController();
  final _alwaysVisibleContentKey = GlobalKey();
  final _copyRightContentKey = GlobalKey();
  final _expandedOnlyContentKey = GlobalKey();
  // Minimum height of the widget
  double _minChildSize = .1;
  // Maximum height of the widget
  double _maxChildSize = .5;
  List<double> _snapSizes = [];

  @override
  void initState() {
    super.initState();
    // After the first frame, measure the content to set min/max sizes dynamically
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureContent());
  }

  @override
  void didUpdateWidget(covariant DraggableContent oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.alwaysVisibleChildren != widget.alwaysVisibleChildren ||
        oldWidget.expandedOnlyChildren != widget.expandedOnlyChildren) {
      // Re-measure content if the children change
      WidgetsBinding.instance.addPostFrameCallback((_) => _measureContent());
    }
  }

  @override
  void dispose() {
    _draggableScrollableController.dispose();
    super.dispose();
  }

  /// Measures the heights of the always-visible, expanded-only, and copyright content,
  /// and updates the min/max child sizes for the draggable sheet accordingly.
  void _measureContent() {
    // Get renderBox of each type of content
    final alwaysVisibleContentBox = _getRenderBox(_alwaysVisibleContentKey);
    final copyRightContentBox = _getRenderBox(_copyRightContentKey);
    final expandedOnlyContentBox = _getRenderBox(_expandedOnlyContentKey);

    if (alwaysVisibleContentBox == null ||
        copyRightContentBox == null ||
        expandedOnlyContentBox == null) {
      return;
    }

    final minHeight =
        alwaysVisibleContentBox.size.height + copyRightContentBox.size.height;
    final maxHeight = minHeight + expandedOnlyContentBox.size.height;

    // Update min/max child size based on the height of the content
    setState(() {
      _minChildSize = (minHeight / ScreenUtil.I.height).clamp(0.001, 1);
      _maxChildSize = (maxHeight / ScreenUtil.I.height).clamp(0.001, 1);
      if (_minChildSize != _maxChildSize) {
        _snapSizes = [_minChildSize, _maxChildSize];
      }
    });

    widget.onContentMeasured?.call(minHeight, maxHeight);
  }

  /// Helper to get the RenderBox for a given GlobalKey.
  RenderBox? _getRenderBox(GlobalKey key) =>
      key.currentContext?.findRenderObject() as RenderBox?;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: _draggableScrollableController,
      initialChildSize: _maxChildSize,
      minChildSize: _minChildSize,
      maxChildSize: _maxChildSize,
      snap: _snapSizes.isNotEmpty,
      snapSizes: _snapSizes,
      builder: (context, scrollController) {
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: UIHelpers.radiusTL24TR24,
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withAlpha(25),
                AppColors.primary.withAlpha(127),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              Flexible(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse,
                    },
                  ),
                  child: ListView(
                    controller: scrollController,
                    padding: UIHelpers.paddingH12,
                    children: [
                      Column(
                        key: _alwaysVisibleContentKey,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UIHelpers.spaceV8,
                          Center(
                            child: SizedBox(
                              width: 96,
                              height: 6,
                              child: DecoratedBox(
                                decoration: ShapeDecoration(
                                  shape: StadiumBorder(),
                                  color: AppColors.dashedBorder,
                                ),
                              ),
                            ),
                          ),
                          UIHelpers.spaceV24,
                          ...widget.alwaysVisibleChildren,
                        ],
                      ),
                      Column(
                        key: _expandedOnlyContentKey,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: widget.expandedOnlyChildren,
                      ),
                    ],
                  ),
                ),
              ),
              SafeArea(
                top: false,
                minimum: kIsWeb ? EdgeInsets.only(bottom: 16) : EdgeInsets.zero,
                child: BaseText(
                  "© UI Component 2025",
                  color: AppColors.black60,
                  fontSize: 12,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
