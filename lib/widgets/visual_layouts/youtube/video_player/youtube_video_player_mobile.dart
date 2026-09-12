import 'package:material_ui/material_ui.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/utils/debounce_time.dart';
import 'package:ui_library/widgets/visual_layouts/youtube/video_player/controller/youtube_player_controller_mobile.dart';
import 'package:ui_library/widgets/visual_layouts/youtube/video_player/models/youtube_player_state.dart';
import 'package:ui_library/widgets/visual_layouts/youtube/video_player/widgets/mobile/youtube_player_controls_mobile.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
  final void Function(YoutubePlayerControllerMobile controller)? onInitialized;
  final void Function(YoutubePlayerState state)? onStateChanged;

  @override
  State<YoutubeVideoPlayer> createState() => _YoutubeVideoPlayerState();
}

class _YoutubeVideoPlayerState extends State<YoutubeVideoPlayer>
    with AutomaticKeepAliveClientMixin {
  late final AppLifecycleListener _appLifeCycleListener;
  final _mediaController = YoutubePlayerControllerMobile();
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
      startAt: widget.videoStartAt,
    );
    if (_controller != null) {
      _mediaController.listenControllerChanges(
        onStateChanged: widget.onStateChanged,
      );
    }
    // Notify when the controller is ready
    widget.onInitialized?.call(_mediaController);
    // AppLifecycleObserver.
    _appLifeCycleListener = AppLifecycleListener(
      onResume: _mediaController.onAppResumed,
    );
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
    _appLifeCycleListener.dispose();
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

    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (event) => _showController(),
      child: Stack(
        alignment: Alignment.center,
        children: [
          IgnorePointer(child: YoutubePlayer(controller: _controller!)),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ValueListenableBuilder(
              valueListenable: _visibilityNotifier,
              builder: (context, show, child) {
                if (show) {
                  return YoutubePlayerControlsMobile(
                    controller: _mediaController,
                    onExpansion: widget.isExpanded != null ? onExpansion : null,
                    isExpanded: widget.isExpanded,
                  );
                }
                return const SizedBox.expand();
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

  void _hideController() => _debounceTime.run(() {
    if (mounted) {
      _visibilityNotifier.value = false;
    }
  });

  void onExpansion() {}
}
