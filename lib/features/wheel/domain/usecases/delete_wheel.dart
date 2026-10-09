import '../repositories/wheel_repository.dart';

class DeleteWheel {
  DeleteWheel(this._repository);

  final WheelRepository _repository;

  Future<void> call(String id) async {
    return await _repository.deleteWheel(id);
  }
}
