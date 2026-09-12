import 'package:material_ui/material_ui.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/utils/extensions/duration_extension.dart';
import 'package:ui_library/widgets/visual_layouts/base_text.dart';

class VideoProgress extends StatelessWidget {
  const VideoProgress({
    super.key,
    required this.position,
    required this.duration,
  });

  final Duration position;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return BaseText.overline(
      '${position.formatDuration()} / ${duration.formatDuration()}',
      color: AppColors.white,
    );
  }
}
