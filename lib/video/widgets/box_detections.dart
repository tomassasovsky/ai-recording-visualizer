import 'package:ai_recording_visualizer/video/cubit/video_cubit.dart';
import 'package:ai_recording_visualizer/video/widgets/bounding_boxes_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BoxDetections extends StatelessWidget {
  const BoxDetections({super.key});

  static Color hoopColor = Colors.red;
  static Color ballColor = Colors.yellow;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoCubit, VideoState>(
      builder: (context, state) {
        final ballDetections = state.ballDetections;
        final hoopDetections = state.hoopDetections;

        final detections = {
          hoopColor: hoopDetections,
          ballColor: ballDetections,
        };

        return ValueListenableBuilder(
          valueListenable: context.read<VideoCubit>().controller.notifier,
          builder: (context, value, child) {
            final rect = value?.rect.value;
            if (rect == null) {
              return const SizedBox();
            }

            final aspectRatio = rect.width / rect.height;
            if (aspectRatio.isNaN || aspectRatio == 0) {
              return BoundingBoxesOverlay(detections);
            }

            return Center(
              child: AspectRatio(
                aspectRatio: aspectRatio,
                child: BoundingBoxesOverlay(detections),
              ),
            );
          },
        );
      },
    );
  }
}
