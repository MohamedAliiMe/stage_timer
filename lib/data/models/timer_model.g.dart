// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimerModel _$TimerModelFromJson(Map<String, dynamic> json) => TimerModel(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String? ?? '',
  type: $enumDecode(_$TimerTypeEnumMap, json['type']),
  state:
      $enumDecodeNullable(_$TimerStatusEnumMap, json['state']) ??
      TimerStatus.stopped,
  duration: (json['duration'] as num).toInt(),
  remainingTime: (json['remainingTime'] as num?)?.toInt(),
  startTime:
      json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
  endTime:
      json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
  scheduledStartTime:
      json['scheduledStartTime'] == null
          ? null
          : DateTime.parse(json['scheduledStartTime'] as String),
  linkType:
      $enumDecodeNullable(_$TimerLinkTypeEnumMap, json['linkType']) ??
      TimerLinkType.manual,
  nextTimerId: json['nextTimerId'] as String?,
  customColor: TimerModel._colorFromJson(
    (json['customColor'] as num?)?.toInt(),
  ),
  isWrapUp: json['isWrapUp'] as bool? ?? false,
  wrapUpThreshold: (json['wrapUpThreshold'] as num?)?.toInt() ?? 60,
  enableChime: json['enableChime'] as bool? ?? false,
  chimeSound: json['chimeSound'] as String?,
  is24HourFormat: json['is24HourFormat'] as bool? ?? true,
  customProperties: json['customProperties'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$TimerModelToJson(TimerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'type': _$TimerTypeEnumMap[instance.type]!,
      'state': _$TimerStatusEnumMap[instance.state]!,
      'duration': instance.duration,
      'remainingTime': instance.remainingTime,
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'scheduledStartTime': instance.scheduledStartTime?.toIso8601String(),
      'linkType': _$TimerLinkTypeEnumMap[instance.linkType]!,
      'nextTimerId': instance.nextTimerId,
      'isWrapUp': instance.isWrapUp,
      'wrapUpThreshold': instance.wrapUpThreshold,
      'enableChime': instance.enableChime,
      'chimeSound': instance.chimeSound,
      'is24HourFormat': instance.is24HourFormat,
      'customProperties': instance.customProperties,
      'customColor': TimerModel._colorToJson(instance.customColor),
    };

const _$TimerTypeEnumMap = {
  TimerType.countdown: 'countdown',
  TimerType.countUp: 'countUp',
  TimerType.clock: 'clock',
};

const _$TimerStatusEnumMap = {
  TimerStatus.stopped: 'stopped',
  TimerStatus.running: 'running',
  TimerStatus.paused: 'paused',
  TimerStatus.finished: 'finished',
};

const _$TimerLinkTypeEnumMap = {
  TimerLinkType.manual: 'manual',
  TimerLinkType.automatic: 'automatic',
  TimerLinkType.scheduled: 'scheduled',
};
