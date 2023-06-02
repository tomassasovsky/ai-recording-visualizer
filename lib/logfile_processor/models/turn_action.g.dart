// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'turn_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TurnAction _$TurnActionFromJson(Map<String, dynamic> json) => TurnAction(
      (json['startPoint'] as num).toDouble(),
      (json['angle'] as num).toDouble(),
      (json['speed'] as num).toDouble(),
      Direction.fromJson(json['direction'] as String),
      json['timestamp'] as int,
    );
