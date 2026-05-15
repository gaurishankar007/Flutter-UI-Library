import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YouTubeUtil {
  static String getThumbnailUrl(String videoUrl) {
    try {
      final videoId = YoutubePlayerController.convertUrlToId(videoUrl) ?? '';
      return YoutubePlayerController.getThumbnail(videoId: videoId);
    } catch (_) {
      return '';
    }
  }

  static String getYouTubeVideoId(String videoUrl) {
    try {
      final videoId = YoutubePlayerController.convertUrlToId(videoUrl) ?? '';
      return videoId;
    } catch (_) {
      return '';
    }
  }
}
