import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/rundown_entity.dart';
import 'timer_model.dart';

part 'rundown_model.g.dart';

@JsonSerializable()
class RundownModel extends RundownEntity {
  @JsonKey(name: 'timers')
  final List<TimerModel> timerModels;

  const RundownModel({
    required super.id,
    required super.name,
    super.description,
    required this.timerModels,
    super.currentTimerIndex,
    required super.createdAt,
    required super.updatedAt,
    super.autoAdvance,
    super.metadata,
  }) : super(timers: timerModels);

  factory RundownModel.fromJson(Map<String, dynamic> json) => _$RundownModelFromJson(json);
  Map<String, dynamic> toJson() => _$RundownModelToJson(this);

  factory RundownModel.fromEntity(RundownEntity entity) {
    return RundownModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      timerModels: entity.timers.map((timer) => TimerModel.fromEntity(timer)).toList(),
      currentTimerIndex: entity.currentTimerIndex,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      autoAdvance: entity.autoAdvance,
      metadata: entity.metadata,
    );
  }

  RundownEntity toEntity() {
    return RundownEntity(
      id: id,
      name: name,
      description: description,
      timers: timerModels.map((timer) => timer.toEntity()).toList(),
      currentTimerIndex: currentTimerIndex,
      createdAt: createdAt,
      updatedAt: updatedAt,
      autoAdvance: autoAdvance,
      metadata: metadata,
    );
  }
}