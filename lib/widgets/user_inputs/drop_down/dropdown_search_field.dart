import 'package:flutter/material.dart';

import '../../../utils/ui_helpers.dart';
import '../form/base_text_field.dart';
import '../overlay/overlay_decoration.dart';

/// A text field with a dropdown overlay for selecting items as you type.
///
/// Shows a dropdown below the field when [overlayItems] is not empty. The overlay displays each item
/// using [overlayItemWidget], and updates automatically when [overlayItems] changes. Supports custom
/// icons, hint text, separators, padding, and max overlay height. Useful for searchable dropdowns and autocomplete.
class DropdownSearchField<T> extends StatefulWidget {
  final TextEditingController? controller;
  final Function(String?)? onChanged;
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  /// Whenever this list changes, the overlay will be updated.
  /// Overlay will be shown only when the list is not empty.
  final List<T> overlayItems;
  final Widget Function(T) overlayItemWidget;
  final Widget? overlayItemSeparatorWidget;

  /// The gap between the overlay and the text field;
  final double overlayGap;
  final double overlayMaxHeight;
  final EdgeInsets? overlayPadding;

  /// Adjusts the height of the overlay based on the children's size.
  final bool shrinkWrap;

  const DropdownSearchField({
    super.key,
    this.controller,
    this.onChanged,
    this.hintText = "",
    this.prefixIcon,
    this.suffixIcon,
    required this.overlayItems,
    required this.overlayItemWidget,
    this.overlayItemSeparatorWidget,
    this.overlayGap = 8,
    this.overlayMaxHeight = double.infinity,
    this.overlayPadding,
    this.shrinkWrap = true,
  });

  @override
  State<DropdownSearchField<T>> createState() => _DropdownSearchFieldState<T>();
}

class _DropdownSearchFieldState<T> extends State<DropdownSearchField<T>> {
  final GlobalKey _textFieldKey = GlobalKey();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  List<T> _items = [];

  @override
  void initState() {
    super.initState();
    _items = widget.overlayItems;
    safeCallback(_showOverlay);
  }

  @override
  void didUpdateWidget(covariant DropdownSearchField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    /// Update overlay if the items are changed
    if (oldWidget.overlayItems != widget.overlayItems) {
      _items = widget.overlayItems;
      safeCallback(_updateOverlay);
    }
  }

  @override
  void dispose() {
    _hideOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: BaseTextField(
        key: _textFieldKey,
        controller: widget.controller,
        onChanged: widget.onChanged,
        hintText: widget.hintText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
      ),
    );
  }

  /// Show overlay entry if the items are not empty
  void _showOverlay() {
    if (_items.isEmpty) return;
    _overlayEntry = _buildOverlay();
    Overlay.of(context).insert(_overlayEntry!);
  }

  /// Update overlay entry if the items are changed
  void _updateOverlay() {
    if (_items.isEmpty) return _hideOverlay();
    if (_overlayEntry == null) return _showOverlay();
    _overlayEntry?.markNeedsBuild();
  }

  /// Remove and dispose the overlay entry
  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  /// This method is called only after the widget is laid out.
  void safeCallback(Function() callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) => callback.call());
  }

  /// Build the popup widget ath the right position with the provided items
  OverlayEntry _buildOverlay() {
    final renderBox =
        _textFieldKey.currentContext?.findRenderObject() as RenderBox?;

    /// Check condition if widget hasn't been laid out yet or
    /// the layout might have completed yet and size is not available yet
    if (renderBox == null || !renderBox.hasSize) {
      return OverlayEntry(builder: (_) => SizedBox.shrink());
    }

    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) {
        return Positioned(
          width: size.width,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, size.height + widget.overlayGap),
            child: _buildOverlayContainer(),
          ),
        );
      },
    );
  }

  /// Build the overlay container that shows the overlay items
  Widget _buildOverlayContainer() {
    return OverlayDecoration(
      padding: widget.overlayPadding,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: widget.overlayMaxHeight),
        child: Material(
          color: Colors.transparent,
          child: ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: widget.shrinkWrap,
            itemCount: widget.overlayItems.length,
            separatorBuilder: (context, index) {
              return widget.overlayItemSeparatorWidget ?? UIHelpers.spaceV8;
            },
            itemBuilder: (context, index) {
              return widget.overlayItemWidget(widget.overlayItems[index]);
            },
          ),
        ),
      ),
    );
  }
}
