import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/timer/timer_bloc.dart';
import '../blocs/timer/timer_event.dart';
import '../blocs/timer/timer_state.dart';
import '../widgets/timer_display.dart';
import '../../domain/entities/timer_entity.dart';
import '../../core/theme/app_theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stage Timer'),
        actions: [
          IconButton(
            onPressed: () => context.read<TimerBloc>().toggleBlackoutMode(),
            icon: const Icon(Icons.visibility_off),
            tooltip: 'Toggle Blackout Mode',
          ),
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(context, value),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'bulk_start',
                child: Row(
                  children: [
                    Icon(Icons.play_arrow),
                    SizedBox(width: 8),
                    Text('Start All'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'bulk_stop',
                child: Row(
                  children: [
                    Icon(Icons.stop),
                    SizedBox(width: 8),
                    Text('Stop All'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'bulk_reset',
                child: Row(
                  children: [
                    Icon(Icons.refresh),
                    SizedBox(width: 8),
                    Text('Reset All'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'export_csv',
                child: Row(
                  children: [
                    Icon(Icons.file_download),
                    SizedBox(width: 8),
                    Text('Export CSV'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'export_json',
                child: Row(
                  children: [
                    Icon(Icons.file_download),
                    SizedBox(width: 8),
                    Text('Export JSON'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<TimerBloc, TimerState>(
        builder: (context, state) {
          if (state is TimerInitial || state is TimerLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TimerError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppTheme.errorColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error Loading Timers',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.read<TimerBloc>().add(
                      const TimerLoadRequested(),
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final timers = _getTimersFromState(state);
          final isBlackoutMode = _getBlackoutModeFromState(state);

          if (isBlackoutMode) {
            return Container(
              color: Colors.black,
              child: const Center(
                child: Text(
                  'BLACKOUT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }

          if (timers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.timer_outlined,
                    size: 64,
                    color: AppTheme.textMutedColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Timers Yet',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create your first timer to get started',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _showCreateTimerDialog(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Create Timer'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<TimerBloc>().add(const TimerLoadRequested());
            },
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _getCrossAxisCount(context),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.2,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final timer = timers[index];
                        return TimerDisplay(
                          timer: timer,
                          showControls: true,
                          onStart: () => _startTimer(context, timer.id),
                          onPause: () => _pauseTimer(context, timer.id),
                          onStop: () => _stopTimer(context, timer.id),
                          onReset: () => _resetTimer(context, timer.id),
                          onAdjust: (seconds) => _adjustTimer(context, timer.id, seconds),
                        );
                      },
                      childCount: timers.length,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateTimerDialog(context),
        tooltip: 'Add Timer',
        child: const Icon(Icons.add),
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 3;
    if (width > 800) return 2;
    return 1;
  }

  List<TimerEntity> _getTimersFromState(TimerState state) {
    if (state is TimerLoaded) return state.timers;
    if (state is TimerError) return state.timers ?? [];
    if (state is TimerOperationInProgress) return state.timers;
    if (state is TimerExported) return state.timers;
    if (state is TimersImported) return state.timers;
    return [];
  }

  bool _getBlackoutModeFromState(TimerState state) {
    if (state is TimerLoaded) return state.isBlackoutMode;
    return false;
  }

  void _handleMenuAction(BuildContext context, String action) {
    final bloc = context.read<TimerBloc>();
    
    switch (action) {
      case 'bulk_start':
        bloc.add(const BulkTimersStarted());
        break;
      case 'bulk_stop':
        bloc.add(const BulkTimersStopped());
        break;
      case 'bulk_reset':
        bloc.add(const BulkTimersReset());
        break;
      case 'export_csv':
        bloc.add(const TimersExported('csv'));
        break;
      case 'export_json':
        bloc.add(const TimersExported('json'));
        break;
    }
  }

  void _startTimer(BuildContext context, String timerId) {
    context.read<TimerBloc>().add(TimerStarted(timerId));
  }

  void _pauseTimer(BuildContext context, String timerId) {
    context.read<TimerBloc>().add(TimerPaused(timerId));
  }

  void _stopTimer(BuildContext context, String timerId) {
    context.read<TimerBloc>().add(TimerStopped(timerId));
  }

  void _resetTimer(BuildContext context, String timerId) {
    context.read<TimerBloc>().add(TimerReset(timerId));
  }

  void _adjustTimer(BuildContext context, String timerId, int seconds) {
    context.read<TimerBloc>().add(TimerAdjusted(timerId, seconds));
  }

  void _showCreateTimerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Create Timer'),
        content: const Text(
          'Timer creation dialog would be implemented here.\n\n'
          'For now, sample timers are already loaded.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}