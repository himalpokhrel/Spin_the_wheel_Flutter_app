import '../../domain/entities/wheel.dart';
import '../../domain/repositories/wheel_repository.dart';
import '../datasources/wheel_local_datasource.dart';
import '../models/wheel_model.dart';

class WheelRepositoryImpl implements WheelRepository {
  WheelRepositoryImpl(this._localDataSource);

  final WheelLocalDataSource _localDataSource;

  @override
  Future<List<Wheel>> getWheels() async {
    try {
      return await _localDataSource.getWheels();
    } catch (e) {
      throw Exception('Failed to get wheels: $e');
    }
  }

  @override
  Future<void> saveWheel(Wheel wheel) async {
    try {
      // Get all wheels
      final wheels = await _localDataSource.getWheels();
      
      // Check if wheel exists (update) or add new
      final index = wheels.indexWhere((w) => w.id == wheel.id);
      
      if (index != -1) {
        // Update existing wheel
        wheels[index] = WheelModel.fromEntity(wheel);
      } else {
        // Add new wheel
        wheels.add(WheelModel.fromEntity(wheel));
      }
      
      // Save all wheels
      await _localDataSource.saveWheels(wheels);
    } catch (e) {
      throw Exception('Failed to save wheel: $e');
    }
  }

  @override
  Future<void> deleteWheel(String id) async {
    try {
      // Get all wheels
      final wheels = await _localDataSource.getWheels();
      
      // Remove the wheel with matching id
      wheels.removeWhere((wheel) => wheel.id == id);
      
      // Save updated list
      await _localDataSource.saveWheels(wheels);
    } catch (e) {
      throw Exception('Failed to delete wheel: $e');
    }
  }
}
