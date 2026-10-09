import '../entities/wheel.dart';
import '../repositories/wheel_repository.dart';

class SaveWheel {
  SaveWheel(this._repository);

  final WheelRepository _repository;

  Future<void> call(Wheel wheel) async {
    return await _repository.saveWheel(wheel);
  }
}
