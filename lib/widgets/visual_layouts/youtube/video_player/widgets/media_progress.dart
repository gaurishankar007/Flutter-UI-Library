// © 2026 vAIolin LLC. All rights reserved.
//
// This software and its associated materials are the intellectual
// property of vAIolin LLC. Unauthorized copying, modification,
// distribution, or use of this code, in whole or in part, without
// express written permission from vAIolin LLC is strictly prohibited.
//
// For licensing inquiries, contact: snehesh@vaiolin.ai

import 'package:flutter/material.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/utils/extensions/duration_extension.dart';
import 'package:ui_library/widgets/visual_layouts/base_text.dart';

class MediaProgress extends StatelessWidget {
  const MediaProgress({
    super.key,
    required this.position,
    required this.duration,
  });

  final Duration position;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        BaseText.button(
          position.formatDuration(),
          color: AppColors.white87,
        ),
        BaseText.body(
          ' / ${duration.formatDuration()}',
          color: AppColors.white60,
        ),
      ],
    );
  }
}
