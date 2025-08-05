import '../../../../core/utils/result.dart';
import '../entities/location_entity.dart';
import '../repositories/location_repository.dart';

class GetCurrentLocation {
  final LocationRepository repository;

  GetCurrentLocation(this.repository);

  Future<Result<LocationEntity>> call() async {
    return await repository.getCurrentLocation();
  }
} 