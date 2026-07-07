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

class MediaDownloadButton extends StatelessWidget {
  const MediaDownloadButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseIconButton(
      onPressed: () {},
      icon: const Icon(
        Icons.file_download_outlined,
        size: 32,
        color: AppColors.white,
      ),
      padding: EdgeInsets.zero,
      disableSplash: true,
    );
  }
}
