import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:material_ui/material_ui.dart';
import 'package:ui_library/widgets/animations/explicit/loading_circle.dart';
import 'package:ui_library/widgets/user_inputs/button/base_text_button.dart';

class ResendOTPButton extends HookWidget {
  const ResendOTPButton({super.key, required this.onOTPSend});
  final void Function() onOTPSend;

  @override
  Widget build(BuildContext context) {
    final showTimer = useState(true);
    final loading = useState(false);

    if (loading.value) {
      return SizedBox(
        height: 30,
        child: LoadingCircle.small(color: Colors.black),
      );
    }

    return TweenAnimationBuilder(
      tween: Tween<Duration>(
        begin: const Duration(seconds: 10),
        end: Duration.zero,
      ),
      duration: const Duration(seconds: 10),
      onEnd: () => showTimer.value = false,
      builder: (context, duration, child) {
        return BaseTextButton(
          onPressed: () {
            loading.value = true;
            onOTPSend();
            loading.value = false;
            showTimer.value = true;
          },
          text: showTimer.value
              ? 'Resend OTP (${duration.inSeconds})'
              : 'Resend OTP',
          foregroundColor: Colors.black,
          expanded: true,
          disabled: showTimer.value,
        );
      },
    );
  }
}
