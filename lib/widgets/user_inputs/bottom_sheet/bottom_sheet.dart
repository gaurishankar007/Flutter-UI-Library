import 'package:flutter/cupertino.dart';
import 'package:ui_library/widgets/user_inputs/bottom_sheet/bottom_sheet_body.dart';
import 'package:ui_library/widgets/user_inputs/bottom_sheet/bottom_sheet_title.dart';

class BaseBottomSheet extends StatelessWidget {
  final String title;
  final Alignment titleAlignment;
  final List<Widget> children;

  const BaseBottomSheet({
    super.key,
    required this.title,
    this.titleAlignment = Alignment.centerLeft,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BottomSheetTitle(title: title, titleAlignment: titleAlignment),
        BottomSheetBody(children: children),
      ],
    );
  }
}
