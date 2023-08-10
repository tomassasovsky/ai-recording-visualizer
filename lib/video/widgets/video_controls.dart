import 'dart:async';
import 'dart:math';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';

class Control extends StatefulWidget {
  const Control({
    required this.child,
    required this.player,
    this.progressBarActiveColor,
    this.progressBarInactiveColor = Colors.white24,
    this.progressBarThumbColor,
    this.progressBarThumbGlowColor = const Color.fromRGBO(0, 161, 214, .2),
    this.volumeActiveColor,
    this.volumeInactiveColor = Colors.grey,
    this.volumeBackgroundColor = const Color(0xff424242),
    this.volumeThumbColor,
    this.progressBarThumbRadius = 10.0,
    this.progressBarThumbGlowRadius = 15.0,
    this.showTimeLeft = false,
    this.progressBarTextStyle = const TextStyle(),
    super.key,
  });

  final Widget child;
  final Player player;
  final bool? showTimeLeft;
  final double? progressBarThumbRadius;
  final double? progressBarThumbGlowRadius;
  final Color? progressBarActiveColor;
  final Color? progressBarInactiveColor;
  final Color? progressBarThumbColor;
  final Color? progressBarThumbGlowColor;
  final TextStyle? progressBarTextStyle;
  final Color? volumeActiveColor;
  final Color? volumeInactiveColor;
  final Color? volumeBackgroundColor;
  final Color? volumeThumbColor;

  @override
  ControlState createState() => ControlState();
}

class ControlState extends State<Control> with SingleTickerProviderStateMixin {
  bool _hideControls = true;
  bool _displayTapped = false;
  Timer? _hideTimer;
  late StreamSubscription<bool> playingStreamSubscription;
  late AnimationController playPauseController;
  ValueNotifier<bool> showVolume = ValueNotifier(false);

  Player get player => widget.player;

  @override
  void initState() {
    super.initState();
    playPauseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    playingStreamSubscription = player.stream.playing.listen(setPlaybackMode);
    if (player.state.playing) playPauseController.forward();
  }

  @override
  void dispose() {
    playingStreamSubscription.cancel();
    playPauseController.dispose();
    super.dispose();
  }

