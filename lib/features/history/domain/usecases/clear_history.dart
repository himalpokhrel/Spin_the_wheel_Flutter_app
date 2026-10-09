import '../repositories/history_repository.dart';

class ClearHistory {
  ClearHistory(this._repository);

  final HistoryRepository _repository;

  Future<void> call() async {
    await _repository.clearHistory();
  }
}
