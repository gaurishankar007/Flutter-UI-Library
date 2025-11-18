import 'package:flutter/material.dart';

import '../../../utils/ui_helpers.dart';
import 'overlay_button.dart';
import 'overlay_decoration.dart';

/// A widget that shows a popup menu overlay anchored to its child when tapped.
///
/// Displays [menuWidget] as the trigger. When tapped, an overlay menu with [menuItems] appears below, above, or beside it.
/// The menu closes when an item is selected or the trigger is tapped again.
/// Supports custom menu width and direction.
///
/// The [isLeftMenu] flag controls the horizontal direction in which the menu appears:
/// - If false (default), the menu opens to the right of the trigger widget.
/// - If true, the menu opens to the left of the trigger widget. This is useful when the trigger is near the right edge of the screen,
///   preventing the overlay from overflowing off-screen.
///
/// The [isTopMenu] flag controls the vertical direction in which the menu appears:
/// - If false (default), the menu opens below the trigger widget.
/// - If true, the menu opens above the trigger widget. The overlay's vertical offset is calculated based on the number of menu items.
///
/// The [menuWidth] parameter allows specifying a custom width for the overlay menu.
/// The [menuItemAlign] parameter allows customizing the alignment of the menu item labels.
/// The [shrinkWrap] adjusts the height of the menu based on the children's size.
class OverlayMenu<T> extends StatefulWidget {
  final Widget menuWidget;
  final List<OverlayMenuItem<T>> menuItems;
  final double? menuWidth;
  final bool isLeftMenu;
  final bool isTopMenu;
  final TextAlign? menuItemAlign;
  final bool shrinkWrap;

  const OverlayMenu({
    super.key,
    required this.menuWidget,
    required this.menuItems,
    this.menuWidth,
    this.isLeftMenu = false,
    this.isTopMenu = false,
    this.menuItemAlign,
    this.shrinkWrap = true,
  });

  @override
  State<OverlayMenu<T>> createState() => _OverlayMenuState<T>();
}

class _OverlayMenuState<T> extends State<OverlayMenu<T>> {
  final GlobalKey _childKey = GlobalKey();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    _hideOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: InkWell(
        key: _childKey,
        onTap: () => _showOverlay(),
        splashFactory: NoSplash.splashFactory,
        child: widget.menuWidget,
      ),
    );
  }

  /// Shows the overlay entry if it is not already visible.
  /// If the overlay is already shown, it will be hidden.
  void _showOverlay() {
    if (_overlayEntry != null) return;

    _overlayEntry = _buildOverlay();
    Overlay.of(context).insert(_overlayEntry!);
  }

  /// Removes and disposes the overlay entry if it exists.
  /// A small delay is introduced to allow [_showOverlay] to complete its execution
  /// when the trigger widget [CompositedTransformTarget] is tapped, preventing immediate re-display of the overlay.
  void _hideOverlay() async {
    await Future.delayed(Duration(milliseconds: 50));

    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  /// Builds the popup overlay widget at the correct position with the provided items.
  /// The position is determined by [isLeftMenu] and [isTopMenu] flags.
  /// If [isTopMenu] is true, the overlay appears above the trigger widget,
  /// otherwise it appears below.
  OverlayEntry _buildOverlay() {
    final renderBox =
        _childKey.currentContext?.findRenderObject() as RenderBox?;

    // If the widget hasn't been laid out yet, return an empty overlay.
    if (renderBox == null || !renderBox.hasSize) {
      return OverlayEntry(builder: (_) => SizedBox.shrink());
    }

    // Get the size of the trigger widget.
    final size = renderBox.size;
    final menuWidth = widget.menuWidth ?? 250;

    // Calculate menu offsets.
    double menuYOffset = size.height + 8;
    double menuXOffset = 0;
    if (widget.isLeftMenu) menuXOffset = -(menuWidth - size.width);
    if (widget.isTopMenu) {
      final verticalPadding = 24;
      // The overlay height is estimated as 55 per item plus padding.
      menuYOffset = -(55 * widget.menuItems.length + verticalPadding) as double;
    }

    return OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: Listener(
                onPointerDown: (_) => _hideOverlay(),
                behavior: HitTestBehavior.translucent,
              ),
            ),
            Positioned(
              width: widget.menuWidth,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(menuXOffset, menuYOffset),
                child: _buildOverlayContainer(),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Builds the overlay container that displays the menu items.
  /// Each item is rendered as an [OverlayButton].
  Widget _buildOverlayContainer() {
    return OverlayDecoration(
      child: Material(
        color: Colors.transparent,
        child: ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: widget.shrinkWrap,
          itemCount: widget.menuItems.length,
          separatorBuilder: (context, index) => UIHelpers.spaceV4,
          itemBuilder: (context, index) {
            final item = widget.menuItems[index];
            return OverlayButton(
              onTap: () {
                item.onTap(item.value);
                _hideOverlay();
              },
              label: item.label,
              labelAlignment: widget.menuItemAlign,
            );
          },
        ),
      ),
    );
  }
}

/// Represents a single item in the [OverlayMenu].
/// [value] is the value associated with the item.
/// [label] is the text displayed for the item.
/// [onTap] is the callback invoked when the item is tapped.
class OverlayMenuItem<T> {
  final T? value;
  final String label;
  final Function(T? value) onTap;

  const OverlayMenuItem({this.value, required this.label, required this.onTap});
}
