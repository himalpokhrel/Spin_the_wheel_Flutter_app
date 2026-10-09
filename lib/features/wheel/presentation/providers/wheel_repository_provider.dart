import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/wheel_local_datasource.dart';
import '../../data/repositories/wheel_repository_impl.dart';
import '../../domain/entities/wheel.dart';
import '../../domain/repositories/wheel_repository.dart';
import '../../domain/usecases/delete_wheel.dart';
import '../../domain/usecases/get_wheels.dart';
import '../../domain/usecases/save_wheel.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in main.dart');
});

final wheelLocalDataSourceProvider = Provider<WheelLocalDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return WheelLocalDataSource(prefs);
});

final wheelRepositoryProvider = Provider<WheelRepository>((ref) {
  final dataSource = ref.watch(wheelLocalDataSourceProvider);
  return WheelRepositoryImpl(dataSource);
});

final getWheelsProvider = Provider<GetWheels>((ref) {
  final repository = ref.watch(wheelRepositoryProvider);
  return GetWheels(repository);
});

final saveWheelProvider = Provider<SaveWheel>((ref) {
  final repository = ref.watch(wheelRepositoryProvider);
  return SaveWheel(repository);
});

final deleteWheelProvider = Provider<DeleteWheel>((ref) {
  final repository = ref.watch(wheelRepositoryProvider);
  return DeleteWheel(repository);
});

// State provider for wheels list
final wheelsListProvider = FutureProvider<List<Wheel>>((ref) async {
  final getWheels = ref.watch(getWheelsProvider);
  return await getWheels();
});
