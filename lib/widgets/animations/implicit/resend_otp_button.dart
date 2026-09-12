import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:material_ui/material_ui.dart';
import 'package:ui_library/widgets/animations/explicit/animated_loading_circle.dart';
import 'package:ui_library/widgets/user_inputs/button/base_text_button.dart';

class ResendOTPButton extends HookWidget {
  const ResendOTPButton({
    super.key,
    required this.onOTPSend,
    this.expiryDuration = const Duration(seconds: 10),
  });
  final Future<void> Function() onOTPSend;
  final Duration expiryDuration;

  @override
  Widget build(BuildContext context) {
    final showTimer = useState(true);
    final loading = useState(false);

    if (loading.value) {
      return SizedBox(
        height: 30,
        child: AnimatedLoadingCircle.small(color: Colors.black),
      );
    }

    return TweenAnimationBuilder(
      tween: Tween<Duration>(begin: expiryDuration, end: Duration.zero),
      duration: expiryDuration,
      onEnd: () => showTimer.value = false,
      builder: (context, duration, child) {
        return BaseTextButton(
          onPressed: () async {
            loading.value = true;
            await onOTPSend();
            // If the widget is disposed, don't update value
            if (context.mounted) {
              loading.value = false;
              showTimer.value = true;
            }
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
