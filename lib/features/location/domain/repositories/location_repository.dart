import '../../../../core/utils/result.dart';
import '../entities/location_entity.dart';

abstract class LocationRepository {
  Future<Result<LocationEntity>> getCurrentLocation();
  
  Future<Result<LocationEntity>> getLocationByCity(String cityName);
  
  Future<Result<List<LocationEntity>>> searchLocations(String query);
  
  Future<Result<bool>> requestLocationPermission();
  
  Future<Result<bool>> isLocationServiceEnabled();
} 