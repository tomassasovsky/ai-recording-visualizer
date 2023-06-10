import 'package:ai_recording_visualizer/l10n/l10n.dart';
import 'package:flutter/material.dart';

void showRemoteErrorDialog(
  BuildContext context, {
  required String errorMessage,
}) {
  final l10n = context.l10n;

  Future<void> hideBanner() async {
    await Future<void>.delayed(const Duration(seconds: 2));

    if (context.mounted) {
      ScaffoldMessenger.of(context).hideCurrentMaterialBanner(
        reason: MaterialBannerClosedReason.dismiss,
      );
    }
  }

  WidgetsBinding.instance.addPostFrameCallback((_) {
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        content: Text(
          errorMessage,
          style: const TextStyle(color: Colors.red),
        ),
        actions: [
          TextButton(
            onPressed: hideBanner,
            child: Text(l10n.close),
          ),
        ],
        onVisible: hideBanner,
        animation: AnimationController(
          vsync: ScaffoldMessenger.of(context),
          duration: const Duration(seconds: 2),
        ),
      ),
    );
  });
}
