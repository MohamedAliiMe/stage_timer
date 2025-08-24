import 'package:equatable/equatable.dart';
import '../../../domain/entities/timer_entity.dart';

abstract class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object?> get props => [];
}

class TimerLoadRequested extends TimerEvent {
  const TimerLoadRequested();
}

class TimerCreated extends TimerEvent {
  final TimerEntity timer;

  const TimerCreated(this.timer);

  @override
  List<Object?> get props => [timer];
}

class TimerUpdated extends TimerEvent {
  final TimerEntity timer;

  const TimerUpdated(this.timer);

  @override
  List<Object?> get props => [timer];
}

class TimerDeleted extends TimerEvent {
  final String timerId;

  const TimerDeleted(this.timerId);

  @override
  List<Object?> get props => [timerId];
}

class TimerStarted extends TimerEvent {
  final String timerId;

  const TimerStarted(this.timerId);

  @override
  List<Object?> get props => [timerId];
}

class TimerPaused extends TimerEvent {
  final String timerId;

  const TimerPaused(this.timerId);

  @override
  List<Object?> get props => [timerId];
}

class TimerStopped extends TimerEvent {
  final String timerId;

  const TimerStopped(this.timerId);

  @override
  List<Object?> get props => [timerId];
}

class TimerReset extends TimerEvent {
  final String timerId;

  const TimerReset(this.timerId);

  @override
  List<Object?> get props => [timerId];
}

class TimerAdjusted extends TimerEvent {
  final String timerId;
  final int seconds;

  const TimerAdjusted(this.timerId, this.seconds);

  @override
  List<Object?> get props => [timerId, seconds];
}

class TimerTicked extends TimerEvent {
  final List<TimerEntity> updatedTimers;

  const TimerTicked(this.updatedTimers);

  @override
  List<Object?> get props => [updatedTimers];
}

class BulkTimersStarted extends TimerEvent {
  const BulkTimersStarted();
}

class BulkTimersStopped extends TimerEvent {
  const BulkTimersStopped();
}

class BulkTimersReset extends TimerEvent {
  const BulkTimersReset();
}

class BulkTimersDeleted extends TimerEvent {
  const BulkTimersDeleted();
}

class TimersImportedFromCsv extends TimerEvent {
  final String csvData;

  const TimersImportedFromCsv(this.csvData);

  @override
  List<Object?> get props => [csvData];
}

class TimersExported extends TimerEvent {
  final String format;

  const TimersExported(this.format);

  @override
  List<Object?> get props => [format];
}