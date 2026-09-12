import 'dart:async';

import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:material_ui/material_ui.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/utils/screen_util/screen_util.dart';
import 'package:ui_library/utils/ui_helpers.dart';
import 'package:ui_library/widgets/visual_layouts/video/app_video_player_controller.dart';
import 'package:ui_library/widgets/visual_layouts/video/widgets/video_gesture_detector.dart';
import 'package:ui_library/widgets/visual_layouts/video/widgets/video_play_button.dart';
import 'package:ui_library/widgets/visual_layouts/video/widgets/video_playback_speed.dart';
import 'package:ui_library/widgets/visual_layouts/video/widgets/video_player_seeker.dart';
import 'package:ui_library/widgets/visual_layouts/video/widgets/video_progress.dart';
import 'package:ui_library/widgets/visual_layouts/video/widgets/video_volume_button.dart';

/// A YouTube-style control overlay: auto-hiding chrome, a play/pause button,
/// double-tap seek zones, and a bottom bar with progress/volume/speed controls.
class VideoPlayerControls extends StatefulWidget {
  const VideoPlayerControls({
    super.key,
    required this.controller,
    this.hidePlaybackRate = false,
    this.seekStep = const Duration(seconds: 5),
    this.autoHideDuration = const Duration(seconds: 4),
  });

  final AppVideoPlayerController controller;
  final bool hidePlaybackRate;

  /// Amount seeked by a double tap on either side of the player.
  final Duration seekStep;

  /// Idle time after which the controls fade out while playing.
  final Duration autoHideDuration;

  @override
  State<VideoPlayerControls> createState() => _VideoPlayerControlsState();
}

class _VideoPlayerControlsState extends State<VideoPlayerControls> {
  static const Duration _fadeDuration = Duration(milliseconds: 200);
  static const double _scrimOpacity = 0.4;

  /// Hit-test height of the seek bar inside the bottom bar (slimmer than
  /// the widget default, keeping the bar close to the buttons below it).
  static const double _progressBarHeight = 14;

  bool _visible = true;
  bool _scrubbing = false;
  Timer? _hideTimer;

  AppVideoPlayerController get _controller => widget.controller;

  @override
  void initState() {
    super.initState();
    _restartHideTimer();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  void _restartHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(widget.autoHideDuration, () {
      if (mounted && !_scrubbing) {
        setState(() => _visible = false);
      }
    });
  }

  void _showControls() {
    if (!_visible) {
      setState(() => _visible = true);
    }
    _restartHideTimer();
  }

  /// Toggles control visibility without affecting playback (mobile tap
  /// gesture; play/pause stays on its dedicated button).
  void _toggleControlsVisibility() {
    if (_visible) {
      _hideTimer?.cancel();
      setState(() => _visible = false);
    } else {
      _showControls();
    }
  }

  bool get _isMobile =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android);

  /// Mobile: shows/hides controls only. Web: always toggles play/pause.
  void _handleSurfaceTap() {
    if (_isMobile) {
      _toggleControlsVisibility();
    } else {
      _togglePlayPause();
    }
  }

  /// Postpones auto-hide during pointer interaction, so drags/scrubbing
  /// keep the controls on screen.
  void _keepControlsAlive() {
    if (_visible) {
      _restartHideTimer();
    }
  }

  Future<void> _togglePlayPause() async {
    _showControls();
    await _controller.onPlayPause();
  }

  Future<void> _seekBy(bool isBackward) async {
    _showControls();
    await _controller.onReplayForward(isBackward);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => _keepControlsAlive(),
      onPointerMove: (_) => _keepControlsAlive(),
      // Hover events only exist for mice: moving the pointer over the
      // player reveals the controls, like the YouTube web player.
      onPointerHover: (_) => _showControls(),
      child: VideoGestureDetector(
        onTap: _handleSurfaceTap,
        seekStep: widget.seekStep,
        onDoubleTapBackward: () => _seekBy(true),
        onDoubleTapForward: () => _seekBy(false),
        // Double-tap-to-play/pause in the center zone is a deliberate,
        // dedicated gesture on every platform, unlike the single tap.
        onDoubleTapCenter: _togglePlayPause,
        child: AnimatedOpacity(
          opacity: _visible ? 1 : 0,
          duration: _fadeDuration,
          child: IgnorePointer(
            ignoring: !_visible,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ColoredBox(
                  color: AppColors.black.withValues(alpha: _scrimOpacity),
                ),
                Center(
                  child: VideoPlayButton(
                    playingNotifier: _controller.playingNotifier,
                    hasEndedNotifier: _controller.hasEndedNotifier,
                    onPressed: _togglePlayPause,
                    iconSize: ScreenUtil.I.isWithinPhoneView ? 48 : 56,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildBottomBar(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    // Claims taps in the bar's empty gaps so they hit `_handleSurfaceTap`
    // instead of the seek zones underneath; buttons still win via depth.
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _handleSurfaceTap,
      onDoubleTap: () {},
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: _progressBarHeight,
              child: VideoPlayerSeeker(
                positionNotifier: _controller.positionNotifier,
                duration: _controller.videoDuration,
                onChanged: _controller.onPositionChanged,
                onDragStart: () {
                  _scrubbing = true;
                  _showControls();
                },
                onDragEnd: () {
                  _scrubbing = false;
                  _restartHideTimer();
                },
              ),
            ),
            Row(
              children: [
                if (kIsWeb)
                  VideoPlayButton(
                    playingNotifier: _controller.playingNotifier,
                    hasEndedNotifier: _controller.hasEndedNotifier,
                    onPressed: _togglePlayPause,
                  ),
                VideoVolumeButton(
                  volumeNotifier: _controller.volumeNotifier,
                  muteNotifier: _controller.muteNotifier,
                  onVolumeChanged: _controller.onVolumeChanged,
                  onMuteUnmute: _controller.onMuteUnmute,
                ),
                UIHelpers.spaceH8,
                ValueListenableBuilder(
                  valueListenable: _controller.positionNotifier,
                  builder: (context, position, child) {
                    return VideoProgress(
                      position: position,
                      duration: _controller.videoDuration,
                    );
                  },
                ),
                const Spacer(),
                if (!widget.hidePlaybackRate)
                  VideoPlaybackSpeed(
                    playbackRateNotifier: _controller.playbackRateNotifier,
                    onRateChanged: _controller.onPlaybackRateChanged,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
