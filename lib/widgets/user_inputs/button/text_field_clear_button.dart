import 'package:material_ui/material_ui.dart';
import 'package:ui_library/widgets/user_inputs/button/base_icon_button.dart';

class TextFieldClearButton extends StatelessWidget {
  const TextFieldClearButton({
    super.key,
    required this.textController,
    this.onClearTap,
  });
  final TextEditingController textController;
  final void Function()? onClearTap;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: textController,
      builder: (context, widget) {
        if (textController.text.isEmpty) {
          return const SizedBox.shrink();
        }
        return BaseIconButton(
          icon: const Icon(Icons.close_outlined),
          onPressed: () {
            textController.clear();
            FocusManager.instance.primaryFocus?.unfocus();
            onClearTap?.call();
          },
        );
      },
    );
  }
}
