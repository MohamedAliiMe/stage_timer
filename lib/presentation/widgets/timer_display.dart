import 'package:flutter/material.dart';
import '../../domain/entities/timer_entity.dart';
import '../../core/theme/app_theme.dart';

class TimerDisplay extends StatelessWidget {
  final TimerEntity timer;
  final bool isLargeDisplay;
  final bool showProgress;
  final bool showControls;
  final VoidCallback? onStart;
  final VoidCallback? onPause;
  final VoidCallback? onStop;
  final VoidCallback? onReset;
  final Function(int)? onAdjust;

  const TimerDisplay({
    super.key,
    required this.timer,
    this.isLargeDisplay = false,
    this.showProgress = true,
    this.showControls = false,
    this.onStart,
    this.onPause,
    this.onStop,
    this.onReset,
    this.onAdjust,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: _getGradientForTimer(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            _buildTimeDisplay(context),
            if (showProgress && timer.type != TimerType.clock) ...[
              const SizedBox(height: 16),
              _buildProgressBar(context),
            ],
            if (showControls) ...[
              const SizedBox(height: 16),
              _buildControls(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                timer.name,
                style: isLargeDisplay
                    ? Theme.of(context).textTheme.headlineMedium
                    : Theme.of(context).textTheme.titleLarge,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (timer.description.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  timer.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
        _buildStatusIndicator(),
      ],
    );
  }

  Widget _buildStatusIndicator() {
    Color color;
    IconData icon;
    
    switch (timer.state) {
      case TimerStatus.running:
        color = timer.shouldShowWrapUp 
            ? AppTheme.timerCriticalColor 
            : AppTheme.timerActiveColor;
        icon = Icons.play_arrow;
        break;
      case TimerStatus.paused:
        color = AppTheme.timerPausedColor;
        icon = Icons.pause;
        break;
      case TimerStatus.finished:
        color = AppTheme.timerCriticalColor;
        icon = Icons.stop;
        break;
      case TimerStatus.stopped:
        color = AppTheme.textMutedColor;
        icon = Icons.stop;
        break;
    }
    
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: color.a * 0.2),
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      child: Icon(
        icon,
        color: color,
        size: isLargeDisplay ? 32 : 24,
      ),
    );
  }

  Widget _buildTimeDisplay(BuildContext context) {
    String timeText;
    
    switch (timer.type) {
      case TimerType.countdown:
      case TimerType.countUp:
        timeText = timer.formattedTime;
        break;
      case TimerType.clock:
        timeText = timer.formattedClockTime;
        break;
    }

    return Center(
      child: Text(
        timeText,
        style: isLargeDisplay
            ? Theme.of(context).textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: _getTimeTextColor(),
                fontFeatures: const [FontFeature.tabularFigures()],
              )
            : Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: _getTimeTextColor(),
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: timer.progress,
          backgroundColor: Colors.white.withValues(alpha: 0.3),
          valueColor: AlwaysStoppedAnimation<Color>(
            timer.shouldShowWrapUp 
                ? AppTheme.timerCriticalColor
                : AppTheme.timerActiveColor,
          ),
          minHeight: isLargeDisplay ? 8 : 4,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _getProgressLabel(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              '${(timer.progress * 100).toInt()}%',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildControls(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (timer.state != TimerStatus.running) ...[
          IconButton(
            onPressed: onStart,
            icon: const Icon(Icons.play_arrow),
            tooltip: 'Start',
          ),
        ] else ...[
          IconButton(
            onPressed: onPause,
            icon: const Icon(Icons.pause),
            tooltip: 'Pause',
          ),
        ],
        const SizedBox(width: 8),
        IconButton(
          onPressed: onStop,
          icon: const Icon(Icons.stop),
          tooltip: 'Stop',
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: onReset,
          icon: const Icon(Icons.refresh),
          tooltip: 'Reset',
        ),
        if (onAdjust != null && timer.type != TimerType.clock) ...[
          const SizedBox(width: 16),
          IconButton(
            onPressed: () => onAdjust!(-60),
            icon: const Icon(Icons.remove),
            tooltip: 'Remove 1 minute',
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => onAdjust!(60),
            icon: const Icon(Icons.add),
            tooltip: 'Add 1 minute',
          ),
        ],
      ],
    );
  }

  LinearGradient _getGradientForTimer() {
    Color primaryColor = timer.customColor ?? AppTheme.primaryColor;
    
    if (timer.shouldShowWrapUp) {
      primaryColor = AppTheme.timerCriticalColor;
    } else if (timer.isActive) {
      primaryColor = timer.customColor ?? AppTheme.timerActiveColor;
    } else if (timer.isFinished) {
      primaryColor = AppTheme.timerCriticalColor;
    } else if (timer.isPaused) {
      primaryColor = AppTheme.timerPausedColor;
    }

    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        primaryColor.withValues(alpha: primaryColor.a * 0.1),
        primaryColor.withValues(alpha: primaryColor.a * 0.05),
      ],
    );
  }

  Color _getTimeTextColor() {
    if (timer.shouldShowWrapUp || timer.isFinished) {
      return AppTheme.timerCriticalColor;
    } else if (timer.isActive) {
      return AppTheme.timerActiveColor;
    } else if (timer.isPaused) {
      return AppTheme.timerPausedColor;
    }
    return AppTheme.textPrimaryColor;
  }

  String _getProgressLabel() {
    switch (timer.type) {
      case TimerType.countdown:
        return 'Elapsed';
      case TimerType.countUp:
        return 'Progress';
      case TimerType.clock:
        return 'Time';
    }
  }
}