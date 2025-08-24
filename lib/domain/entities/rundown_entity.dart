import 'package:equatable/equatable.dart';
import 'timer_entity.dart';

class RundownEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<TimerEntity> timers;
  final int currentTimerIndex;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool autoAdvance;
  final Map<String, dynamic>? metadata;

  const RundownEntity({
    required this.id,
    required this.name,
    this.description = '',
    required this.timers,
    this.currentTimerIndex = 0,
    required this.createdAt,
    required this.updatedAt,
    this.autoAdvance = false,
    this.metadata,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        timers,
        currentTimerIndex,
        createdAt,
        updatedAt,
        autoAdvance,
        metadata,
      ];

  RundownEntity copyWith({
    String? id,
    String? name,
    String? description,
    List<TimerEntity>? timers,
    int? currentTimerIndex,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? autoAdvance,
    Map<String, dynamic>? metadata,
  }) {
    return RundownEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      timers: timers ?? this.timers,
      currentTimerIndex: currentTimerIndex ?? this.currentTimerIndex,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      autoAdvance: autoAdvance ?? this.autoAdvance,
      metadata: metadata ?? this.metadata,
    );
  }

  TimerEntity? get currentTimer {
    if (currentTimerIndex >= 0 && currentTimerIndex < timers.length) {
      return timers[currentTimerIndex];
    }
    return null;
  }

  TimerEntity? get nextTimer {
    final nextIndex = currentTimerIndex + 1;
    if (nextIndex < timers.length) {
      return timers[nextIndex];
    }
    return null;
  }

  bool get hasNextTimer => nextTimer != null;
  bool get hasPreviousTimer => currentTimerIndex > 0;
  bool get isLastTimer => currentTimerIndex == timers.length - 1;
  bool get isFirstTimer => currentTimerIndex == 0;

  int get totalDuration {
    return timers.fold(0, (total, timer) => total + timer.duration);
  }

  int get completedDuration {
    int completed = 0;
    for (int i = 0; i < currentTimerIndex; i++) {
      completed += timers[i].duration;
    }
    if (currentTimer != null) {
      if (currentTimer!.type == TimerType.countdown) {
        completed += currentTimer!.duration - currentTimer!.remainingTime;
      } else if (currentTimer!.type == TimerType.countUp) {
        completed += currentTimer!.remainingTime;
      }
    }
    return completed;
  }

  double get overallProgress {
    if (totalDuration == 0) return 0;
    return completedDuration / totalDuration;
  }

  RundownEntity updateTimer(int index, TimerEntity updatedTimer) {
    if (index < 0 || index >= timers.length) return this;
    
    final updatedTimers = List<TimerEntity>.from(timers);
    updatedTimers[index] = updatedTimer;
    
    return copyWith(
      timers: updatedTimers,
      updatedAt: DateTime.now(),
    );
  }

  RundownEntity addTimer(TimerEntity timer, {int? atIndex}) {
    final updatedTimers = List<TimerEntity>.from(timers);
    if (atIndex != null && atIndex >= 0 && atIndex <= timers.length) {
      updatedTimers.insert(atIndex, timer);
    } else {
      updatedTimers.add(timer);
    }
    
    return copyWith(
      timers: updatedTimers,
      updatedAt: DateTime.now(),
    );
  }

  RundownEntity removeTimer(int index) {
    if (index < 0 || index >= timers.length) return this;
    
    final updatedTimers = List<TimerEntity>.from(timers);
    updatedTimers.removeAt(index);
    
    int newCurrentIndex = currentTimerIndex;
    if (index <= currentTimerIndex && currentTimerIndex > 0) {
      newCurrentIndex--;
    } else if (index == currentTimerIndex && currentTimerIndex >= updatedTimers.length) {
      newCurrentIndex = updatedTimers.length - 1;
    }
    
    return copyWith(
      timers: updatedTimers,
      currentTimerIndex: newCurrentIndex >= 0 ? newCurrentIndex : 0,
      updatedAt: DateTime.now(),
    );
  }

  RundownEntity moveTimer(int fromIndex, int toIndex) {
    if (fromIndex < 0 || fromIndex >= timers.length ||
        toIndex < 0 || toIndex >= timers.length ||
        fromIndex == toIndex) {
      return this;
    }
    
    final updatedTimers = List<TimerEntity>.from(timers);
    final timer = updatedTimers.removeAt(fromIndex);
    updatedTimers.insert(toIndex, timer);
    
    int newCurrentIndex = currentTimerIndex;
    if (fromIndex == currentTimerIndex) {
      newCurrentIndex = toIndex;
    } else if (fromIndex < currentTimerIndex && toIndex >= currentTimerIndex) {
      newCurrentIndex--;
    } else if (fromIndex > currentTimerIndex && toIndex <= currentTimerIndex) {
      newCurrentIndex++;
    }
    
    return copyWith(
      timers: updatedTimers,
      currentTimerIndex: newCurrentIndex,
      updatedAt: DateTime.now(),
    );
  }
}