import '../entities/wheel.dart';

abstract class WheelRepository {
  Future<List<Wheel>> getWheels();
  Future<void> saveWheel(Wheel wheel);
  Future<void> deleteWheel(String id);
}
