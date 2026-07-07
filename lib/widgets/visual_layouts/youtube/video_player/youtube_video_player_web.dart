import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/utils/debounce_time.dart';
import 'package:ui_library/widgets/visual_layouts/youtube/video_player/controller/youtube_player_controller_web.dart';
import 'package:ui_library/widgets/visual_layouts/youtube/video_player/models/youtube_player_state.dart';
import 'package:ui_library/widgets/visual_layouts/youtube/video_player/widgets/web/youtube_player_controls_web.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubeVideoPlayer extends StatefulWidget {
  const YoutubeVideoPlayer({
    super.key,
    required this.videoUrl,
    this.autoPlay = false,
    this.videoStartAt,
    this.isExpanded,
    this.onInitialized,
    this.onStateChanged,
  });

  final String videoUrl;
  final bool autoPlay;
  final double? videoStartAt;
  final bool? isExpanded;
  final void Function(YoutubePlayerControllerWeb controller)? onInitialized;
  final void Function(YoutubePlayerState state)? onStateChanged;

  @override
  State<YoutubeVideoPlayer> createState() => _YoutubeVideoPlayerState();
}

class _YoutubeVideoPlayerState extends State<YoutubeVideoPlayer>
    with AutomaticKeepAliveClientMixin {
  final _mediaController = YoutubePlayerControllerWeb();
  final _focusNode = FocusNode();
  final _debounceTime = DebounceTime(delay: const Duration(milliseconds: 4500));
  final _visibilityNotifier = ValueNotifier(false);
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();

    // Initialize the controller with the video Id
    _controller = _mediaController.initialize(
      widget.videoUrl,
      autoPlay: widget.autoPlay,
      startsAt: widget.videoStartAt,
    );
    if (_controller != null) {
      _mediaController.listenControllerChanges(
        onStateChanged: widget.onStateChanged,
      );
    }
    // Notify when the controller is ready
    widget.onInitialized?.call(_mediaController);
    // Request focus to capture keyboard events
    _focusNode.requestFocus();
  }

  @override
  void didUpdateWidget(covariant YoutubeVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _mediaController.loadNewVideo(widget.videoUrl);
    }
  }

  @override
  void dispose() {
    _debounceTime.cancel();
    _focusNode.dispose();
    _visibilityNotifier.dispose();
    _mediaController.dispose();
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
            aspectRatio: 16 / 9,
            child: YoutubePlayer(controller: _controller!),
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
            aspectRatio: 16 / 9,
            child: Listener(
              behavior: HitTestBehavior.translucent,
              onPointerDown: (_) => _showController(),
              onPointerHover: (_) => _showController(),
              child: ValueListenableBuilder(
                valueListenable: _visibilityNotifier,
                builder: (context, show, child) {
                  if (!show) {
                    return const SizedBox.expand();
                  }
                  return YoutubePlayerControlsWeb(
                    controller: _mediaController,
                    onExpansion: widget.isExpanded != null ? onExpansion : null,
                    isExpanded: widget.isExpanded,
                  );
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

  void _hideController() => _debounceTime.run(() {
    if (mounted) {
      _visibilityNotifier.value = false;
    }
  });

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
