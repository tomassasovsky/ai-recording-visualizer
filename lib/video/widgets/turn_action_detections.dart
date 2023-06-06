import 'package:ai_recording_visualizer/logfile_processor/logfile_processor.dart';
import 'package:ai_recording_visualizer/video/video.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TurnActionWidget extends StatefulWidget {
  const TurnActionWidget({super.key});

  @override
  State<TurnActionWidget> createState() => _TurnActionWidgetState();
}

class _TurnActionWidgetState extends State<TurnActionWidget> {
  TurnAction latestTurnAction = TurnAction.empty();
  bool hasChanged = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoCubit, VideoState>(
      buildWhen: (previous, current) =>
          previous.turnAction != current.turnAction,
      builder: (context, state) {
        final turnActionUpdate = state.turnAction;
        if (!hasChanged) {
          if (turnActionUpdate == null) {
            return const SizedBox();
          }

          hasChanged = true;
          latestTurnAction = turnActionUpdate;
        }

        latestTurnAction = turnActionUpdate ?? latestTurnAction;

        final isRight = latestTurnAction.direction == Direction.right;
        final angle = formatDouble(latestTurnAction.angle);
        final speed = formatDouble(latestTurnAction.speed);
        final startPoint = formatDouble(latestTurnAction.startPoint);
        final target = formatDouble(latestTurnAction.target);

        return FadeOut(
          delay: const Duration(milliseconds: 800),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(bottom: 85),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isRight ? Icons.turn_right : Icons.turn_left,
                    color: Colors.white,
                    size: 120,
                  ),
                  Text(
                    '$startPoint° ➔ $target°',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 27,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 3),
                    width: 150,
                    height: 1.5,
                    color: Colors.white.withOpacity(0.5),
                  ),
                  Text(
                    '${isRight ? '+' : '-'}$angle°   ${speed}s/r',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 27,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String formatDouble(double value) {
    /// If the value is integer, return it as integer
    if (value % 1 == 0) {
      return value.toInt().toString();
    }

    /// If the value is double, return it as double with 2 decimal places
    return value.toStringAsFixed(2);
  }
}
