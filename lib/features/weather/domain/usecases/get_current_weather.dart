import '../../../../core/utils/result.dart';
import '../entities/weather_entity.dart';
import '../repositories/weather_repository.dart';

class GetCurrentWeather {
  final WeatherRepository repository;

  GetCurrentWeather(this.repository);

  Future<Result<WeatherEntity>> call({
    required double latitude,
    required double longitude,
    String? cityName,
    String units = 'metric',
  }) async {
    return await repository.getCurrentWeather(
      latitude: latitude,
      longitude: longitude,
      cityName: cityName,
      units: units,
    );
  }

  Future<Result<WeatherEntity>> callByCity({
    required String cityName,
    String units = 'metric',
  }) async {
    return await repository.getWeatherByCity(
      cityName: cityName,
      units: units,
    );
  }
} 