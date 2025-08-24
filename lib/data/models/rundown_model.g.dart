// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rundown_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RundownModel _$RundownModelFromJson(Map<String, dynamic> json) => RundownModel(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String? ?? '',
  timerModels:
      (json['timers'] as List<dynamic>)
          .map((e) => TimerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
  currentTimerIndex: (json['currentTimerIndex'] as num?)?.toInt() ?? 0,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  autoAdvance: json['autoAdvance'] as bool? ?? false,
  metadata: json['metadata'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$RundownModelToJson(RundownModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'currentTimerIndex': instance.currentTimerIndex,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'autoAdvance': instance.autoAdvance,
      'metadata': instance.metadata,
      'timers': instance.timerModels,
    };
