import 'dart:math';

import 'package:material_ui/material_ui.dart';

class AnimatedIndicator extends StatefulWidget {

  const AnimatedIndicator({
    super.key,
    required this.length,
    this.activeIndex = 0,
    this.height = 6,
    this.width = 12,
    this.activeWidth = 24,
    this.activeHeight = 6,
    this.activeColor,
    this.inactiveColor,
    this.inActiveBorderRadius,
    this.activeBorderRadius,
    this.spacing = 5,
    this.isProgressIndicator = false,
  });

  factory AnimatedIndicator.circular({
    required int length,
    int activeIndex = 0,
    double diameter = 8,
    double activeDiameter = 12,
    Color? activeColor,
    Color? inactiveColor,
    double spacing = 5,
  }) => AnimatedIndicator(
    length: length,
    activeIndex: activeIndex,
    height: diameter,
    width: diameter,
    activeWidth: activeDiameter,
    activeHeight: activeDiameter,
    activeColor: activeColor,
    inactiveColor: inactiveColor,
    inActiveBorderRadius: BorderRadius.circular(diameter),
    activeBorderRadius: BorderRadius.circular(activeDiameter),
    spacing: spacing,
  );
  /// The number of indicators
  final int length;

  /// Active index
  final int activeIndex;

  /// height of the indicator
  final double height;

  /// Width of the indicator when not selected
  final double width;

  /// Width of the indicator when selected
  final double activeWidth;

  /// Width of the indicator when selected
  final double activeHeight;

  /// Color of the indicator when selected
  final Color? activeColor;

  /// Color of the indicator when not selected
  final Color? inactiveColor;

  /// Border radius of the active indicator
  final BorderRadius? inActiveBorderRadius;

  /// Border radius of the inactive indicator
  final BorderRadius? activeBorderRadius;

  /// space between the indicators
  final double spacing;

  /// Makes the style of previous and current index same
  final bool isProgressIndicator;

  @override
  State<AnimatedIndicator> createState() => _AnimatedIndicatorState();
}

class _AnimatedIndicatorState extends State<AnimatedIndicator> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.activeIndex;
  }

  @override
  void didUpdateWidget(covariant AnimatedIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.activeIndex != widget.activeIndex) {
      setState(() => selectedIndex = widget.activeIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeColor =
        widget.activeColor ?? Theme.of(context).colorScheme.primary;
    final inActiveColor = widget.inactiveColor ?? Colors.grey.shade400;

    return SizedBox(
      height: max(widget.height, widget.activeHeight),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.length,
        separatorBuilder: (context, index) => SizedBox(width: widget.spacing),
        itemBuilder: (context, index) {
          final bool isActive = widget.isProgressIndicator
              ? index <= selectedIndex
              : index == selectedIndex;

          final color = isActive ? activeColor : inActiveColor;
          final double newWidth = isActive ? widget.activeWidth : widget.width;
          final double newHeight = isActive ? widget.activeHeight : widget.height;
          final BorderRadius borderRadius = isActive
              ? (widget.activeBorderRadius ??
                    BorderRadius.circular(widget.activeHeight))
              : (widget.inActiveBorderRadius ??
                    BorderRadius.circular(widget.height));

          return Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: newHeight,
              width: newWidth,
              decoration: BoxDecoration(
                color: color,
                borderRadius: borderRadius,
              ),
            ),
          );
        },
      ),
    );
  }
}
