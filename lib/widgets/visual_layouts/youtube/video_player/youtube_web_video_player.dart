import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/utils/debounce_time.dart';
import 'package:ui_library/widgets/visual_layouts/youtube/video_player/controller/youtube_web_media_controller.dart';
import 'package:ui_library/widgets/visual_layouts/youtube/video_player/widgets/web/youtube_web_video_controller.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubeVideoPlayer extends StatefulWidget {
  const YoutubeVideoPlayer({
    super.key,
    required this.videoUrl,
    this.aspectRatio = 16 / 9,
    this.isExpandable = false,
    this.isExpanded = false,
    this.onInitialized,
  });

  final String videoUrl;
  final double aspectRatio;
  final bool isExpandable;
  final bool isExpanded;
  final void Function(YoutubeWebMediaController controller)? onInitialized;

  @override
  State<YoutubeVideoPlayer> createState() => _YoutubeVideoPlayerState();
}

class _YoutubeVideoPlayerState extends State<YoutubeVideoPlayer>
    with AutomaticKeepAliveClientMixin {
  final _mediaController = YoutubeWebMediaController();
  final _focusNode = FocusNode();
  final _debounceTime = DebounceTime(delay: const Duration(milliseconds: 4500));
  final _visibilityNotifier = ValueNotifier(false);
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();

    // Initialize the controller with the video Id
    _controller = _mediaController.initializeController(widget.videoUrl);
    if (_controller != null) {
      _mediaController.listenControllerChanges();
    }
    // Notify when the controller is ready
    widget.onInitialized?.call(_mediaController);
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
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_controller == null) {
      return const Center(
        child: Icon(
          Icons.ondemand_video_rounded,
          color: AppColors.gray,
          size: 50,
        ),
      );
    }

    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: onKeyEvent,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: widget.aspectRatio,
            child: YoutubePlayer(
              controller: _controller!,
              aspectRatio: widget.aspectRatio,
            ),
          ),
          Positioned.fill(
            child: PointerInterceptor(
              // The GestureDetector is required here for two reasons:
              // 1. To capture taps on the video area when controls are hidden,
              //    ensuring the controls become visible (_showController).
              // 2. To request focus for the FocusNode, which enables the keyboard
              //    shortcuts (Space, M, Arrows) to work. Without this, clicking
              //    the iframe would shift focus to the browser's iframe context.
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (!_focusNode.hasFocus) {
                    _focusNode.requestFocus();
                  }
                  _showController();
                },
              ),
            ),
          ),
          AspectRatio(
            aspectRatio: widget.aspectRatio,
            child: Listener(
              behavior: HitTestBehavior.translucent,
              onPointerDown: (_) => _showController(),
              onPointerHover: (_) => _showController(),
              child: ValueListenableBuilder(
                valueListenable: _visibilityNotifier,
                builder: (context, show, child) {
                  return show
                      ? YoutubeWebVideoController(
                          controller: _mediaController,
                          onExpansion: widget.isExpandable ? onExpansion : null,
                          isExpanded: widget.isExpanded,
                        )
                      : const SizedBox.expand();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Show the controller only if it is not shown
  void _showController() {
    if (!_visibilityNotifier.value) {
      _visibilityNotifier.value = true;
    }
    _hideController();
  }

  void _hideController() =>
      _debounceTime.run(() => _visibilityNotifier.value = false);

  KeyEventResult onKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }

    var handled = true;
    switch (event.logicalKey) {
      case LogicalKeyboardKey.space:
        _mediaController.onPlayPause();
      case LogicalKeyboardKey.keyM:
        _mediaController.onMuteUnmute();
      case LogicalKeyboardKey.arrowLeft:
        _mediaController.onReplayForward(true);
      case LogicalKeyboardKey.arrowRight:
        _mediaController.onReplayForward(false);
      case LogicalKeyboardKey.arrowUp:
        _mediaController.onVolumeUpDown(true);
      case LogicalKeyboardKey.arrowDown:
        _mediaController.onVolumeUpDown(false);
      default:
        handled = false;
    }

    if (handled) {
      _showController();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void onExpansion() {}
}
