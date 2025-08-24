import 'package:get_it/get_it.dart';
import '../domain/repositories/timer_repository.dart';
import '../data/repositories/timer_repository_impl.dart';
import '../presentation/blocs/timer/timer_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // Repositories
  sl.registerLazySingleton<TimerRepository>(() => TimerRepositoryImpl());
  
  // BLoCs
  sl.registerFactory(() => TimerBloc(timerRepository: sl()));
  
  // Initialize repositories
  // This ensures the timer repository starts ticking immediately
  sl<TimerRepository>();
}

Future<void> dispose() async {
  if (sl.isRegistered<TimerRepositoryImpl>()) {
    (sl<TimerRepository>() as TimerRepositoryImpl).dispose();
  }
  await sl.reset();
}