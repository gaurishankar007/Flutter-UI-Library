import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:ui_library/utils/debounce_time.dart';
import 'package:ui_library/widgets/visual_layouts/error_icon.dart';
import 'package:ui_library/widgets/visual_layouts/youtube/video_player/util/youtube_media_controller.dart';
import 'package:ui_library/widgets/visual_layouts/youtube/video_player/widgets/youtube_video_controller.dart';
import 'package:ui_library/widgets/visual_layouts/youtube/video_player/widgets/youtube_video_play_seek_controller.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubeVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final double aspectRatio;
  final Function(YoutubeMediaController controller)? onInitialized;

  const YoutubeVideoPlayer({
    super.key,
    required this.videoUrl,
    this.aspectRatio = 16 / 9,
    this.onInitialized,
  });

  @override
  State<YoutubeVideoPlayer> createState() => _YoutubeVideoPlayerState();
}

class _YoutubeVideoPlayerState extends State<YoutubeVideoPlayer> {
  final _mediaController = YoutubeMediaController();
  final _focusNode = FocusNode();
  final _debounceTime = DebounceTime(delay: Duration(milliseconds: 3500));
  final _visibilityNotifier = ValueNotifier(true);
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();

    // Initialize the controller with the video Id
    _controller = _mediaController.initializeController(widget.videoUrl);
    if (_controller != null) _mediaController.listenControllerChanges();
    // Notify when the controller is ready
    widget.onInitialized?.call(_mediaController);
    // Hide the controller after a delay
    _hideController();
    // Request focus to capture keyboard events
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _mediaController.close();
    _debounceTime.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) return Center(child: ErrorIcon());

    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: onKeyEvent,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: YoutubePlayer(
              controller: _controller!,
              aspectRatio: widget.aspectRatio,
            ),
          ),
          Positioned.fill(
            child: PointerInterceptor(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (!_focusNode.hasFocus) _focusNode.requestFocus();
                  _showController();
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Listener(
              behavior: HitTestBehavior.translucent,
              onPointerDown: (event) => _showController(),
              child: Column(
                children: [
                  Expanded(
                    child: YoutubeVideoPlaySeekController(
                      controller: _mediaController,
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: _visibilityNotifier,
                    builder: (context, show, child) {
                      if (!show) return SizedBox.shrink();
                      return YoutubeVideoController(
                        controller: _mediaController,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Show the controller only if it is not shown
  void _showController() {
    if (!_visibilityNotifier.value) _visibilityNotifier.value = true;
    _hideController();
  }

  void _hideController() =>
      _debounceTime.run(() => _visibilityNotifier.value = false);

  KeyEventResult onKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    bool handled = true;
    switch (event.logicalKey) {
      case LogicalKeyboardKey.space:
        _mediaController.onPlayPause();
        break;
      case LogicalKeyboardKey.keyM:
        _mediaController.onMuteUnmute();
        break;
      case LogicalKeyboardKey.arrowLeft:
        _mediaController.onReplayForward(true);
        break;
      case LogicalKeyboardKey.arrowRight:
        _mediaController.onReplayForward(false);
        break;
      case LogicalKeyboardKey.arrowUp:
        _mediaController.onVolumeUpDown(true);
        break;
      case LogicalKeyboardKey.arrowDown:
        _mediaController.onVolumeUpDown(false);
        break;
      default:
        handled = false;
    }

    if (handled) {
      _showController();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }
}
