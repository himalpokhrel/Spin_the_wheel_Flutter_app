import '../entities/wheel.dart';
import '../repositories/wheel_repository.dart';

class GetWheels {
  GetWheels(this._repository);

  final WheelRepository _repository;

  Future<List<Wheel>> call() async {
    return await _repository.getWheels();
  }
}
