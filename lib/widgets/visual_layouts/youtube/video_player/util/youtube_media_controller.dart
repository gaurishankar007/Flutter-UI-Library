import 'dart:async' show Timer;

import 'package:flutter/foundation.dart' show ValueNotifier;
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubeMediaController {
  YoutubePlayerController? _controller;
  Timer? _updateTimer;

  final playingNotifier = ValueNotifier<bool>(false);
  final muteNotifier = ValueNotifier<bool>(false);
  final volumeNotifier = ValueNotifier<int>(100);
  final playbackRateNotifier = ValueNotifier<double>(1.0);
  final positionNotifier = ValueNotifier<double>(0);
  final bufferedNotifier = ValueNotifier<double>(0);

  /// The elapsed time in seconds since the video started playing
  double _currentTime = 0;
  double get currentTime => _currentTime;

  /// The duration in seconds of the currently playing video
  double _duration = 0;
  double get duration => _duration;

  void close() {
    _updateTimer?.cancel();
    playingNotifier.dispose();
    volumeNotifier.dispose();
    playbackRateNotifier.dispose();
    positionNotifier.dispose();
    bufferedNotifier.dispose();
    _controller?.close();
  }

  YoutubePlayerController? initializeController(String videoUrl) {
    final videoId = YoutubePlayerController.convertUrlToId(videoUrl);
    if (videoId == null) return null;

    // Initialize the controller with the video Id
    _controller = YoutubePlayerController.fromVideoId(
      videoId: videoId,
      params: YoutubePlayerParams(
        strictRelatedVideos: true,
        loop: true,
        showVideoAnnotations: false,
        showControls: false,
        enableCaption: false,
        pointerEvents: PointerEvents.none,
      ),
    );

    return _controller!;
  }

  /// Updates the player media values periodically
  void listenControllerChanges() {
    if (_controller == null) return;

    _updateTimer = Timer.periodic(const Duration(milliseconds: 500), (_) async {
      try {
        _duration = await _controller!.duration;
        bufferedNotifier.value = await _controller!.videoLoadedFraction;
        _currentTime = await _controller!.currentTime;

        if (playingNotifier.value) _updatePosition();
      } catch (_) {}
    });
  }

  /// Updates elapsed time
  void _updatePosition() {
    if (_duration == 0 || _currentTime == 0) return;

    // A number between 0 and 1 that specifies the percentage of time elapsed.
    final elapsedValue = (_currentTime / _duration).clamp(0, 1).toDouble();
    positionNotifier.value = elapsedValue;
  }

  /// Replace the video with new one and keep the previous position
  Future<void> loadNewVideo(String videoUrl) async {
    final videoId = YoutubePlayerController.convertUrlToId(videoUrl);
    if (_controller == null || videoId == null) return;

    await _controller!.loadVideoById(
      videoId: YoutubePlayerController.convertUrlToId(videoUrl) ?? "",
      startSeconds: _currentTime,
    );

    // If it was paused, wait for the new video to start playing, then pause it.
    // This ensures the video thumbnail is visible.
    if (!playingNotifier.value) {
      await _controller!.stream.firstWhere(
        (event) =>
            event.playerState == PlayerState.playing ||
            event.playerState == PlayerState.cued,
      );
      await _controller!.pauseVideo();
    }
  }

  /// Seeks the player to the given position
  Future<void> onPositionChanged(double value) async {
    if (_controller == null) return;

    try {
      // Update slider value
      positionNotifier.value = value;
      // Seek to the new position in YouTube Player
      final position = value * _duration;
      await _controller!.seekTo(seconds: position, allowSeekAhead: true);
    } catch (_) {}
  }

  // Seek to 5 seconds backward or  forward
  Future<void> onReplayForward(bool isReplay) async {
    if (_controller == null) return;

    try {
      int seconds = 5;
      if (isReplay) seconds *= -1;

      // Keeping the position in the range of the duration
      final position = (_currentTime + seconds).clamp(0, _duration).toDouble();
      final seekPosition = (position / _duration).clamp(0, 1).toDouble();
      positionNotifier.value = seekPosition;
      await _controller!.seekTo(seconds: position, allowSeekAhead: true);
    } catch (_) {}
  }

  Future<void> onPlayPause() async {
    if (_controller == null) return;

    try {
      playingNotifier.value
          ? await _controller!.pauseVideo()
          : await _controller!.playVideo();
      playingNotifier.value = !playingNotifier.value;
    } catch (_) {}
  }

  Future<void> onAppResumed() async {
    try {
      if (playingNotifier.value) await _controller!.playVideo();
    } catch (_) {}
  }

  Future<void> onMuteUnmute() async {
    if (_controller == null) return;

    try {
      if (muteNotifier.value) {
        await _controller!.unMute();

        // Volume
        volumeNotifier.value = 100;
        await _controller!.setVolume(100);
      } else {
        await _controller!.mute();

        // Volume
        volumeNotifier.value = 0;
        await _controller!.setVolume(0);
      }

      muteNotifier.value = !muteNotifier.value;
    } catch (_) {}
  }

  Future<void> onVolumeChanged(double value) async {
    if (_controller == null) return;

    try {
      final volume = value.round();
      volumeNotifier.value = volume;
      await _controller!.setVolume(volume);

      // Mute
      if (volume == 0) {
        await _controller!.mute();
        muteNotifier.value = true;
      } else {
        await _controller!.unMute();
        muteNotifier.value = false;
      }
    } catch (_) {}
  }

  Future<void> onVolumeUpDown(bool isVolumeUp) async {
    if (_controller == null) return;
    try {
      int volumeChange = 10;
      if (!isVolumeUp) volumeChange *= -1;

      // Keeping the volume in the range of 0 to 100
      final volume = (volumeNotifier.value + volumeChange).clamp(0, 100);
      await onVolumeChanged(volume.toDouble());
    } catch (_) {}
  }

  Future<void> onPlaybackRateChanged(double playbackRate) async {
    if (_controller == null) return;

    try {
      playbackRateNotifier.value = playbackRate;
      await _controller!.setPlaybackRate(playbackRate);
    } catch (_) {}
  }
}
