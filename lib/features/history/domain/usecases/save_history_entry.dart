import '../entities/spin_history.dart';
import '../repositories/history_repository.dart';

class SaveHistoryEntry {
  SaveHistoryEntry(this._repository);

  final HistoryRepository _repository;

  Future<void> call(SpinHistory entry) async {
    await _repository.saveHistoryEntry(entry);
  }
}
