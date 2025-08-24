import 'dart:async';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/timer_entity.dart';
import '../../domain/entities/rundown_entity.dart';
import '../../domain/repositories/timer_repository.dart';

class TimerRepositoryImpl implements TimerRepository {
  final List<TimerEntity> _timers = [];
  final List<RundownEntity> _rundowns = [];
  final StreamController<List<TimerEntity>> _timersController = StreamController.broadcast();
  final StreamController<List<RundownEntity>> _rundownsController = StreamController.broadcast();
  final Map<String, StreamController<TimerEntity?>> _timerControllers = {};
  final Map<String, StreamController<RundownEntity?>> _rundownControllers = {};
  
  Timer? _tickTimer;
  final Uuid _uuid = const Uuid();

  TimerRepositoryImpl() {
    _initializeWithSampleData();
    _startTicking();
  }

  void _initializeWithSampleData() {
    final sampleTimers = [
      // Conference Schedule
      TimerEntity(
        id: _uuid.v4(),
        name: 'Opening Remarks',
        description: 'Welcome and introduction by CEO',
        type: TimerType.countdown,
        duration: 300, // 5 minutes
        customColor: const Color(0xFF2196F3), // Blue
        enableChime: true,
      ),
      TimerEntity(
        id: _uuid.v4(),
        name: 'Keynote Presentation',
        description: 'Main presentation - Digital Transformation',
        type: TimerType.countdown,
        duration: 1800, // 30 minutes
        customColor: const Color(0xFF4CAF50), // Green
        wrapUpThreshold: 300, // 5 minutes wrap-up
        enableChime: true,
      ),
      TimerEntity(
        id: _uuid.v4(),
        name: 'Panel Discussion',
        description: 'Expert panel on industry trends',
        type: TimerType.countdown,
        duration: 2700, // 45 minutes
        customColor: const Color(0xFF9C27B0), // Purple
        wrapUpThreshold: 600, // 10 minutes wrap-up
        enableChime: true,
      ),
      TimerEntity(
        id: _uuid.v4(),
        name: 'Q&A Session',
        description: 'Audience questions and answers',
        type: TimerType.countUp,
        duration: 900, // 15 minutes maximum
        customColor: const Color(0xFFFF9800), // Orange
        enableChime: false,
      ),
      TimerEntity(
        id: _uuid.v4(),
        name: 'Coffee Break',
        description: 'Networking and refreshments',
        type: TimerType.countdown,
        duration: 900, // 15 minutes
        customColor: const Color(0xFF795548), // Brown
        enableChime: true,
      ),
      TimerEntity(
        id: _uuid.v4(),
        name: 'Workshop Session',
        description: 'Hands-on technical workshop',
        type: TimerType.countdown,
        duration: 3600, // 60 minutes
        customColor: const Color(0xFF607D8B), // Blue Grey
        wrapUpThreshold: 900, // 15 minutes wrap-up
        enableChime: true,
      ),
      TimerEntity(
        id: _uuid.v4(),
        name: 'Closing Remarks',
        description: 'Thank you and next steps',
        type: TimerType.countdown,
        duration: 600, // 10 minutes
        customColor: const Color(0xFFE91E63), // Pink
        enableChime: true,
      ),
      TimerEntity(
        id: _uuid.v4(),
        name: 'Current Time',
        description: 'Live clock display',
        type: TimerType.clock,
        duration: 0,
        is24HourFormat: false,
        customColor: const Color(0xFF607D8B), // Blue Grey
      ),
      // Additional timer types for demonstration
      TimerEntity(
        id: _uuid.v4(),
        name: 'Speaker Prep',
        description: 'Preparation time for next speaker',
        type: TimerType.countdown,
        duration: 180, // 3 minutes
        customColor: const Color(0xFFFFC107), // Amber
        enableChime: true,
      ),
      TimerEntity(
        id: _uuid.v4(),
        name: 'Live Demo',
        description: 'Product demonstration',
        type: TimerType.countUp,
        duration: 1200, // 20 minutes maximum
        customColor: const Color(0xFF00BCD4), // Cyan
        enableChime: false,
      ),
    ];

    _timers.addAll(sampleTimers);

    final sampleRundown = RundownEntity(
      id: _uuid.v4(),
      name: 'Conference Day 1',
      description: 'First day of the annual conference',
      timers: sampleTimers,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      autoAdvance: true,
    );

    _rundowns.add(sampleRundown);
    _emitUpdates();
  }

