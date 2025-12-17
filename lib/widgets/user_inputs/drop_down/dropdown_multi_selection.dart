import 'package:flutter/material.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/utils/ui_helpers.dart';
import 'package:ui_library/widgets/user_inputs/bottom_sheet/generic_bottom_sheet.dart';
import 'package:ui_library/widgets/user_inputs/form/base_text_field.dart';
import 'package:ui_library/widgets/visual_layouts/base_text.dart';

/// A generic data model for dropdown items, holding a [value] of type [T]
/// and an optional [label] to display in the UI.
class DropdownData<T> {
  final T value;
  final String? label;

  const DropdownData({required this.value, this.label});

  @override
  bool operator ==(covariant DropdownData<T> other) {
    if (identical(this, other)) return true;

    return other.value == value && other.label == label;
  }

  @override
  int get hashCode => value.hashCode ^ label.hashCode;
}

/// A highly-reusable dropdown widget that supports multiple selections.
///
/// This widget displays a text field that, when tapped, shows a bottom sheet
/// containing a list of selectable items. It supports initial selections, a
/// "Select All" option, and reports changes through the [onChanged] callback.
class DropdownMultiSelection<T> extends StatefulWidget {
  /// The title of the dropdown, displayed above the text field and in the bottom sheet.
  final String title;

  /// The hint text displayed inside the text field when no items are selected.
  final String? hintText;

  /// The list of all available items to choose from.
  final List<DropdownData<T>> data;

  /// The list of items that are selected by default when the widget is first built.
  final List<DropdownData<T>> selectedItems;

  /// A callback function that is invoked whenever the selection changes.
  /// It returns a list of the selected values of type [T].
  final Function(List<T> values) onChanged;

  const DropdownMultiSelection({
    super.key,
    required this.title,
    this.hintText,
    required this.data,
    this.selectedItems = const [],
    required this.onChanged,
  });

  @override
  State<DropdownMultiSelection<T>> createState() =>
      _DropdownMultiSelectionState<T>();
}

/// The state management for [DropdownMultiSelection].
class _DropdownMultiSelectionState<T> extends State<DropdownMultiSelection<T>> {
  // Controller for the text field to display the selected item labels.
  final _controller = TextEditingController();

  // The list of currently selected dropdown items. A copy from the widget's
  // `selectedItems` to prevent direct mutation of the widget's properties.
  late List<DropdownData<T>> _selectedValues;

  // A boolean flag to track whether the "Select All" option is active.
  late bool _isAllSelected;

  @override
  void initState() {
    super.initState();
    // Initialize the selected values from the widget's properties.
    _selectedValues = List.of(widget.selectedItems);
    // Determine if all items are selected initially.
    _isAllSelected =
        widget.data.isNotEmpty && widget.data.length == _selectedValues.length;
    // Update the text field to show the initial selection.
    _updateControllerText();
  }

  @override
  void didUpdateWidget(DropdownMultiSelection<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the incoming selected items have changed, update the state.
    // This ensures the widget reflects external state changes.
    if (widget.selectedItems != oldWidget.selectedItems) {
      _selectedValues = List.of(widget.selectedItems);
      _isAllSelected =
          widget.data.isNotEmpty &&
          widget.data.length == _selectedValues.length;
      _updateControllerText();
    }
  }

  @override
  void dispose() {
    // Dispose the controller to free up resources.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The main UI is a read-only text field. Tapping it triggers the bottom sheet.
    return BaseTextField(
      onTap: () => showGenericBottomSheet(
        context,
        enableDrag: true,
        isDismissible: true,
        child: _buildDropdownItems(),
      ),
      readOnly: true,
      controller: _controller,
      title: widget.title,
      hintText: widget.hintText,
      suffixIcon: const Icon(Icons.keyboard_arrow_down, color: AppColors.fade),
      validator: (value) {
        // Basic validation to ensure at least one item is selected if required.
        if (_selectedValues.isEmpty) {
          return "${widget.title} is required";
        }
        return null;
      },
    );
  }

  /// Builds the content of the bottom sheet, including the item list and "Select All" option.
  Widget _buildDropdownItems() {
    // StatefulBuilder is used to manage the state of the bottom sheet's content
    // independently from the main widget's state.
    return StatefulBuilder(
      builder: (builderContext, setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            UIHelpers.spaceV16,
            BaseText.heading5(widget.title, color: AppColors.base),
            UIHelpers.spaceV16,
            // Show "Select All" only if there are items to select.
            if (widget.data.isNotEmpty) ...[
              Padding(
                padding: UIHelpers.paddingH12,
                child: DropdownMultiSelectionItem(
                  onTap: () {
                    setState(() {
                      // Toggle between selecting all and clearing the selection.
                      if (_isAllSelected) {
                        _selectedValues.clear();
                      } else {
                        _selectedValues = List.of(widget.data);
                      }
                      _isAllSelected = !_isAllSelected;
                    });
                    // Notify the parent widget of the change.
                    _updateSelectedValues();
                  },
                  isSelected: _isAllSelected,
                  label: "Select All",
                ),
              ),
            ],
            // The scrollable list of individual dropdown items.
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: UIHelpers.paddingA16,
                itemCount: widget.data.length,
                separatorBuilder: (_, _) => UIHelpers.spaceV16,
                itemBuilder: (context, index) {
                  final data = widget.data[index];
                  final isSelected = _selectedValues.any(
                    (e) => e.value == data.value,
                  );

                  return DropdownMultiSelectionItem(
                    onTap: () {
                      setState(() {
                        // Add or remove the item from the selection list.
                        if (isSelected) {
                          _selectedValues.removeWhere(
                            (e) => data.value == e.value,
                          );
                        } else {
                          _selectedValues.add(data);
                        }

                        // Update the "Select All" status based on the current selection.
                        _isAllSelected =
                            widget.data.length == _selectedValues.length;
                      });
                      // Notify the parent widget of the change.
                      _updateSelectedValues();
                    },
                    isSelected: isSelected,
                    label: data.label,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  /// Updates the text field's content to reflect the current selection.
  void _updateControllerText() {
    // Runs after the frame is built to avoid errors during build cycles.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Joins the labels of selected items into a comma-separated string.
        _controller.text = _selectedValues
            .map((e) => e.label)
            .where((l) => l != null)
            .join(", ");
      }
    });
  }

  /// Propagates selection changes to the parent widget and updates the UI.
  void _updateSelectedValues() {
    _updateControllerText();
    // Calls the onChanged callback with the list of selected values.
    widget.onChanged(_selectedValues.map((e) => e.value).toList());
  }
}

class DropdownMultiSelectionItem extends StatelessWidget {
  final String? label;
  final bool isSelected;
  final Function() onTap;

  const DropdownMultiSelectionItem({
    super.key,
    this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.border : AppColors.white,
          borderRadius: UIHelpers.radiusC8,
          border: Border.all(color: AppColors.border),
        ),
        child: Padding(
          padding: UIHelpers.paddingA12,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: BaseText(label ?? "")),
              if (isSelected)
                const Icon(Icons.check_box, color: AppColors.primary)
              else
                const Icon(
                  Icons.check_box_outline_blank,
                  color: AppColors.fade,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
