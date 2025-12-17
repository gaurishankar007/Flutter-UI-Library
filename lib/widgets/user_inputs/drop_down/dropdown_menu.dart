import 'package:flutter/material.dart';
import 'package:ui_library/widgets/visual_layouts/base_text.dart';

/// A dropdown menu widget that provides a flexible and customizable way to select an item from a list.
///
/// This widget supports features like filtering, searching, and custom styling. It allows users to
/// select an item from a dropdown menu with optional filtering and search capabilities. The width of
/// the dropdown menu determines the width of the popup container, and it supports callbacks for
/// selection, filtering, and searching.
class BaseDropdownMenu<T> extends StatelessWidget {
  final double? width;
  final String? label;
  final String? hintText;
  final bool enableFilter;
  final bool enableSearch;
  final TextEditingController? controller;
  final T? initialSelection;
  final Function(T?)? onSelected;
  final FilterCallback<T>? filterCallback;
  final SearchCallback<T>? searchCallback;
  final List<DropdownMenuEntry<T>> entries;

  const BaseDropdownMenu({
    super.key,
    this.width,
    this.label,
    this.hintText,
    this.enableFilter = false,
    this.enableSearch = true,
    this.controller,
    this.initialSelection,
    this.onSelected,
    this.filterCallback,
    this.searchCallback,
    required this.entries,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      alignedDropdown: true,
      child: DropdownMenu<T>(
        width: width,
        label: label != null ? BaseText(label!) : null,
        hintText: hintText,
        enableFilter: enableFilter,
        enableSearch: enableSearch,
        controller: controller,
        initialSelection: initialSelection,
        onSelected: onSelected,
        requestFocusOnTap: true,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        menuStyle: const MenuStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.lightBlue),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),
        filterCallback: filterCallback,
        searchCallback: searchCallback,
        dropdownMenuEntries: entries
            .map<DropdownMenuEntry<T>>(
              (dropDownItem) => DropdownMenuEntry<T>(
                value: dropDownItem.value,
                label: dropDownItem.label,
              ),
            )
            .toList(),
      ),
    );
  }
}
