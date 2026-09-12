import 'package:material_ui/material_ui.dart';
import 'package:ui_library/widgets/visual_layouts/base_text.dart';

class BottomSheetTitle extends StatelessWidget {

  const BottomSheetTitle({
    super.key,
    required this.title,
    this.titleAlignment = Alignment.centerLeft,
    this.titleColor,
  });
  final String title;
  final Alignment titleAlignment;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Align(
                  alignment: titleAlignment,
                  child: BaseText(
                    title,
                    color: titleColor ?? Colors.blueAccent,
                    fontSize: 16,
                  ),
                ),
              ),
              InkWell(
                onTap: () => Navigator.pop(context),
                customBorder: const CircleBorder(),
                child: const Icon(Icons.close, size: 30),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Colors.grey),
      ],
    );
  }
}
