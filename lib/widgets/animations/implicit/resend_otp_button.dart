import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../user_inputs/button/base_text_button.dart';
import '../explicit/loading_circle.dart';

class ResendOTPButton extends HookWidget {
  final Function() onOTPSend;
  const ResendOTPButton({super.key, required this.onOTPSend});

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
          onPressed: () async {
            loading.value = true;
            await onOTPSend();
            loading.value = false;
            showTimer.value = true;
          },
          text: showTimer.value
              ? "Resend OTP (${duration.inSeconds})"
              : "Resend OTP",
          foregroundColor: Colors.black,
          fontSize: 16,
          expanded: true,
          disabled: showTimer.value,
        );
      },
    );
  }
}
