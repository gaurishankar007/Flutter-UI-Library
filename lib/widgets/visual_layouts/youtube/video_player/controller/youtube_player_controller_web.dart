// © 2026 vAIolin LLC. All rights reserved.
//
// This software and its associated materials are the intellectual
// property of vAIolin LLC. Unauthorized copying, modification,
// distribution, or use of this code, in whole or in part, without
// express written permission from vAIolin LLC is strictly prohibited.
//
// For licensing inquiries, contact: snehesh@vaiolin.ai

import 'dart:async' show Timer;

import 'package:flutter/foundation.dart' show ValueNotifier;
import 'package:ui_library/core/error_handler.dart';
import 'package:ui_library/widgets/visual_layouts/youtube/video_player/models/youtube_player_state.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubePlayerControllerWeb {
  YoutubePlayerController? _controller;
  Timer? _updateTimer;

  final playingNotifier = ValueNotifier<bool>(false);
  final muteNotifier = ValueNotifier<bool>(false);
  final volumeNotifier = ValueNotifier<int>(100);
  final playbackRateNotifier = ValueNotifier<double>(1);
  final positionNotifier = ValueNotifier<double>(0);
  final bufferedNotifier = ValueNotifier<double>(0);

  /// The elapsed time in seconds since the video started playing
  double _currentTime = 0;
  double get currentTime => _currentTime;

  /// The duration in seconds of the currently playing video
  double _duration = 0;
  double get duration => _duration;

  YoutubePlayerController? initialize(
    String videoUrl, {
    bool autoPlay = false,
    double? startsAt,
  }) {
    return ErrorHandler.executeSafeReturnSync(() {
      final videoId = YoutubePlayerController.convertUrlToId(videoUrl);
      if (videoId == null) {
        return null;
      }

      // Initialize the controller with the video Id
      playingNotifier.value = autoPlay;
      _controller = YoutubePlayerController.fromVideoId(
        videoId: videoId,
        params: const YoutubePlayerParams(
          enableCaption: false,
          pointerEvents: .none,
          color: 'black',
          showControls: false,
          showVideoAnnotations: false,
        ),
        autoPlay: autoPlay,
        startSeconds: startsAt,
      );

      return _controller;
    }, onError: (_, _) => null);
  }

  /// Updates the player media values periodically
  Future<void> listenControllerChanges({
    void Function(YoutubePlayerState state)? onStateChanged,
  }) async {
    if (_controller case final YoutubePlayerController controller) {
      const updateInterval = Duration(milliseconds: 250);
      _updateTimer = Timer.periodic(updateInterval, (_) async {
        await ErrorHandler.executeSafe(() async {
          bufferedNotifier.value = await controller.videoLoadedFraction;
          _duration = await controller.duration;
          _currentTime = await controller.currentTime;

          if (_duration != 0 && _currentTime != 0) {
            // A number between 0 and 1 that specifies the percentage of time elapsed.
            final elapsedValue = (_currentTime / _duration)
                .clamp(0, 1)
                .toDouble();
            positionNotifier.value = elapsedValue;
          }

          // send the updated state
          onStateChanged?.call(
            YoutubePlayerState(
              duration: _duration,
              currentPosition: _currentTime,
              bufferedPosition: bufferedNotifier.value,
              isPlaying: playingNotifier.value,
              volume: volumeNotifier.value,
              playbackRate: playbackRateNotifier.value,
              isMuted: muteNotifier.value,
            ),
          );
        });
      });
    }
  }

  /// Replace the video with new one and keep the previous position
  Future<void> loadNewVideo(String videoUrl) async {
    if (_controller case final YoutubePlayerController controller) {
      await ErrorHandler.executeSafe(() async {
        await controller.loadVideoById(
          videoId: YoutubePlayerController.convertUrlToId(videoUrl) ?? '',
          startSeconds: _currentTime,
        );

        // If it was paused, wait for the new video to start playing, then pause it.
        // This ensures the video thumbnail is visible.
        if (!playingNotifier.value) {
          await controller.stream.firstWhere(
            (event) =>
                event.playerState == PlayerState.playing ||
                event.playerState == PlayerState.cued,
          );
          await controller.pauseVideo();
        }
      });
    }
  }

  /// Seeks the player to the given position
  Future<void> onPositionChanged(double value) async {
    if (_controller case final YoutubePlayerController controller) {
      await ErrorHandler.executeSafe(() async {
        // Seek to the new position in YouTube Player
        final position = value * _duration;
        await controller.seekTo(seconds: position, allowSeekAhead: true);
      });
    }
  }

  // Seek to 5 seconds backward or  forward
  Future<void> onReplayForward(bool isReplay) async {
    if (_controller case final YoutubePlayerController controller) {
      await ErrorHandler.executeSafe(() async {
        var seconds = 5;
        if (isReplay) {
          seconds *= -1;
        }

        // Keeping the position in the range of the duration
        final position = (_currentTime + seconds)
            .clamp(0, _duration)
            .toDouble();
        final seekPosition = (position / _duration).clamp(0, 1).toDouble();
        positionNotifier.value = seekPosition;
        await controller.seekTo(seconds: position, allowSeekAhead: true);
      });
    }
  }

  Future<void> onPlayPause() async {
    if (_controller case final YoutubePlayerController controller) {
      await ErrorHandler.executeSafe(() async {
        playingNotifier.value
            ? await controller.pauseVideo()
            : await controller.playVideo();
        playingNotifier.value = !playingNotifier.value;
      });
    }
  }

  Future<void> pause() async {
    if (_controller case final YoutubePlayerController controller) {
      await ErrorHandler.executeSafe(() async {
        await controller.pauseVideo();
        playingNotifier.value = false;
      });
    }
  }

  Future<void> play() async {
    if (_controller case final YoutubePlayerController controller) {
      await ErrorHandler.executeSafe(() async {
        await controller.playVideo();
        playingNotifier.value = true;
      });
    }
  }

  Future<void> onMuteUnmute() async {
    if (_controller case final YoutubePlayerController controller) {
      await ErrorHandler.executeSafe(() async {
        if (muteNotifier.value) {
          await controller.unMute();
          // Volume
          volumeNotifier.value = 100;
          await controller.setVolume(100);
        } else {
          await controller.mute();
          // Volume
          volumeNotifier.value = 0;
          await controller.setVolume(0);
        }

        muteNotifier.value = !muteNotifier.value;
      });
    }
  }

  Future<void> onVolumeChanged(double value) async {
    if (_controller case final YoutubePlayerController controller) {
      await ErrorHandler.executeSafe(() async {
        final volume = value.round();
        volumeNotifier.value = volume;
        await controller.setVolume(volume);

        // Mute
        if (volume == 0) {
          await controller.mute();
          muteNotifier.value = true;
        } else {
          await controller.unMute();
          muteNotifier.value = false;
        }
      });
    }
  }

  Future<void> onVolumeUpDown(bool isVolumeUp) async {
    if (_controller != null) {
      await ErrorHandler.executeSafe(() async {
        var volumeChange = 10;
        if (!isVolumeUp) {
          volumeChange *= -1;
        }

        // Keeping the volume in the range of 0 to 100
        final volume = (volumeNotifier.value + volumeChange).clamp(0, 100);
        await onVolumeChanged(volume.toDouble());
      });
    }
  }

  Future<void> onPlaybackRateChanged(double playbackRate) async {
    if (_controller case final YoutubePlayerController controller) {
      await ErrorHandler.executeSafe(() async {
        playbackRateNotifier.value = playbackRate;
        await controller.setPlaybackRate(playbackRate);
      });
    }
  }

  void dispose() {
    _updateTimer?.cancel();
    playingNotifier.dispose();
    muteNotifier.dispose();
    volumeNotifier.dispose();
    playbackRateNotifier.dispose();
    positionNotifier.dispose();
    bufferedNotifier.dispose();
    _controller?.stopVideo();
    _controller?.close();
  }
}
