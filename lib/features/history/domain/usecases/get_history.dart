import '../entities/spin_history.dart';
import '../repositories/history_repository.dart';

class GetHistory {
  GetHistory(this._repository);

  final HistoryRepository _repository;

  Future<List<SpinHistory>> call() async {
    return await _repository.getHistory();
  }
}
