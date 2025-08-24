import '../entities/timer_entity.dart';
import '../entities/rundown_entity.dart';

abstract class TimerRepository {
  // Timer CRUD operations
  Future<List<TimerEntity>> getAllTimers();
  Future<TimerEntity?> getTimerById(String id);
  Future<TimerEntity> createTimer(TimerEntity timer);
  Future<TimerEntity> updateTimer(TimerEntity timer);
  Future<void> deleteTimer(String id);
  
  // Timer control operations
  Future<TimerEntity> startTimer(String id);
  Future<TimerEntity> pauseTimer(String id);
  Future<TimerEntity> stopTimer(String id);
  Future<TimerEntity> resetTimer(String id);
  Future<TimerEntity> adjustTimer(String id, int seconds);
  
  // Rundown operations
  Future<List<RundownEntity>> getAllRundowns();
  Future<RundownEntity?> getRundownById(String id);
  Future<RundownEntity> createRundown(RundownEntity rundown);
  Future<RundownEntity> updateRundown(RundownEntity rundown);
  Future<void> deleteRundown(String id);
  
  // Rundown control operations
  Future<RundownEntity> advanceToNextTimer(String rundownId);
  Future<RundownEntity> moveToPreviousTimer(String rundownId);
  Future<RundownEntity> jumpToTimer(String rundownId, int timerIndex);
  
  // Bulk operations
  Future<void> startAllTimers();
  Future<void> stopAllTimers();
  Future<void> resetAllTimers();
  Future<void> deleteAllTimers();
  
  // Import/Export operations
  Future<List<TimerEntity>> importFromCsv(String csvData);
  Future<String> exportToCsv(List<TimerEntity> timers);
  Future<String> exportToJson(List<TimerEntity> timers);
  
  // Stream operations
  Stream<List<TimerEntity>> watchTimers();
  Stream<TimerEntity?> watchTimer(String id);
  Stream<List<RundownEntity>> watchRundowns();
  Stream<RundownEntity?> watchRundown(String id);
}