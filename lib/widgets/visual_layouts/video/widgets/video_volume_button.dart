import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:material_ui/material_ui.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/utils/debounce_time.dart';
import 'package:ui_library/widgets/user_inputs/button/base_icon_button.dart';
import 'package:ui_library/widgets/user_inputs/slider/base_slider.dart';

/// Mute toggle with a hover/tap-revealed volume slider; tapping while
/// revealed toggles mute on web, alongside the hardware volume buttons.
class VideoVolumeButton extends StatefulWidget {
  const VideoVolumeButton({
    super.key,
    required this.volumeNotifier,
    required this.muteNotifier,
    required this.onVolumeChanged,
    required this.onMuteUnmute,
    this.sliderWidth = 72,
  });

  final ValueNotifier<int> volumeNotifier;
  final ValueNotifier<bool> muteNotifier;
  final void Function(double) onVolumeChanged;
  final void Function() onMuteUnmute;

  /// Width of the slider track when revealed.
  final double sliderWidth;

  @override
  State<VideoVolumeButton> createState() => _VideoVolumeButtonState();
}

class _VideoVolumeButtonState extends State<VideoVolumeButton> {
  static const Duration _revealDuration = Duration(milliseconds: 150);
  static const double _thumbRadius = 5;

  final _autoCollapseTimer = DebounceTime(delay: const Duration(seconds: 2));
  bool _hovering = false;
  bool _pinnedOpen = false;

  bool get _revealed => _hovering || _pinnedOpen;

  void _handleButtonPressed() {
    if (!_revealed) {
      setState(() => _pinnedOpen = true);
      _scheduleAutoCollapse();
      return;
    }
    // Mobile relies on the hardware volume buttons; only the slider (for
    // fine in-app control) is offered there, matching the previous design.
    if (kIsWeb) {
      widget.onMuteUnmute();
    }
  }

  // Touch never triggers MouseRegion.onExit, so auto-collapse on inactivity
  // instead; re-scheduled on each drag end so it never fires mid-drag.
  void _scheduleAutoCollapse() {
    _autoCollapseTimer.run(() {
      if (mounted) {
        setState(() => _pinnedOpen = false);
      }
    });
  }

  @override
  void dispose() {
    _autoCollapseTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() {
        _hovering = false;
        _pinnedOpen = false;
      }),
      child: ValueListenableBuilder(
        valueListenable: widget.muteNotifier,
        builder: (context, isMuted, child) {
          return ValueListenableBuilder(
            valueListenable: widget.volumeNotifier,
            builder: (context, volume, child) {
              IconData icon = Icons.volume_up_rounded;
              if (isMuted || volume == 0) {
                icon = Icons.volume_off_rounded;
              } else if (volume < 50) {
                icon = Icons.volume_down_rounded;
              }

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BaseIconButton(
                    onPressed: _handleButtonPressed,
                    icon: Icon(icon, color: AppColors.white),
                  ),
                  ClipRect(
                    child: AnimatedSize(
                      duration: _revealDuration,
                      alignment: Alignment.centerLeft,
                      child: !_revealed
                          ? const SizedBox.shrink()
                          : SizedBox(
                              // Extra room for the thumb, which sits at the
                              // edge at min/max and would otherwise be
                              // clipped by `ClipRect`.
                              width: widget.sliderWidth + _thumbRadius * 2,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: _thumbRadius,
                                ),
                                child: BaseSlider(
                                  value: isMuted ? 0 : volume.toDouble(),
                                  max: 100,
                                  activeColor: AppColors.white,
                                  thumbColor: AppColors.white,
                                  trackHeight: 2,
                                  thumbRadius: _thumbRadius,
                                  onChanged: widget.onVolumeChanged,
                                  onChangeStart: (_) =>
                                      _autoCollapseTimer.cancel(),
                                  onChangeEnd: (_) => _scheduleAutoCollapse(),
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
