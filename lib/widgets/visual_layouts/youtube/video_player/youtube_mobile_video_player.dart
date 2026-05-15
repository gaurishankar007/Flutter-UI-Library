import 'package:flutter/material.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/utils/debounce_time.dart';
import 'package:ui_library/widgets/visual_layouts/youtube/video_player/controller/youtube_mobile_media_controller.dart';
import 'package:ui_library/widgets/visual_layouts/youtube/video_player/widgets/mobile/youtube_mobile_video_controller.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
  final void Function(YoutubeMobileMediaController controller)? onInitialized;

  @override
  State<YoutubeVideoPlayer> createState() => _YoutubeVideoPlayerState();
}

class _YoutubeVideoPlayerState extends State<YoutubeVideoPlayer>
    with AutomaticKeepAliveClientMixin {
  late final AppLifecycleListener _appLifeCycleListener;
  final _mediaController = YoutubeMobileMediaController();
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
            child: ValueListenableBuilder(
              valueListenable: _visibilityNotifier,
              builder: (context, show, child) {
                return show
                    ? YoutubeMobileVideoController(
                        controller: _mediaController,
                        onExpansion: widget.isExpandable ? onExpansion : null,
                        isExpanded: widget.isExpanded,
                      )
                    : const SizedBox.expand();
              },
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

  void onExpansion() {}
}
