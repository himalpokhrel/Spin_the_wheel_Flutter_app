import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../wheel/presentation/providers/wheel_repository_provider.dart';
import '../../data/datasources/history_local_datasource.dart';
import '../../data/repositories/history_repository_impl.dart';
import '../../domain/entities/spin_history.dart';
import '../../domain/repositories/history_repository.dart';
import '../../domain/usecases/clear_history.dart';
import '../../domain/usecases/get_history.dart';
import '../../domain/usecases/save_history_entry.dart';

final historyLocalDataSourceProvider = Provider<HistoryLocalDatasource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return HistoryLocalDatasource(prefs);
});

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  final dataSource = ref.watch(historyLocalDataSourceProvider);
  return HistoryRepositoryImpl(dataSource);
});

final getHistoryProvider = Provider<GetHistory>((ref) {
  final repository = ref.watch(historyRepositoryProvider);
  return GetHistory(repository);
});

final saveHistoryEntryProvider = Provider<SaveHistoryEntry>((ref) {
  final repository = ref.watch(historyRepositoryProvider);
  return SaveHistoryEntry(repository);
});

final clearHistoryProvider = Provider<ClearHistory>((ref) {
  final repository = ref.watch(historyRepositoryProvider);
  return ClearHistory(repository);
});

// State provider for history list
final historyListProvider = FutureProvider<List<SpinHistory>>((ref) async {
  final getHistory = ref.watch(getHistoryProvider);
  return await getHistory();
});
