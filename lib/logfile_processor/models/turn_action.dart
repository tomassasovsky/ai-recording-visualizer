import 'package:json_annotation/json_annotation.dart';

part 'turn_action.g.dart';

@JsonSerializable(createToJson: false)
class TurnAction {
  TurnAction(
    this.startPoint,
    this.angle,
    this.speed,
    this.direction,
  );

  factory TurnAction.fromJson(Map<String, dynamic> json) =>
      _$TurnActionFromJson(json);

  final double startPoint;
  final double angle;
  final double speed;
  @JsonKey(fromJson: Direction.fromJson)
  final Direction direction;
}

enum Direction {
  left,
  right;

  static Direction fromJson(String direction) {
    switch (direction.toLowerCase()) {
      case 'left':
        return Direction.left;
      case 'right':
        return Direction.right;
      default:
        throw ArgumentError.value(direction, 'direction');
    }
  }
}