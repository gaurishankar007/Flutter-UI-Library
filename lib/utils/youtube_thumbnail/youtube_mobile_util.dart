import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubeUtil {
  static String getThumbnailUrl(String videoUrl) {
    try {
      final videoId = YoutubePlayer.convertUrlToId(videoUrl) ?? '';
      return YoutubePlayer.getThumbnail(videoId: videoId);
    } catch (_) {
      return '';
    }
  }

  static String getYouTubeVideoId(String videoUrl) {
    try {
      final videoId = YoutubePlayer.convertUrlToId(videoUrl) ?? '';
      return videoId;
    } catch (_) {
      return '';
    }
  }
}
