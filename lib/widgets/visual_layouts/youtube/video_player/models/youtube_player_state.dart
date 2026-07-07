// © 2026 vAIolin LLC. All rights reserved.
//
// This software and its associated materials are the intellectual
// property of vAIolin LLC. Unauthorized copying, modification,
// distribution, or use of this code, in whole or in part, without
// express written permission from vAIolin LLC is strictly prohibited.
//
// For licensing inquiries, contact: snehesh@vaiolin.ai

class YoutubePlayerState {
  const YoutubePlayerState({
    required this.duration,
    required this.currentPosition,
    required this.bufferedPosition,
    required this.isPlaying,
    required this.volume,
    required this.playbackRate,
    required this.isMuted,
  });

  const YoutubePlayerState.empty()
    : duration = 0,
      currentPosition = 0,
      bufferedPosition = 0,
      isPlaying = false,
      volume = 100,
      playbackRate = 1.0,
      isMuted = false;

  /// Total seconds of the video
  final double duration;

  /// Seconds of the video
  final double currentPosition;

  /// Seconds of the video
  final double bufferedPosition;

  /// True if the video is playing
  final bool isPlaying;

  /// Volume of the video (0-100)
  final int volume;

  /// Speed of the video
  final double playbackRate;

  /// True if the video is muted
  final bool isMuted;

  YoutubePlayerState copyWith({
    double? duration,
    double? currentPosition,
    double? bufferedPosition,
    bool? isPlaying,
    int? volume,
    double? playbackRate,
    bool? isMuted,
  }) {
    return YoutubePlayerState(
      duration: duration ?? this.duration,
      currentPosition: currentPosition ?? this.currentPosition,
      bufferedPosition: bufferedPosition ?? this.bufferedPosition,
      isPlaying: isPlaying ?? this.isPlaying,
      volume: volume ?? this.volume,
      playbackRate: playbackRate ?? this.playbackRate,
      isMuted: isMuted ?? this.isMuted,
    );
  }
}
