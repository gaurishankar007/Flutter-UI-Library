import 'package:material_ui/material_ui.dart';
import 'package:ui_library/utils/ui_helpers.dart';
import 'package:ui_library/widgets/visual_layouts/loading/loading_circle.dart';
import 'package:ui_library/widgets/visual_layouts/video/app_video_player_controller.dart';
import 'package:ui_library/widgets/visual_layouts/video/video_player_controls.dart';
import 'package:video_player/video_player.dart';

/// A generic video player for arbitrary network/file/asset video, with
/// YouTube-style controls (auto-hiding chrome, double-tap seek, volume,
/// playback speed). For YouTube URLs specifically, use `YoutubeVideoPlayer`
/// instead - it embeds via the YouTube SDK/iframe rather than this package's
/// direct `video_player` decoding.
class AppVideoPlayer extends StatefulWidget {
  const AppVideoPlayer({
    super.key,
    required this.controller,
    this.autoPlay = true,
    this.loop = false,
    this.hidePlaybackRate = false,
  });

  AppVideoPlayer.network({
    super.key,
    required String path,
    this.autoPlay = true,
    this.loop = false,
    this.hidePlaybackRate = false,
  }) : controller = AppVideoPlayerController.network(path: path);

  AppVideoPlayer.file({
    super.key,
    required String path,
    this.autoPlay = true,
    this.loop = false,
    this.hidePlaybackRate = false,
  }) : controller = AppVideoPlayerController.file(path: path);

  AppVideoPlayer.asset({
    super.key,
    required String path,
    this.autoPlay = true,
    this.loop = false,
    this.hidePlaybackRate = false,
  }) : controller = AppVideoPlayerController.asset(path: path);

  final AppVideoPlayerController controller;
  final bool autoPlay;
  final bool loop;
  final bool hidePlaybackRate;

  @override
  State<AppVideoPlayer> createState() => _AppVideoPlayerState();
}

class _AppVideoPlayerState extends State<AppVideoPlayer>
    with AutomaticKeepAliveClientMixin {
  late AppVideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _initializeController();
  }

  @override
  void didUpdateWidget(covariant AppVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _controller.dispose();
      _controller = widget.controller;
      _initializeController();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (!_controller.isInitialized) {
      return Padding(
        padding: UIHelpers.paddingA8,
        child: const LoadingCircle(),
      );
    }

    return AspectRatio(
      aspectRatio: _controller.aspectRatio,
      child: Stack(
        fit: StackFit.expand,
        children: [
          VideoPlayer(_controller.playerController),
          VideoPlayerControls(
            controller: _controller,
            hidePlaybackRate: widget.hidePlaybackRate,
          ),
        ],
      ),
    );
  }

  Future<void> _initializeController() async {
    await _controller.initialize(autoPlay: widget.autoPlay, loop: widget.loop);
    if (mounted) {
      setState(() {});
    }
  }
}
