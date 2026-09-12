// © 2026 vAIolin LLC. All rights reserved.
//
// This software and its associated materials are the intellectual
// property of vAIolin LLC. Unauthorized copying, modification,
// distribution, or use of this code, in whole or in part, without
// express written permission from vAIolin LLC is strictly prohibited.
//
// For licensing inquiries, contact: snehesh@vaiolin.ai

import 'package:material_ui/material_ui.dart';
import 'package:ui_library/core/constants/app_colors.dart';

class MediaReplayButton extends StatelessWidget {
  const MediaReplayButton({
    super.key,
    required this.onTap,
    required this.isReplay,
    required this.size,
  });

  final void Function() onTap;
  final bool isReplay;
  final double size;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      splashFactory: NoSplash.splashFactory,
      child: Center(
        child: Icon(
          isReplay ? Icons.replay_5_sharp : Icons.forward_5_sharp,
          size: size,
          color: AppColors.white,
        ),
      ),
    );
  }
}
