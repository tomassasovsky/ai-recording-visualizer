import 'package:ai_recording_visualizer/video/video.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ZoomAdjustmentWidget extends StatefulWidget {
  const ZoomAdjustmentWidget({super.key});

  @override
  State<ZoomAdjustmentWidget> createState() => _ZoomAdjustmentWidgetState();
}

class _ZoomAdjustmentWidgetState extends State<ZoomAdjustmentWidget> {
  double latestZoomAdjustment = 1;
  bool hasChanged = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoCubit, VideoState>(
      buildWhen: (previous, current) =>
          previous.zoomAdjustment != current.zoomAdjustment,
      builder: (context, state) {
        final zoomAdjustmentUpdate = state.zoomAdjustment;
        if (!hasChanged) {
          if (zoomAdjustmentUpdate == null) {
            return const SizedBox();
          }

          hasChanged = true;
          latestZoomAdjustment = zoomAdjustmentUpdate;
        }

        latestZoomAdjustment = zoomAdjustmentUpdate ?? latestZoomAdjustment;
        final zoomString = latestZoomAdjustment.toStringAsFixed(2);

        return FadeOut(
          delay: const Duration(milliseconds: 800),
          child: Align(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 50),
              height: (120 * latestZoomAdjustment).clamp(65, 200),
              width: (120 * latestZoomAdjustment).clamp(65, 200),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: Text(
                '${zoomString}x',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 25,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
