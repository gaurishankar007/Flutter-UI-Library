import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../../../utils/debounce_time.dart';
import '../../../../utils/ui_helpers.dart';
import '../../error_icon.dart';
import 'util/youtube_media_controller.dart';
import 'widgets/youtube_video_controller.dart';
import 'widgets/youtube_video_play_seek_controller.dart';

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
  late final AppLifecycleListener _appLifeCycleListener;
  final _mediaController = YoutubeMediaController();
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

    // AppLifecycleObserver.
    _appLifeCycleListener = AppLifecycleListener(
      onResume: _mediaController.onAppResumed,
    );
  }

  @override
  void dispose() {
    _appLifeCycleListener.dispose();
    _mediaController.close();
    _debounceTime.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) return Center(child: ErrorIcon());

    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (event) => _showController(),
      child: Stack(
        alignment: Alignment.center,
        children: [
          IgnorePointer(
            child: YoutubePlayer(
              controller: _controller!,
              aspectRatio: widget.aspectRatio,
            ),
          ),
          AspectRatio(
            aspectRatio: widget.aspectRatio,
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
                    if (!show) return UIHelpers.nothing;
                    return YoutubeVideoController(controller: _mediaController);
                  },
                ),
              ],
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
}
