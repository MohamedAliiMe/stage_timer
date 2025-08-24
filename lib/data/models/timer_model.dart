import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/timer_entity.dart';

part 'timer_model.g.dart';

@JsonSerializable()
class TimerModel extends TimerEntity {
  @override
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  final Color? customColor;

  const TimerModel({
    required super.id,
    required super.name,
    super.description,
    required super.type,
    super.state,
    required super.duration,
    super.remainingTime,
    super.startTime,
    super.endTime,
    super.scheduledStartTime,
    super.linkType,
    super.nextTimerId,
    this.customColor,
    super.isWrapUp,
    super.wrapUpThreshold,
    super.enableChime,
    super.chimeSound,
    super.is24HourFormat,
    super.customProperties,
  }) : super(customColor: customColor);

  factory TimerModel.fromJson(Map<String, dynamic> json) => _$TimerModelFromJson(json);
  Map<String, dynamic> toJson() => _$TimerModelToJson(this);

  factory TimerModel.fromEntity(TimerEntity entity) {
    return TimerModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      type: entity.type,
      state: entity.state,
      duration: entity.duration,
      remainingTime: entity.remainingTime,
      startTime: entity.startTime,
      endTime: entity.endTime,
      scheduledStartTime: entity.scheduledStartTime,
      linkType: entity.linkType,
      nextTimerId: entity.nextTimerId,
      customColor: entity.customColor,
      isWrapUp: entity.isWrapUp,
      wrapUpThreshold: entity.wrapUpThreshold,
      enableChime: entity.enableChime,
      chimeSound: entity.chimeSound,
      is24HourFormat: entity.is24HourFormat,
      customProperties: entity.customProperties,
    );
  }

  TimerEntity toEntity() {
    return TimerEntity(
      id: id,
      name: name,
      description: description,
      type: type,
      state: state,
      duration: duration,
      remainingTime: remainingTime,
      startTime: startTime,
      endTime: endTime,
      scheduledStartTime: scheduledStartTime,
      linkType: linkType,
      nextTimerId: nextTimerId,
      customColor: customColor,
      isWrapUp: isWrapUp,
      wrapUpThreshold: wrapUpThreshold,
      enableChime: enableChime,
      chimeSound: chimeSound,
      is24HourFormat: is24HourFormat,
      customProperties: customProperties,
    );
  }

  static Color? _colorFromJson(int? json) {
    return json != null ? Color(json) : null;
  }

  static int? _colorToJson(Color? color) {
    return color?.value;
  }
}