import '../entities/spin_history.dart';

abstract class HistoryRepository {
  Future<List<SpinHistory>> getHistory();
  Future<void> saveHistoryEntry(SpinHistory entry);
  Future<void> clearHistory();
}
