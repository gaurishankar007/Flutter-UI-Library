import 'dart:io';

import 'package:material_ui/material_ui.dart';
import 'package:ui_library/core/error_handler.dart';
import 'package:video_player/video_player.dart';

class AppVideoPlayerController {
  AppVideoPlayerController.file({required String path}) {
    _controller = VideoPlayerController.file(File(path));
  }

  AppVideoPlayerController.network({required String path}) {
    _controller = VideoPlayerController.networkUrl(Uri.parse(path));
  }

  AppVideoPlayerController.asset({required String path}) {
    _controller = VideoPlayerController.asset(path);
  }

  late final VideoPlayerController _controller;
  final playingNotifier = ValueNotifier<bool>(false);
  final hasEndedNotifier = ValueNotifier<bool>(false);
  final muteNotifier = ValueNotifier<bool>(false);
  final volumeNotifier = ValueNotifier<int>(100);
  final playbackRateNotifier = ValueNotifier<double>(1);
  final positionNotifier = ValueNotifier<Duration>(Duration.zero);
  Duration _videoDuration = Duration.zero;

  VideoPlayerController get playerController => _controller;
  double get aspectRatio => _controller.value.aspectRatio;
  bool get isInitialized => _controller.value.isInitialized;
  Duration get videoDuration => _videoDuration;

  Future<void> initialize({required bool autoPlay, required bool loop}) async {
    await ErrorHandler.executeSafe(() async {
      await _controller.initialize();
      await _controller.setLooping(loop);
      autoPlay ? await _controller.play() : await _controller.pause();
      playingNotifier.value = autoPlay;
      _videoDuration = _controller.value.duration;
      _controller.addListener(_onVideoPlayerChanged);
    });
  }

  void _onVideoPlayerChanged() {
    final position = _controller.value.position;
    positionNotifier.value = position;

    // video_player stops on its own at the end without calling `onPlayPause`,
    // so `playingNotifier` wouldn't otherwise learn about it.
    final hasEnded =
        _videoDuration > Duration.zero && position >= _videoDuration;
    if (hasEnded != hasEndedNotifier.value) {
      hasEndedNotifier.value = hasEnded;
    }
    if (hasEnded && playingNotifier.value) {
      playingNotifier.value = false;
    }
  }

  /// Seeks the player to the given position
  Future<void> onPositionChanged(double value) async {
    await ErrorHandler.executeSafe(() async {
      final position = (value * _videoDuration.inSeconds).toInt();
      await _controller.seekTo(Duration(seconds: position));
    });
  }

  // Seek to 5 seconds backward or forward
  Future<void> onReplayForward(bool isReplay) async {
    await ErrorHandler.executeSafe(() async {
      final currentPosition = positionNotifier.value.inSeconds;
      final totalTime = _videoDuration.inSeconds;
      final seekSeconds = isReplay ? -5 : 5;
      final newPosition = (currentPosition + seekSeconds).clamp(0, totalTime);
      await _controller.seekTo(Duration(seconds: newPosition));
    });
  }

  Future<void> onPlayPause() async {
    await ErrorHandler.executeSafe(() async {
      if (hasEndedNotifier.value) {
        await _controller.seekTo(Duration.zero);
        await _controller.play();
        playingNotifier.value = true;
        hasEndedNotifier.value = false;
        return;
      }

      playingNotifier.value
          ? await _controller.pause()
          : await _controller.play();
      playingNotifier.value = !playingNotifier.value;
    });
  }

  Future<void> onAppResumed() async {
    await ErrorHandler.executeSafe(() async {
      if (playingNotifier.value) {
        await _controller.play();
      }
    });
  }

  Future<void> onMuteUnmute() async {
    await ErrorHandler.executeSafe(() async {
      if (muteNotifier.value) {
        // Volume
        volumeNotifier.value = 100;
        await _controller.setVolume(100);
      } else {
        // Volume
        volumeNotifier.value = 0;
        await _controller.setVolume(0);
      }

      muteNotifier.value = !muteNotifier.value;
    });
  }

  Future<void> onVolumeChanged(double volume) async {
    await ErrorHandler.executeSafe(() async {
      volumeNotifier.value = volume.toInt();
      await _controller.setVolume(volume);

      if (volume == 0) {
        muteNotifier.value = true;
      } else {
        muteNotifier.value = false;
      }
    });
  }

  Future<void> onPlaybackRateChanged(double playbackRate) async {
    await ErrorHandler.executeSafe(() async {
      playbackRateNotifier.value = playbackRate;
      await _controller.setPlaybackSpeed(playbackRate);
    });
  }

  Future<void> dispose() async {
    await ErrorHandler.executeSafe(() async {
      _controller.removeListener(_onVideoPlayerChanged);
      playingNotifier.dispose();
      hasEndedNotifier.dispose();
      muteNotifier.dispose();
      volumeNotifier.dispose();
      playbackRateNotifier.dispose();
      positionNotifier.dispose();
      await _controller.dispose();
    });
  }
}
