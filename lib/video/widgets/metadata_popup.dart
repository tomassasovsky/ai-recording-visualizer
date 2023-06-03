import 'package:ai_recording_visualizer/l10n/l10n.dart';
import 'package:ai_recording_visualizer/logfile_processor/logfile_processor.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MetadataPopup extends StatelessWidget {
  const MetadataPopup({
    required this.inputSize,
    required this.sensorMetadata,
    this.startFrame,
    this.endFrame,
    this.startFrameCorrection,
    super.key,
  });

  Future<void> showAsDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => this,
    );
  }

  final int inputSize;
  final SensorMetadata sensorMetadata;
  final int? startFrame;
  final int? endFrame;
  final int? startFrameCorrection;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final sensorHorizontalFov =
        l10n.sensorMetadataHorizontalFov(sensorMetadata.horizontalFOV);
    final sensorVerticalFov =
        l10n.sensorMetadataVerticalFov(sensorMetadata.verticalFOV);
    final sensorSize = l10n.sensorMetadataSize(
      sensorMetadata.sensorWidth,
      sensorMetadata.sensorHeight,
    );
    final sensorFocalLength =
        l10n.sensorMetadataFocalLength(sensorMetadata.focalLength);

    DateTime? startFrame;
    if (this.startFrame != null) {
      startFrame = DateTime.fromMillisecondsSinceEpoch(this.startFrame!);
    }

    DateTime? endFrame;
    if (this.endFrame != null) {
      endFrame = DateTime.fromMillisecondsSinceEpoch(this.endFrame!);
    }

    final dateFormat = DateFormat().add_yMMMMd().addPattern('- hh:mm:ss:SSS a');

    return AlertDialog(
      title: Text(l10n.generalMetadata),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.modelSize(inputSize)),
          Text(l10n.sensorMetadata),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(sensorHorizontalFov),
                Text(sensorVerticalFov),
                Text(sensorSize),
                Text(sensorFocalLength),
              ],
            ),
          ),
          if (startFrame != null)
            Text(l10n.recordingTimestamp(dateFormat.format(startFrame))),
          if (endFrame != null)
            Text(l10n.recordingEndTimestamp(dateFormat.format(endFrame))),
          if (startFrameCorrection != null)
            Text(l10n.logFrameSyncCorrection(startFrameCorrection!)),
        ],
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: Text(l10n.close),
        ),
      ],
    );
  }
}