  void _startTicking() {
    _tickTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      bool hasChanges = false;
      
      for (int i = 0; i < _timers.length; i++) {
        final timer = _timers[i];
        if (timer.isActive) {
          TimerEntity updatedTimer;
          
          switch (timer.type) {
            case TimerType.countdown:
              final newRemainingTime = timer.remainingTime - 1;
              if (newRemainingTime <= 0) {
                updatedTimer = timer.copyWith(
                  remainingTime: 0,
                  state: TimerStatus.finished,
                  endTime: DateTime.now(),
                );
              } else {
                updatedTimer = timer.copyWith(
                  remainingTime: newRemainingTime,
                  isWrapUp: newRemainingTime <= timer.wrapUpThreshold,
                );
              }
              break;
              
            case TimerType.countUp:
              final newRemainingTime = timer.remainingTime + 1;
              if (newRemainingTime >= timer.duration) {
                updatedTimer = timer.copyWith(
                  remainingTime: timer.duration,
                  state: TimerStatus.finished,
                  endTime: DateTime.now(),
                );
              } else {
                updatedTimer = timer.copyWith(remainingTime: newRemainingTime);
              }
              break;
              
            case TimerType.clock:
              updatedTimer = timer;
              break;
          }
          
          if (updatedTimer != timer) {
            _timers[i] = updatedTimer;
            hasChanges = true;
            
            _timerControllers[timer.id]?.add(updatedTimer);
            
            // Auto-advance in rundowns if enabled
            if (updatedTimer.isFinished) {
              _handleTimerFinished(updatedTimer);
            }
          }
        }
      }
      
      if (hasChanges) {
        _emitUpdates();
      }
    });
  }

  void _handleTimerFinished(TimerEntity finishedTimer) {
    // Find rundown containing this timer and auto-advance if enabled
    for (int i = 0; i < _rundowns.length; i++) {
      final rundown = _rundowns[i];
      if (rundown.autoAdvance && rundown.currentTimer?.id == finishedTimer.id) {
        if (rundown.hasNextTimer) {
          final updatedRundown = rundown.copyWith(
            currentTimerIndex: rundown.currentTimerIndex + 1,
            updatedAt: DateTime.now(),
          );
          _rundowns[i] = updatedRundown;
          _rundownControllers[rundown.id]?.add(updatedRundown);
        }
      }
    }
  }

  void _emitUpdates() {
    _timersController.add(List.from(_timers));
    _rundownsController.add(List.from(_rundowns));
  }

  @override
  Future<List<TimerEntity>> getAllTimers() async {
    await Future.delayed(const Duration(milliseconds: 50)); // Simulate network delay
    return List.from(_timers);
  }

  @override
  Future<TimerEntity?> getTimerById(String id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    try {
      return _timers.firstWhere((timer) => timer.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<TimerEntity> createTimer(TimerEntity timer) async {
    await Future.delayed(const Duration(milliseconds: 50));
    final newTimer = timer.copyWith(id: timer.id.isEmpty ? _uuid.v4() : timer.id);
    _timers.add(newTimer);
    _emitUpdates();
    return newTimer;
  }

  @override
  Future<TimerEntity> updateTimer(TimerEntity timer) async {
    await Future.delayed(const Duration(milliseconds: 50));
    final index = _timers.indexWhere((t) => t.id == timer.id);
    if (index != -1) {
      _timers[index] = timer;
      _timerControllers[timer.id]?.add(timer);
      _emitUpdates();
      return timer;
    }
    throw Exception('Timer not found');
  }

  @override
  Future<void> deleteTimer(String id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    _timers.removeWhere((timer) => timer.id == id);
    _timerControllers[id]?.add(null);
    _emitUpdates();
  }

  @override
  Future<TimerEntity> startTimer(String id) async {
    final timer = await getTimerById(id);
    if (timer == null) throw Exception('Timer not found');
    
    final updatedTimer = timer.copyWith(
      state: TimerStatus.running,
      startTime: timer.startTime ?? DateTime.now(),
    );
    return updateTimer(updatedTimer);
  }

  @override
  Future<TimerEntity> pauseTimer(String id) async {
    final timer = await getTimerById(id);
    if (timer == null) throw Exception('Timer not found');
    
    final updatedTimer = timer.copyWith(state: TimerStatus.paused);
    return updateTimer(updatedTimer);
  }

  @override
  Future<TimerEntity> stopTimer(String id) async {
    final timer = await getTimerById(id);
    if (timer == null) throw Exception('Timer not found');
    
    final updatedTimer = timer.copyWith(
      state: TimerStatus.stopped,
      startTime: null,
      endTime: null,
    );
    return updateTimer(updatedTimer);
  }

  @override
  Future<TimerEntity> resetTimer(String id) async {
    final timer = await getTimerById(id);
    if (timer == null) throw Exception('Timer not found');
    
    final updatedTimer = timer.copyWith(
      state: TimerStatus.stopped,
      remainingTime: timer.duration,
      startTime: null,
      endTime: null,
      isWrapUp: false,
    );
    return updateTimer(updatedTimer);
  }

  @override
  Future<TimerEntity> adjustTimer(String id, int seconds) async {
    final timer = await getTimerById(id);
    if (timer == null) throw Exception('Timer not found');
    
    int newRemainingTime;
    switch (timer.type) {
      case TimerType.countdown:
        newRemainingTime = (timer.remainingTime + seconds).clamp(0, timer.duration);
        break;
      case TimerType.countUp:
        newRemainingTime = (timer.remainingTime + seconds).clamp(0, timer.duration);
        break;
      case TimerType.clock:
        return timer; // Can't adjust clock
    }
    
    final updatedTimer = timer.copyWith(remainingTime: newRemainingTime);
    return updateTimer(updatedTimer);
  }

  @override
  Future<List<RundownEntity>> getAllRundowns() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return List.from(_rundowns);
  }

  @override
  Future<RundownEntity?> getRundownById(String id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    try {
      return _rundowns.firstWhere((rundown) => rundown.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<RundownEntity> createRundown(RundownEntity rundown) async {
    await Future.delayed(const Duration(milliseconds: 50));
    final newRundown = rundown.copyWith(
      id: rundown.id.isEmpty ? _uuid.v4() : rundown.id,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _rundowns.add(newRundown);
    _emitUpdates();
    return newRundown;
  }

  @override
  Future<RundownEntity> updateRundown(RundownEntity rundown) async {
    await Future.delayed(const Duration(milliseconds: 50));
    final index = _rundowns.indexWhere((r) => r.id == rundown.id);
    if (index != -1) {
      final updatedRundown = rundown.copyWith(updatedAt: DateTime.now());
      _rundowns[index] = updatedRundown;
      _rundownControllers[rundown.id]?.add(updatedRundown);
      _emitUpdates();
      return updatedRundown;
    }
    throw Exception('Rundown not found');
  }

  @override
  Future<void> deleteRundown(String id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    _rundowns.removeWhere((rundown) => rundown.id == id);
    _rundownControllers[id]?.add(null);
    _emitUpdates();
  }

  @override
  Future<RundownEntity> advanceToNextTimer(String rundownId) async {
    final rundown = await getRundownById(rundownId);
    if (rundown == null) throw Exception('Rundown not found');
    
    if (rundown.hasNextTimer) {
      final updatedRundown = rundown.copyWith(
        currentTimerIndex: rundown.currentTimerIndex + 1,
      );
      return updateRundown(updatedRundown);
    }
    return rundown;
  }

  @override
  Future<RundownEntity> moveToPreviousTimer(String rundownId) async {
    final rundown = await getRundownById(rundownId);
    if (rundown == null) throw Exception('Rundown not found');
    
    if (rundown.hasPreviousTimer) {
      final updatedRundown = rundown.copyWith(
        currentTimerIndex: rundown.currentTimerIndex - 1,
      );
      return updateRundown(updatedRundown);
    }
    return rundown;
  }

  @override
  Future<RundownEntity> jumpToTimer(String rundownId, int timerIndex) async {
    final rundown = await getRundownById(rundownId);
    if (rundown == null) throw Exception('Rundown not found');
    
    if (timerIndex >= 0 && timerIndex < rundown.timers.length) {
      final updatedRundown = rundown.copyWith(currentTimerIndex: timerIndex);
      return updateRundown(updatedRundown);
    }
    return rundown;
  }

  @override
  Future<void> startAllTimers() async {
    for (final timer in _timers) {
      if (!timer.isActive) {
        await startTimer(timer.id);
      }
    }
  }

  @override
  Future<void> stopAllTimers() async {
    for (final timer in _timers) {
      if (timer.isActive || timer.isPaused) {
        await stopTimer(timer.id);
      }
    }
  }

  @override
  Future<void> resetAllTimers() async {
    for (final timer in _timers) {
      await resetTimer(timer.id);
    }
  }

  @override
  Future<void> deleteAllTimers() async {
    _timers.clear();
    _emitUpdates();
  }

  @override
  Future<List<TimerEntity>> importFromCsv(String csvData) async {
    final rows = const CsvToListConverter().convert(csvData);
    if (rows.isEmpty) return [];
    
    final headers = rows.first.map((e) => e.toString().toLowerCase()).toList();
    final timers = <TimerEntity>[];
    
    for (int i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.length < headers.length) continue;
      
      final nameIndex = headers.indexOf('name');
      final durationIndex = headers.indexOf('duration');
      final typeIndex = headers.indexOf('type');
      
      if (nameIndex == -1 || durationIndex == -1) continue;
      
      final name = row[nameIndex].toString();
      final duration = int.tryParse(row[durationIndex].toString()) ?? 300;
      final typeStr = typeIndex != -1 ? row[typeIndex].toString().toLowerCase() : 'countdown';
      
      TimerType type;
      switch (typeStr) {
        case 'countup':
        case 'count_up':
          type = TimerType.countUp;
          break;
        case 'clock':
          type = TimerType.clock;
          break;
        default:
          type = TimerType.countdown;
      }
      
      final timer = TimerEntity(
        id: _uuid.v4(),
        name: name,
        type: type,
        duration: duration,
      );
      
      timers.add(timer);
      await createTimer(timer);
    }
    
    return timers;
  }

  @override
  Future<String> exportToCsv(List<TimerEntity> timers) async {
    final headers = ['Name', 'Type', 'Duration', 'Description'];
    final rows = [headers];
    
    for (final timer in timers) {
      rows.add([
        timer.name,
        timer.type.name,
        timer.duration.toString(),
        timer.description,
      ]);
    }
    
    return const ListToCsvConverter().convert(rows);
  }

  @override
  Future<String> exportToJson(List<TimerEntity> timers) async {
    final data = timers.map((timer) => {
      'id': timer.id,
      'name': timer.name,
      'type': timer.type.name,
      'duration': timer.duration,
      'description': timer.description,
      'wrapUpThreshold': timer.wrapUpThreshold,
      'enableChime': timer.enableChime,
      'is24HourFormat': timer.is24HourFormat,
    }).toList();
    
    return jsonEncode(data);
  }

  @override
  Stream<List<TimerEntity>> watchTimers() {
    return _timersController.stream;
  }

  @override
  Stream<TimerEntity?> watchTimer(String id) {
    if (!_timerControllers.containsKey(id)) {
      _timerControllers[id] = StreamController<TimerEntity?>.broadcast();
    }
    return _timerControllers[id]!.stream;
  }

  @override
  Stream<List<RundownEntity>> watchRundowns() {
    return _rundownsController.stream;
  }

  @override
  Stream<RundownEntity?> watchRundown(String id) {
    if (!_rundownControllers.containsKey(id)) {
      _rundownControllers[id] = StreamController<RundownEntity?>.broadcast();
    }
    return _rundownControllers[id]!.stream;
  }

  void dispose() {
    _tickTimer?.cancel();
    _timersController.close();
    _rundownsController.close();
    for (final controller in _timerControllers.values) {
      controller.close();
    }
    for (final controller in _rundownControllers.values) {
      controller.close();
    }
  }
}