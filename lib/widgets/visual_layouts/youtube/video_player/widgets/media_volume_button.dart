// © 2026 vAIolin LLC. All rights reserved.
//
// This software and its associated materials are the intellectual
// property of vAIolin LLC. Unauthorized copying, modification,
// distribution, or use of this code, in whole or in part, without
// express written permission from vAIolin LLC is strictly prohibited.
//
// For licensing inquiries, contact: snehesh@vaiolin.ai

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/utils/debounce_time.dart';
import 'package:ui_library/utils/ui_helpers.dart';
import 'package:ui_library/widgets/user_inputs/slider/base_slider.dart';

class MediaVolumeButton extends HookWidget {
  const MediaVolumeButton({
    super.key,
    required this.volumeNotifier,
    required this.muteNotifier,
    required this.onVolumeChanged,
    required this.onMuteUnmute,
  });

  final ValueNotifier<int> volumeNotifier;
  final ValueNotifier<bool> muteNotifier;
  final void Function(double) onVolumeChanged;
  final void Function() onMuteUnmute;

  @override
  Widget build(BuildContext context) {
    final debounceTime = useMemoized(
      () => DebounceTime(delay: const Duration(seconds: 2)),
    );
    final volumeVisibility = useState(false);
    final volume = useListenable(volumeNotifier);
    final isMuted = useListenable(muteNotifier);
    final showButton = useCallback(() {
      volumeVisibility.value = true;
      debounceTime.run(() {
        if (context.mounted) {
          volumeVisibility.value = false;
        }
      });
    });

    IconData icon = Icons.volume_up_outlined;
    if (isMuted.value) {
      icon = Icons.volume_off_outlined;
    } else if (volume.value < 100) {
      icon = Icons.volume_down_outlined;
    }

    return Listener(
      onPointerDown: (_) => showButton(),
      onPointerHover: (_) => showButton(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (volumeVisibility.value) ...[
            SizedBox(
              height: 80,
              child: RotatedBox(
                quarterTurns: 3,
                child: BaseSlider(
                  value: volume.value.clamp(0, 100).toDouble(),
                  max: 100,
                  activeColor: AppColors.white,
                  inactiveColor: kIsWeb ? AppColors.white38 : AppColors.black38,
                  trackHeight: 5,
                  thumbColor: AppColors.white,
                  onChanged: onVolumeChanged,
                ),
              ),
            ),
            UIHelpers.spaceV8,
          ],
          InkWell(
            onTap: kIsWeb ? onMuteUnmute : null,
            child: Icon(icon, color: AppColors.white, size: 32),
          ),
        ],
      ),
    );
  }
}
