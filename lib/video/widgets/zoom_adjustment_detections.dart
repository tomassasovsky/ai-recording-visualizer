import 'package:ai_recording_visualizer/video/cubit/video_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ZoomAdjustmentDetections extends StatelessWidget {
  const ZoomAdjustmentDetections({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoCubit, VideoState>(
      builder: (context, state) {
        final zoomAdjustment = state.zoomAdjustment;

        if (zoomAdjustment == null) {
          return const SizedBox();
        }

        final zoomString = zoomAdjustment.toStringAsFixed(2);

        return Align(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 50),
            height: (120 * zoomAdjustment).clamp(65, 200),
            width: (120 * zoomAdjustment).clamp(65, 200),
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
        );
      },
    );
  }
}
