import 'package:flutter/material.dart';
import 'package:ui_library/utils/ui_helpers.dart';
import 'package:ui_library/utils/validators.dart';
import 'package:ui_library/widgets/user_inputs/form/base_text_field.dart';
import 'package:ui_library/widgets/user_inputs/overlays/overlay_button.dart';
import 'package:ui_library/widgets/user_inputs/overlays/overlay_decoration.dart';
import 'package:ui_library/widgets/visual_layouts/base_text.dart';

/// A text field widget with a dropdown menu overlay for selecting items.
///
/// Displays a read-only text field that, when tapped, shows a dropdown overlay with selectable items.
/// The overlay appears below the field and is dismissed when an item is selected or tapped on the text field again.
/// The selected item's label is shown in the text field, and a callback is triggered on selection.
/// Supports custom title, hint text, prefix icon, max menu height/width, and item list.
class DropdownTextField<T> extends StatefulWidget {
  const DropdownTextField({
    super.key,
    this.title,
    this.hintText = 'Choose an option',
    this.prefixIcon,
    this.alignMenuAtTop = false,
    this.verticalGap = 4.0,
    this.menuMaxHeight = double.infinity,
    this.menuMaxWidth,
    this.shrinkWrap = true,
    this.selectedItem,
    required this.items,
    required this.onChanged,
    this.isOptional = false,
  });

  final String? title;
  final String hintText;
  final Widget? prefixIcon;

  /// Whether to show the dropdown menu at the top of the text field or not.
  final bool alignMenuAtTop;

  /// Vertical space between target and follower.
  final double verticalGap;
  final double menuMaxHeight;
  final double? menuMaxWidth;

  /// Adjusts the height of the dropdown based on the children's size.
  /// Impacts performance if enabled for large number of items.
  final bool shrinkWrap;
  final DropdownItem<T>? selectedItem;
  final List<DropdownItem<T>> items;

  /// The onChanged callback is intentionally covariant in T to allow flexibility
  /// when passing functions that accept supertypes of T.
  // ignore: unsafe_variance
  final void Function(T value) onChanged;

  /// A flag to indicate if the dropdown is optional.
  final bool isOptional;

  @override
  State<DropdownTextField<T>> createState() => _DropdownTextFieldState<T>();
}

class _DropdownTextFieldState<T> extends State<DropdownTextField<T>> {
  late final TextEditingController _controller;
  final GlobalKey _textFieldKey = GlobalKey();
  final LayerLink _layerLink = LayerLink();
  final _menuVisibilityNotifier = ValueNotifier(false);
  OverlayEntry? _overlayEntry;
  DropdownItem<T>? _selectedItem;
  List<DropdownItem<T>> _items = [];

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.selectedItem;
    _items = widget.items;
    _controller = TextEditingController(text: _selectedItem?.label);
  }

  @override
  void dispose() {
    _controller.dispose();
    _hideOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget child = CompositedTransformTarget(
      link: _layerLink,
      child: BaseTextField(
        key: _textFieldKey,
        controller: _controller,
        readOnly: true,
        onTap: _showOverlay,
        hintText: widget.hintText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: ValueListenableBuilder(
          valueListenable: _menuVisibilityNotifier,
          builder: (_, isMenuShowed, _) {
            return Icon(
              isMenuShowed
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              size: 24,
            );
          },
        ),
        validator: widget.isOptional
            ? null
            : (value) => Validators.require(
                value,
                label: widget.title ?? 'this field',
              ),
      ),
    );

    if (widget.title == null) {
      return child;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [BaseText.label(widget.title!), child],
    );
  }

  /// Show overlay entry if the items are not empty
  void _showOverlay() {
    if (_items.isNotEmpty && _overlayEntry == null) {
      _menuVisibilityNotifier.value = true;
      _overlayEntry = _buildOverlay();
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  /// Remove and dispose the overlay entry
  Future<void> _hideOverlay() async {
    await Future<void>.delayed(const Duration(milliseconds: 50));

    _menuVisibilityNotifier.value = false;
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  /// Build the popup widget ath the right position with the provided items
  OverlayEntry _buildOverlay() {
    final renderBox =
        _textFieldKey.currentContext?.findRenderObject() as RenderBox?;

    /// Check condition if widget hasn't been laid out yet or
    /// the layout might have completed yet and size is not available yet
    if (renderBox == null || !renderBox.hasSize) {
      return OverlayEntry(builder: (_) => const SizedBox.shrink());
    }

    final width = renderBox.size.width;
    final maxWidth = widget.menuMaxWidth?.clamp(width * .1, width) ?? width;

    // targetAnchor and followerAnchor are combined with each-other to align
    // follower with the target. Example: targetAnchor = bottomLeft
    // and followerAnchor = topLeft means position the follower's top left side
    // with the bottom left side of the target.
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
              width: maxWidth,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                targetAnchor: widget.alignMenuAtTop
                    ? Alignment.topLeft
                    : Alignment.bottomLeft,
                followerAnchor: widget.alignMenuAtTop
                    ? Alignment.bottomLeft
                    : Alignment.topLeft,
                offset: Offset(
                  0,
                  widget.alignMenuAtTop
                      ? -widget.verticalGap
                      : widget.verticalGap,
                ),
                child: _buildOverlayContainer(),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Build the overlay container that shows the overlay items
  Widget _buildOverlayContainer() {
    return OverlayDecoration(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: widget.menuMaxHeight),
        child: Material(
          color: Colors.transparent,
          child: ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: widget.shrinkWrap,
            itemCount: widget.items.length,
            separatorBuilder: (context, index) => UIHelpers.spaceV4,
            itemBuilder: (context, index) {
              final item = widget.items[index];
              return OverlayButton(
                onTap: () => _onDropdownItemSelect(item),
                label: item.label,
              );
            },
          ),
        ),
      ),
    );
  }

  void _onDropdownItemSelect(DropdownItem<T> item) {
    _hideOverlay();
    if (_selectedItem != item) {
      _controller.text = item.label;
      _selectedItem = item;
      if (item.value != null) {
        widget.onChanged(item.value as T);
      }
    }
  }
}

/// Holds dropdown visible text and value associated with it.
/// Value will be returned on changing dropdown item.
/// [label] is the text which will be displayed.
class DropdownItem<T> {
  const DropdownItem({required this.value, required this.label});
  final T? value;
  final String label;

  @override
  String toString() => 'DropDownItem(value: $value, label: $label)';

  @override
  bool operator ==(covariant DropdownItem<T> other) {
    if (identical(this, other)) {
      return true;
    }
    return other.value == value && other.label == label;
  }

  @override
  int get hashCode => value.hashCode ^ label.hashCode;
}
