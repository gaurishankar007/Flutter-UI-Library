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
import 'package:ui_library/widgets/user_inputs/button/base_icon_button.dart';

class MediaZoomButton extends StatelessWidget {
  const MediaZoomButton({
    super.key,
    required this.onTap,
    required this.isExpanded,
  });

  final void Function() onTap;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return BaseIconButton(
      onPressed: onTap,
      icon: Icon(
        isExpanded ? Icons.zoom_in_map : Icons.zoom_out_map,
        size: 30,
        color: AppColors.white,
      ),
      padding: EdgeInsets.zero,
      disableSplash: true,
    );
  }
}