  // ignore: avoid_positional_boolean_parameters
  void setPlaybackMode(bool isPlaying) {
    if (isPlaying) {
      playPauseController.forward();
    } else {
      playPauseController.reverse();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await player.playOrPause();
        if (player.state.playing) {
          if (_displayTapped) {
            setState(() {
              _hideControls = true;
              _displayTapped = false;
            });
          } else {
            _cancelAndRestartTimer();
          }
        } else {
          setState(() => _hideControls = true);
        }
      },
      child: RawKeyboardListener(
        autofocus: true,
        focusNode: FocusNode(),
        onKey: (value) async {
          _cancelAndRestartTimer();

          final currentPosition = player.state.position.inMilliseconds;
          final maxPosition = player.state.duration.inMilliseconds;

          if (value.repeat) return;
          if (value is RawKeyUpEvent) return;

          if (value.logicalKey == LogicalKeyboardKey.space) {
            await player.playOrPause();
          } else if (value.logicalKey == LogicalKeyboardKey.arrowLeft) {
            final seekLeft = min(
              currentPosition,
              10000,
            );

            final targetPosition =
                player.state.position.inMilliseconds - seekLeft;

            await player.seek(
              Duration(milliseconds: targetPosition),
            );
          } else if (value.logicalKey == LogicalKeyboardKey.arrowRight) {
            final seekRight = min(
              maxPosition - currentPosition,
              10000,
            );

            final targetPosition =
                player.state.position.inMilliseconds + seekRight;

            await player.seek(
              Duration(milliseconds: targetPosition),
            );
          } else if (value.logicalKey == LogicalKeyboardKey.arrowUp) {
            final volume = min(player.state.volume + 10, 100);
            showVolume.value = true;
            await player.setVolume(volume.toDouble());
          } else if (value.logicalKey == LogicalKeyboardKey.arrowDown) {
            final volume = max(player.state.volume - 10, 0);
            showVolume.value = true;
            await player.setVolume(volume.toDouble());
          }
        },
        child: MouseRegion(
          onHover: (_) => _cancelAndRestartTimer(),
          child: AbsorbPointer(
            absorbing: _hideControls,
            child: Stack(
              children: [
                widget.child,
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _hideControls ? 0.0 : 1.0,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            bottom: 60,
                            right: 20,
                            left: 20,
                          ),
                          child: StreamBuilder<Duration>(
                            stream: player.stream.duration,
                            builder: (
                              BuildContext context,
                              AsyncSnapshot<Duration> snapshot,
                            ) {
                              final total = snapshot.data ?? Duration.zero;
                              return StreamBuilder<Duration>(
                                stream: player.stream.position,
                                builder: (context, snapshot) {
                                  final progress =
                                      snapshot.data ?? Duration.zero;
                                  return Theme(
                                    data: ThemeData.dark(),
                                    child: ProgressBar(
                                      progress: progress,
                                      total: total,
                                      barHeight: 3,
                                      progressBarColor:
                                          widget.progressBarActiveColor,
                                      thumbColor: widget.progressBarThumbColor,
                                      baseBarColor:
                                          widget.progressBarInactiveColor,
                                      thumbGlowColor:
                                          widget.progressBarThumbGlowColor,
                                      thumbRadius:
                                          widget.progressBarThumbRadius ?? 10.0,
                                      thumbGlowRadius:
                                          widget.progressBarThumbGlowRadius ??
                                              30.0,
                                      timeLabelLocation:
                                          TimeLabelLocation.sides,
                                      timeLabelType: widget.showTimeLeft!
                                          ? TimeLabelType.remainingTime
                                          : TimeLabelType.totalTime,
                                      timeLabelTextStyle:
                                          widget.progressBarTextStyle,
                                      onSeek: (duration) {
                                        player.seek(duration);
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      StreamBuilder<Playlist>(
                        stream: widget.player.stream.playlist,
                        builder: (context, snapshot) {
                          return Positioned(
                            left: 0,
                            right: 0,
                            bottom: 10,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if ((snapshot.data?.index ?? 0) > 1)
                                  IconButton(
                                    color: Colors.white,
                                    iconSize: 30,
                                    icon: const Icon(Icons.skip_previous),
                                    onPressed: () => player.previous(),
                                  ),
                                const SizedBox(width: 50),
                                IconButton(
                                  color: Colors.white,
                                  iconSize: 30,
                                  icon: const Icon(Icons.replay_10),
                                  onPressed: () async {
                                    final seekLeft = min(
                                      player.state.position.inMilliseconds,
                                      10000,
                                    );

                                    final targetPosition =
                                        player.state.position.inMilliseconds -
                                            seekLeft;

                                    await player.seek(
                                      Duration(milliseconds: targetPosition),
                                    );
                                  },
                                ),
                                const SizedBox(width: 20),
                                IconButton(
                                  color: Colors.white,
                                  iconSize: 30,
                                  icon: AnimatedIcon(
                                    icon: AnimatedIcons.play_pause,
                                    progress: playPauseController,
                                  ),
                                  onPressed: () {
                                    if (player.state.playing) {
                                      player.pause();
                                      playPauseController.reverse();
                                    } else {
                                      player.play();
                                      playPauseController.forward();
                                    }
                                  },
                                ),
                                const SizedBox(width: 20),
                                IconButton(
                                  color: Colors.white,
                                  iconSize: 30,
                                  icon: const Icon(Icons.forward_10),
                                  onPressed: () async {
                                    final currentPosition =
                                        player.state.position.inMilliseconds;
                                    final maxPosition =
                                        player.state.duration.inMilliseconds;
                                    final seekRight = min(
                                      maxPosition - currentPosition,
                                      10000,
                                    );

                                    final targetPosition =
                                        player.state.position.inMilliseconds +
                                            seekRight;

                                    await player.seek(
                                      Duration(milliseconds: targetPosition),
                                    );
                                  },
                                ),
                                const SizedBox(width: 50),
                                if ((snapshot.data?.medias.length ?? 0) > 1)
                                  IconButton(
                                    color: Colors.white,
                                    iconSize: 30,
                                    icon: const Icon(Icons.skip_next),
                                    onPressed: () => player.next(),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                      Positioned(
                        right: 15,
                        bottom: 12.5,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            VolumeControl(
                              player: player,
                              showVolume: showVolume,
                              thumbColor: widget.volumeThumbColor,
                              inactiveColor: widget.volumeInactiveColor,
                              activeColor: widget.volumeActiveColor,
                              backgroundColor: widget.volumeBackgroundColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _cancelAndRestartTimer() {
    _hideTimer?.cancel();

    if (mounted) {
      _startHideTimer();

      setState(() {
        _hideControls = false;
        _displayTapped = true;
      });
    }
  }

  void _startHideTimer() {
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _hideControls = true;
          showVolume.value = false;
          _displayTapped = false;
        });
      }
    });
  }
}

class VolumeControl extends StatefulWidget {
  const VolumeControl({
    required this.player,
    required this.activeColor,
    required this.inactiveColor,
    required this.backgroundColor,
    required this.thumbColor,
    required this.showVolume,
    super.key,
  });

  final Player player;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? backgroundColor;
  final Color? thumbColor;
  final ValueNotifier<bool> showVolume;

  @override
  VolumeControlState createState() => VolumeControlState();
}

class VolumeControlState extends State<VolumeControl> {
  double volume = 100;
  double unmutedVolume = 100;

  Player get player => widget.player;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder(
          valueListenable: widget.showVolume,
          builder: (context, value, child) {
            return AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              opacity: value ? 1 : 0,
              child: AbsorbPointer(
                absorbing: !value,
                child: MouseRegion(
                  onEnter: (_) {
                    setState(() => widget.showVolume.value = true);
                  },
                  onExit: (_) {
                    setState(() => widget.showVolume.value = false);
                  },
                  child: SizedBox(
                    width: 60,
                    height: 250,
                    child: Card(
                      color: widget.backgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: RotatedBox(
                        quarterTurns: -1,
                        child: SliderTheme(
                          data: SliderThemeData(
                            activeTrackColor: widget.activeColor,
                            inactiveTrackColor: widget.inactiveColor,
                            thumbColor: widget.thumbColor,
                          ),
                          child: Slider(
                            value: player.state.volume,
                            max: 100,
                            onChanged: (volume) {
                              player.setVolume(volume);
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        MouseRegion(
          onEnter: (_) {
            setState(() => widget.showVolume.value = true);
          },
          onExit: (_) {
            setState(() => widget.showVolume.value = false);
          },
          child: IconButton(
            color: Colors.white,
            onPressed: muteUnmute,
            icon: Icon(getIcon()),
          ),
        ),
      ],
    );
  }

  IconData getIcon() {
    if (player.state.volume > .5) {
      return Icons.volume_up_sharp;
    } else if (player.state.volume > 0) {
      return Icons.volume_down_sharp;
    } else {
      return Icons.volume_off_sharp;
    }
  }

  void muteUnmute() {
    if (player.state.volume > 0) {
      unmutedVolume = player.state.volume;
      player.setVolume(0);
    } else {
      player.setVolume(unmutedVolume);
    }
    setState(() {});
  }
}
