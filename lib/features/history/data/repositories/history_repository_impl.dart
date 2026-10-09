import '../../domain/entities/spin_history.dart';
import '../../domain/repositories/history_repository.dart';
import '../datasources/history_local_datasource.dart';
import '../models/spin_history_model.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  HistoryRepositoryImpl(this._localDatasource);

  final HistoryLocalDatasource _localDatasource;

  @override
  Future<List<SpinHistory>> getHistory() async {
    return await _localDatasource.getHistory();
  }

  @override
  Future<void> saveHistoryEntry(SpinHistory entry) async {
    final currentHistory = await _localDatasource.getHistory();
    final newHistory = [
      SpinHistoryModel.fromEntity(entry),
      ...currentHistory,
    ];
    await _localDatasource.saveHistory(newHistory);
  }

  @override
  Future<void> clearHistory() async {
    await _localDatasource.clearHistory();
  }
}
