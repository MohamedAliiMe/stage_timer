import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum TimerType {
  countdown,
  countUp,
  clock,
}

enum TimerStatus {
  stopped,
  running,
  paused,
  finished,
}

enum TimerLinkType {
  manual,
  automatic,
  scheduled,
}

class TimerEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final TimerType type;
  final TimerStatus state;
  final int duration; // in seconds
  final int remainingTime; // in seconds
  final DateTime? startTime;
  final DateTime? endTime;
  final DateTime? scheduledStartTime;
  final TimerLinkType linkType;
  final String? nextTimerId;
  final Color? customColor;
  final bool isWrapUp;
  final int wrapUpThreshold; // seconds before end when wrap-up starts
  final bool enableChime;
  final String? chimeSound;
  final bool is24HourFormat;
  final Map<String, dynamic>? customProperties;

  const TimerEntity({
    required this.id,
    required this.name,
    this.description = '',
    required this.type,
    this.state = TimerStatus.stopped,
    required this.duration,
    int? remainingTime,
    this.startTime,
    this.endTime,
    this.scheduledStartTime,
    this.linkType = TimerLinkType.manual,
    this.nextTimerId,
    this.customColor,
    this.isWrapUp = false,
    this.wrapUpThreshold = 60, // 1 minute default
    this.enableChime = false,
    this.chimeSound,
    this.is24HourFormat = true,
    this.customProperties,
  }) : remainingTime = remainingTime ?? duration;

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        type,
        state,
        duration,
        remainingTime,
        startTime,
        endTime,
        scheduledStartTime,
        linkType,
        nextTimerId,
        customColor,
        isWrapUp,
        wrapUpThreshold,
        enableChime,
        chimeSound,
        is24HourFormat,
        customProperties,
      ];

  TimerEntity copyWith({
    String? id,
    String? name,
    String? description,
    TimerType? type,
    TimerStatus? state,
    int? duration,
    int? remainingTime,
    DateTime? startTime,
    DateTime? endTime,
    DateTime? scheduledStartTime,
    TimerLinkType? linkType,
    String? nextTimerId,
    Color? customColor,
    bool? isWrapUp,
    int? wrapUpThreshold,
    bool? enableChime,
    String? chimeSound,
    bool? is24HourFormat,
    Map<String, dynamic>? customProperties,
  }) {
    return TimerEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      state: state ?? this.state,
      duration: duration ?? this.duration,
      remainingTime: remainingTime ?? this.remainingTime,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      scheduledStartTime: scheduledStartTime ?? this.scheduledStartTime,
      linkType: linkType ?? this.linkType,
      nextTimerId: nextTimerId ?? this.nextTimerId,
      customColor: customColor ?? this.customColor,
      isWrapUp: isWrapUp ?? this.isWrapUp,
      wrapUpThreshold: wrapUpThreshold ?? this.wrapUpThreshold,
      enableChime: enableChime ?? this.enableChime,
      chimeSound: chimeSound ?? this.chimeSound,
      is24HourFormat: is24HourFormat ?? this.is24HourFormat,
      customProperties: customProperties ?? this.customProperties,
    );
  }

  bool get isActive => state == TimerStatus.running;
  bool get isPaused => state == TimerStatus.paused;
  bool get isFinished => state == TimerStatus.finished;
  bool get isStopped => state == TimerStatus.stopped;
  
  bool get shouldShowWrapUp => 
      type == TimerType.countdown && 
      remainingTime <= wrapUpThreshold && 
      remainingTime > 0 && 
      isActive;

  double get progress {
    if (duration == 0) return 0;
    switch (type) {
      case TimerType.countdown:
        return (duration - remainingTime) / duration;
      case TimerType.countUp:
        return remainingTime / duration;
      case TimerType.clock:
        return 0; // Clock doesn't have progress
    }
  }

  String get formattedTime {
    final time = type == TimerType.countUp ? remainingTime : remainingTime;
    final hours = time ~/ 3600;
    final minutes = (time % 3600) ~/ 60;
    final seconds = time % 60;
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  String get formattedClockTime {
    final now = DateTime.now();
    final hour = is24HourFormat ? now.hour : (now.hour % 12 == 0 ? 12 : now.hour % 12);
    final minute = now.minute.toString().padLeft(2, '0');
    final second = now.second.toString().padLeft(2, '0');
    
    if (is24HourFormat) {
      return '${hour.toString().padLeft(2, '0')}:$minute:$second';
    } else {
      final amPm = now.hour >= 12 ? 'PM' : 'AM';
      return '$hour:$minute:$second $amPm';
    }
  }
}

