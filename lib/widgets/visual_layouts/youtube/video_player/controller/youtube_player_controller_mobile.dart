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
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerControllerMobile {
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
    double? startAt,
  }) {
    return ErrorHandler.executeSafeReturnSync(() {
      final videoId = YoutubePlayer.convertUrlToId(videoUrl);
      if (videoId == null) {
        return null;
      }

      // Initialize the controller with the video Id
      playingNotifier.value = autoPlay;
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: YoutubePlayerFlags(
          autoPlay: autoPlay,
          loop: true,
          hideControls: true,
          enableCaption: false,
          startAt: startAt?.toInt() ?? 0,
        ),
      );

      return _controller;
    }, onError: (_, _) => null);
  }

  /// Updates the player media values periodically
  void listenControllerChanges({
    void Function(YoutubePlayerState state)? onStateChanged,
  }) {
    if (_controller case final YoutubePlayerController controller) {
      _updateTimer = Timer.periodic(const Duration(milliseconds: 250), (_) {
        ErrorHandler.executeSafeSync(() {
          bufferedNotifier.value = controller.value.buffered;
          _duration = controller.metadata.duration.inSeconds.toDouble();
          _currentTime = controller.value.position.inSeconds.toDouble();

          if (_duration != 0) {
            // A number between 0 and 1 that specifies the percentage of time elapsed.
            final elapsedValue = (_currentTime / _duration)
                .clamp(0, 1)
                .toDouble();
            positionNotifier.value = elapsedValue;
          }

          // Send the updated state
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
        controller.load(
          YoutubePlayer.convertUrlToId(videoUrl) ?? '',
          startAt: _currentTime.toInt(),
        );
      });
    }
  }

  /// Seeks the player to the given position
  Future<void> onPositionChanged(double value) async {
    if (_controller case final YoutubePlayerController controller) {
      await ErrorHandler.executeSafe(() async {
        final position = (value * _duration).toInt();
        controller.seekTo(Duration(seconds: position));

        // If video is paused and we need to play it again.
        if (!playingNotifier.value) {
          playingNotifier.value = true;
        }
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
        controller.seekTo(Duration(seconds: position.toInt()));

        // If video is paused and we need to play it again.
        if (!playingNotifier.value) {
          playingNotifier.value = true;
        }
      });
    }
  }

  Future<void> onPlayPause() async {
    if (_controller case final YoutubePlayerController controller) {
      await ErrorHandler.executeSafe(() async {
        playingNotifier.value ? controller.pause() : controller.play();
        playingNotifier.value = !playingNotifier.value;
      });
    }
  }

  Future<void> pause() async {
    if (_controller case final YoutubePlayerController controller) {
      await ErrorHandler.executeSafe(() async {
        controller.pause();
        playingNotifier.value = false;
      });
    }
  }

  Future<void> play() async {
    if (_controller case final YoutubePlayerController controller) {
      await ErrorHandler.executeSafe(() async {
        controller.play();
        playingNotifier.value = true;
      });
    }
  }

  Future<void> onAppResumed() async {
    await ErrorHandler.executeSafe(() async {
      if (playingNotifier.value) {
        _controller?.play();
      }
    });
  }

  Future<void> onMuteUnmute() async {
    if (_controller case final YoutubePlayerController controller) {
      await ErrorHandler.executeSafe(() async {
        if (muteNotifier.value) {
          controller.unMute();
          // Volume
          volumeNotifier.value = 100;
          controller.setVolume(100);
        } else {
          controller.mute();
          // Volume
          volumeNotifier.value = 0;
          controller.setVolume(0);
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
        controller.setVolume(volume);

        // Mute
        if (volume == 0) {
          controller.mute();
          muteNotifier.value = true;
        } else {
          controller.unMute();
          muteNotifier.value = false;
        }
      });
    }
  }

  Future<void> onPlaybackRateChanged(double playbackRate) async {
    if (_controller case final YoutubePlayerController controller) {
      await ErrorHandler.executeSafe(() async {
        playbackRateNotifier.value = playbackRate;
        controller.setPlaybackRate(playbackRate);
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
    _controller?.dispose();
  }
}
