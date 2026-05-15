import 'dart:async' show Timer;

import 'package:flutter/foundation.dart' show ValueNotifier;
import 'package:ui_library/core/error_handler.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeMobileMediaController {
  YoutubePlayerController? _controller;
  Timer? _updateTimer;

  final playingNotifier = ValueNotifier<bool>(true);
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

  void close() {
    _updateTimer?.cancel();
    playingNotifier.dispose();
    volumeNotifier.dispose();
    playbackRateNotifier.dispose();
    positionNotifier.dispose();
    bufferedNotifier.dispose();
    _controller?.dispose();
  }

  YoutubePlayerController? initializeController(String videoUrl) {
    return ErrorHandler.executeSafeReturnSync(() {
      final videoId = YoutubePlayer.convertUrlToId(videoUrl);
      if (videoId == null) {
        return null;
      }

      // Initialize the controller with the video Id
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          loop: true,
          hideControls: true,
          enableCaption: false,
        ),
      );

      return _controller;
    }, valueOnError: null);
  }

  /// Updates the player media values periodically
  void listenControllerChanges() {
    if (_controller != null) {
      _updateTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
        ErrorHandler.executeSafeSync(() {
          _duration = _controller!.metadata.duration.inSeconds.toDouble();
          bufferedNotifier.value = _controller!.value.buffered;
          _currentTime = _controller!.value.position.inSeconds.toDouble();
          playingNotifier.value = _controller!.value.isPlaying;
          muteNotifier.value = _controller!.value.volume == 0;
          volumeNotifier.value = _controller!.value.volume;
          playbackRateNotifier.value = _controller!.value.playbackRate;

          if (playingNotifier.value) {
            _updatePosition();
          }
        });
      });
    }
  }

  /// Updates elapsed time
  void _updatePosition() {
    if (_duration != 0) {
      // A number between 0 and 1 that specifies the percentage of time elapsed.
      final elapsedValue = (_currentTime / _duration).clamp(0, 1).toDouble();
      positionNotifier.value = elapsedValue;
    }
  }

  /// Replace the video with new one and keep the previous position
  Future<void> loadNewVideo(String videoUrl) async {
    await ErrorHandler.executeSafe(() async {
      final videoId = YoutubePlayer.convertUrlToId(videoUrl);
      if (_controller != null && videoId != null) {
        if (playingNotifier.value) {
          _controller!.load(videoId, startAt: _currentTime.toInt());
        } else {
          _controller!.cue(videoId, startAt: _currentTime.toInt());
        }
      }
    });
  }

  /// Seeks the player to the given position
  Future<void> onPositionChanged(double value) async {
    if (_controller != null) {
      await ErrorHandler.executeSafe(() async {
        // Update slider value
        positionNotifier.value = value;
        // Seek to the new position in YouTube Player
        final position = (value * _duration).toInt();
        _controller!.seekTo(Duration(seconds: position));
      });
    }
  }

  // Seek to 5 seconds backward or  forward
  Future<void> onReplayForward(bool isReplay) async {
    if (_controller != null) {
      await ErrorHandler.executeSafe(() async {
        var seconds = 5;
        if (isReplay) {
          seconds *= -1;
        }

        // Keeping the position in the range of the duration
        final position = (_currentTime + seconds)
            .clamp(0, _duration)
            .toDouble();

        _controller!.seekTo(Duration(seconds: position.toInt()));
      });
    }
  }

  Future<void> onPlayPause() async {
    if (_controller != null) {
      await ErrorHandler.executeSafe(() async {
        if (_controller!.value.isPlaying) {
          _controller!.pause();
        } else {
          _controller!.play();
        }
      });
    }
  }

  Future<void> onAppResumed() async {
    await ErrorHandler.executeSafe(() async {
      if (playingNotifier.value) {
        _controller!.play();
      }
    });
  }

  Future<void> onMuteUnmute() async {
    if (_controller != null) {
      await ErrorHandler.executeSafe(() async {
        if (_controller!.value.volume == 0) {
          _controller!.unMute();
        } else {
          _controller!.mute();
        }
      });
    }
  }

  Future<void> onVolumeChanged(double value) async {
    if (_controller != null) {
      await ErrorHandler.executeSafe(() async {
        final volume = value.round();
        _controller!.setVolume(volume);
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
        _controller!.setVolume(volume);
      });
    }
  }

  Future<void> onPlaybackRateChanged(double playbackRate) async {
    if (_controller != null) {
      await ErrorHandler.executeSafe(() async {
        _controller!.setPlaybackRate(playbackRate);
      });
    }
  }
}
