import 'package:equatable/equatable.dart';
import '../../../domain/entities/timer_entity.dart';

abstract class TimerState extends Equatable {
  const TimerState();

  @override
  List<Object?> get props => [];
}

class TimerInitial extends TimerState {
  const TimerInitial();
}

class TimerLoading extends TimerState {
  const TimerLoading();
}

class TimerLoaded extends TimerState {
  final List<TimerEntity> timers;
  final bool isBlackoutMode;

  const TimerLoaded({
    required this.timers,
    this.isBlackoutMode = false,
  });

  @override
  List<Object?> get props => [timers, isBlackoutMode];

  TimerLoaded copyWith({
    List<TimerEntity>? timers,
    bool? isBlackoutMode,
  }) {
    return TimerLoaded(
      timers: timers ?? this.timers,
      isBlackoutMode: isBlackoutMode ?? this.isBlackoutMode,
    );
  }

  TimerEntity? getTimerById(String id) {
    try {
      return timers.firstWhere((timer) => timer.id == id);
    } catch (_) {
      return null;
    }
  }

  List<TimerEntity> get activeTimers {
    return timers.where((timer) => timer.isActive).toList();
  }

  List<TimerEntity> get pausedTimers {
    return timers.where((timer) => timer.isPaused).toList();
  }

  List<TimerEntity> get finishedTimers {
    return timers.where((timer) => timer.isFinished).toList();
  }

  List<TimerEntity> get countdownTimers {
    return timers.where((timer) => timer.type == TimerType.countdown).toList();
  }

  List<TimerEntity> get countUpTimers {
    return timers.where((timer) => timer.type == TimerType.countUp).toList();
  }

  List<TimerEntity> get clockTimers {
    return timers.where((timer) => timer.type == TimerType.clock).toList();
  }

  bool get hasActiveTimers => activeTimers.isNotEmpty;
  bool get hasAnyTimer => timers.isNotEmpty;
}

class TimerError extends TimerState {
  final String message;
  final List<TimerEntity>? timers;

  const TimerError({
    required this.message,
    this.timers,
  });

  @override
  List<Object?> get props => [message, timers];
}

class TimerOperationInProgress extends TimerState {
  final List<TimerEntity> timers;
  final String operation;
  final String? timerId;

  const TimerOperationInProgress({
    required this.timers,
    required this.operation,
    this.timerId,
  });

  @override
  List<Object?> get props => [timers, operation, timerId];
}

class TimerExported extends TimerState {
  final List<TimerEntity> timers;
  final String exportData;
  final String format;

  const TimerExported({
    required this.timers,
    required this.exportData,
    required this.format,
  });

  @override
  List<Object?> get props => [timers, exportData, format];
}

class TimersImported extends TimerState {
  final List<TimerEntity> timers;
  final List<TimerEntity> importedTimers;

  const TimersImported({
    required this.timers,
    required this.importedTimers,
  });

  @override
  List<Object?> get props => [timers, importedTimers];
}

class BlackoutModeToggled extends TimerState {
  final List<TimerEntity> timers;
  final bool isBlackoutMode;

  const BlackoutModeToggled({
    required this.timers,
    required this.isBlackoutMode,
  });

  @override
  List<Object?> get props => [timers, isBlackoutMode];
}