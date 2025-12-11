import 'package:flutter/material.dart';

import '../../../utils/ui_helpers.dart';
import 'overlay_button.dart';
import 'overlay_decoration.dart';

/// A widget that shows a popup menu overlay anchored to its target widget when tapped.
class OverlayMenu<T> extends StatefulWidget {
  final Widget targetWidget;
  final Alignment targetAnchor;
  final Alignment followerAnchor;

  /// Vertical space between target and follower.
  final double verticalGap;
  final double? menuWidth;

  /// Adjusts the height of the dropdown based on the children's size.
  /// Impacts performance if enabled for large number of items.
  final bool shrinkWrap;
  final TextAlign? menuItemAlign;
  final List<OverlayMenuItem<T>> menuItems;

  const OverlayMenu({
    super.key,
    required this.targetWidget,
    this.targetAnchor = Alignment.bottomRight,
    this.followerAnchor = Alignment.topRight,
    this.verticalGap = 8,
    this.menuWidth,
    this.shrinkWrap = true,
    this.menuItemAlign,
    required this.menuItems,
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
        onTap: _showOverlay,
        splashFactory: NoSplash.splashFactory,
        child: widget.targetWidget,
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

  // targetAnchor and followerAnchor are combined with each-other to align
  // follower with the target. Example: targetAnchor = bottomLeft
  // and followerAnchor = topLeft means position the follower's top left side
  // with the bottom left side of the target.
  OverlayEntry _buildOverlay() {
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
                targetAnchor: widget.targetAnchor,
                followerAnchor: widget.followerAnchor,
                offset: Offset(0, widget.verticalGap),
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
