import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/timer_repository.dart';
import '../../../domain/entities/timer_entity.dart';
import 'timer_event.dart';
import 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final TimerRepository _timerRepository;
  StreamSubscription<List<TimerEntity>>? _timersSubscription;
  bool _isBlackoutMode = false;

  TimerBloc({required TimerRepository timerRepository})
      : _timerRepository = timerRepository,
        super(const TimerInitial()) {
    on<TimerLoadRequested>(_onTimerLoadRequested);
    on<TimerCreated>(_onTimerCreated);
    on<TimerUpdated>(_onTimerUpdated);
    on<TimerDeleted>(_onTimerDeleted);
    on<TimerStarted>(_onTimerStarted);
    on<TimerPaused>(_onTimerPaused);
    on<TimerStopped>(_onTimerStopped);
    on<TimerReset>(_onTimerReset);
    on<TimerAdjusted>(_onTimerAdjusted);
    on<TimerTicked>(_onTimerTicked);
    on<BulkTimersStarted>(_onBulkTimersStarted);
    on<BulkTimersStopped>(_onBulkTimersStopped);
    on<BulkTimersReset>(_onBulkTimersReset);
    on<BulkTimersDeleted>(_onBulkTimersDeleted);
    on<TimersImportedFromCsv>(_onTimersImportedFromCsv);
    on<TimersExported>(_onTimersExported);
  }

  Future<void> _onTimerLoadRequested(
    TimerLoadRequested event,
    Emitter<TimerState> emit,
  ) async {
    emit(const TimerLoading());
    
    try {
      await _timersSubscription?.cancel();
      
      _timersSubscription = _timerRepository.watchTimers().listen(
        (timers) {
          add(TimerTicked(timers));
        },
        onError: (error) {
          emit(TimerError(message: error.toString()));
        },
      );
      
      final timers = await _timerRepository.getAllTimers();
      emit(TimerLoaded(
        timers: timers,
        isBlackoutMode: _isBlackoutMode,
      ));
    } catch (error) {
      emit(TimerError(message: error.toString()));
    }
  }

  Future<void> _onTimerCreated(
    TimerCreated event,
    Emitter<TimerState> emit,
  ) async {
    try {
      emit(TimerOperationInProgress(
        timers: _getCurrentTimers(),
        operation: 'Creating timer',
        timerId: event.timer.id,
      ));
      
      await _timerRepository.createTimer(event.timer);
    } catch (error) {
      emit(TimerError(
        message: 'Failed to create timer: ${error.toString()}',
        timers: _getCurrentTimers(),
      ));
    }
  }

  Future<void> _onTimerUpdated(
    TimerUpdated event,
    Emitter<TimerState> emit,
  ) async {
    try {
      emit(TimerOperationInProgress(
        timers: _getCurrentTimers(),
        operation: 'Updating timer',
        timerId: event.timer.id,
      ));
      
      await _timerRepository.updateTimer(event.timer);
    } catch (error) {
      emit(TimerError(
        message: 'Failed to update timer: ${error.toString()}',
        timers: _getCurrentTimers(),
      ));
    }
  }

  Future<void> _onTimerDeleted(
    TimerDeleted event,
    Emitter<TimerState> emit,
  ) async {
    try {
      emit(TimerOperationInProgress(
        timers: _getCurrentTimers(),
        operation: 'Deleting timer',
        timerId: event.timerId,
      ));
      
      await _timerRepository.deleteTimer(event.timerId);
    } catch (error) {
      emit(TimerError(
        message: 'Failed to delete timer: ${error.toString()}',
        timers: _getCurrentTimers(),
      ));
    }
  }

  Future<void> _onTimerStarted(
    TimerStarted event,
    Emitter<TimerState> emit,
  ) async {
    try {
      await _timerRepository.startTimer(event.timerId);
    } catch (error) {
      emit(TimerError(
        message: 'Failed to start timer: ${error.toString()}',
        timers: _getCurrentTimers(),
      ));
    }
  }

  Future<void> _onTimerPaused(
    TimerPaused event,
    Emitter<TimerState> emit,
  ) async {
    try {
      await _timerRepository.pauseTimer(event.timerId);
    } catch (error) {
      emit(TimerError(
        message: 'Failed to pause timer: ${error.toString()}',
        timers: _getCurrentTimers(),
      ));
    }
  }

  Future<void> _onTimerStopped(
    TimerStopped event,
    Emitter<TimerState> emit,
  ) async {
    try {
      await _timerRepository.stopTimer(event.timerId);
    } catch (error) {
      emit(TimerError(
        message: 'Failed to stop timer: ${error.toString()}',
        timers: _getCurrentTimers(),
      ));
    }
  }

  Future<void> _onTimerReset(
    TimerReset event,
    Emitter<TimerState> emit,
  ) async {
    try {
      await _timerRepository.resetTimer(event.timerId);
    } catch (error) {
      emit(TimerError(
        message: 'Failed to reset timer: ${error.toString()}',
        timers: _getCurrentTimers(),
      ));
    }
  }

  Future<void> _onTimerAdjusted(
    TimerAdjusted event,
    Emitter<TimerState> emit,
  ) async {
    try {
      await _timerRepository.adjustTimer(event.timerId, event.seconds);
    } catch (error) {
      emit(TimerError(
        message: 'Failed to adjust timer: ${error.toString()}',
        timers: _getCurrentTimers(),
      ));
    }
  }

  void _onTimerTicked(
    TimerTicked event,
    Emitter<TimerState> emit,
  ) {
    if (state is TimerLoaded || state is TimerError) {
      emit(TimerLoaded(
        timers: event.updatedTimers,
        isBlackoutMode: _isBlackoutMode,
      ));
    }
  }

  Future<void> _onBulkTimersStarted(
    BulkTimersStarted event,
    Emitter<TimerState> emit,
  ) async {
    try {
      emit(TimerOperationInProgress(
        timers: _getCurrentTimers(),
        operation: 'Starting all timers',
      ));
      
      await _timerRepository.startAllTimers();
    } catch (error) {
      emit(TimerError(
        message: 'Failed to start all timers: ${error.toString()}',
        timers: _getCurrentTimers(),
      ));
    }
  }

  Future<void> _onBulkTimersStopped(
    BulkTimersStopped event,
    Emitter<TimerState> emit,
  ) async {
    try {
      emit(TimerOperationInProgress(
        timers: _getCurrentTimers(),
        operation: 'Stopping all timers',
      ));
      
      await _timerRepository.stopAllTimers();
    } catch (error) {
      emit(TimerError(
        message: 'Failed to stop all timers: ${error.toString()}',
        timers: _getCurrentTimers(),
      ));
    }
  }

  Future<void> _onBulkTimersReset(
    BulkTimersReset event,
    Emitter<TimerState> emit,
  ) async {
    try {
      emit(TimerOperationInProgress(
        timers: _getCurrentTimers(),
        operation: 'Resetting all timers',
      ));
      
      await _timerRepository.resetAllTimers();
    } catch (error) {
      emit(TimerError(
        message: 'Failed to reset all timers: ${error.toString()}',
        timers: _getCurrentTimers(),
      ));
    }
  }

  Future<void> _onBulkTimersDeleted(
    BulkTimersDeleted event,
    Emitter<TimerState> emit,
  ) async {
    try {
      emit(TimerOperationInProgress(
        timers: _getCurrentTimers(),
        operation: 'Deleting all timers',
      ));
      
      await _timerRepository.deleteAllTimers();
    } catch (error) {
      emit(TimerError(
        message: 'Failed to delete all timers: ${error.toString()}',
        timers: _getCurrentTimers(),
      ));
    }
  }

  Future<void> _onTimersImportedFromCsv(
    TimersImportedFromCsv event,
    Emitter<TimerState> emit,
  ) async {
    try {
      emit(TimerOperationInProgress(
        timers: _getCurrentTimers(),
        operation: 'Importing timers from CSV',
      ));
      
      final importedTimers = await _timerRepository.importFromCsv(event.csvData);
      final allTimers = await _timerRepository.getAllTimers();
      
      emit(TimersImported(
        timers: allTimers,
        importedTimers: importedTimers,
      ));
    } catch (error) {
      emit(TimerError(
        message: 'Failed to import timers: ${error.toString()}',
        timers: _getCurrentTimers(),
      ));
    }
  }

  Future<void> _onTimersExported(
    TimersExported event,
    Emitter<TimerState> emit,
  ) async {
    try {
      final timers = _getCurrentTimers();
      String exportData;
      
      switch (event.format.toLowerCase()) {
        case 'csv':
          exportData = await _timerRepository.exportToCsv(timers);
          break;
        case 'json':
          exportData = await _timerRepository.exportToJson(timers);
          break;
        default:
          throw Exception('Unsupported export format: ${event.format}');
      }
      
      emit(TimerExported(
        timers: timers,
        exportData: exportData,
        format: event.format,
      ));
    } catch (error) {
      emit(TimerError(
        message: 'Failed to export timers: ${error.toString()}',
        timers: _getCurrentTimers(),
      ));
    }
  }

  void toggleBlackoutMode() {
    _isBlackoutMode = !_isBlackoutMode;
    if (state is TimerLoaded) {
      emit((state as TimerLoaded).copyWith(isBlackoutMode: _isBlackoutMode));
    }
  }

  List<TimerEntity> _getCurrentTimers() {
    if (state is TimerLoaded) {
      return (state as TimerLoaded).timers;
    }
    if (state is TimerError) {
      return (state as TimerError).timers ?? [];
    }
    if (state is TimerOperationInProgress) {
      return (state as TimerOperationInProgress).timers;
    }
    return [];
  }

  @override
  Future<void> close() {
    _timersSubscription?.cancel();
    return super.close();
  }
}