import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/utils/debounce_time.dart';
import 'package:ui_library/utils/ui_helpers.dart';
import 'package:ui_library/widgets/user_inputs/slider/base_slider.dart';
import 'package:ui_library/widgets/visual_layouts/youtube/video_player/controller/youtube_mobile_media_controller.dart';

class MobileMediaVolumeButton extends HookWidget {
  const MobileMediaVolumeButton({super.key, required this.controller});
  final YoutubeMobileMediaController controller;

  @override
  Widget build(BuildContext context) {
    final debounceTime = useMemoized(
      () => DebounceTime(delay: const Duration(seconds: 2)),
    );
    final volumeVisibility = useState(false);
    final volume = useListenable(controller.volumeNotifier);
    final isMuted = useListenable(controller.muteNotifier);
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
                  onChanged: controller.onVolumeChanged,
                ),
              ),
            ),
            UIHelpers.spaceV8,
          ],
          InkWell(
            onTap: kIsWeb ? controller.onMuteUnmute : null,
            child: Icon(icon, color: AppColors.white, size: 32),
          ),
        ],
      ),
    );
  }
}
