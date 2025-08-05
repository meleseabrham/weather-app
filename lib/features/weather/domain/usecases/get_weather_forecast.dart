import '../../../../core/utils/result.dart';
import '../entities/forecast_entity.dart';
import '../repositories/weather_repository.dart';

class GetWeatherForecast {
  final WeatherRepository repository;

  GetWeatherForecast(this.repository);

  Future<Result<ForecastEntity>> call({
    required double latitude,
    required double longitude,
    String? cityName,
    String units = 'metric',
  }) async {
    return await repository.getWeatherForecast(
      latitude: latitude,
      longitude: longitude,
      cityName: cityName,
      units: units,
    );
  }

  Future<Result<ForecastEntity>> callByCity({
    required String cityName,
    String units = 'metric',
  }) async {
    return await repository.getForecastByCity(
      cityName: cityName,
      units: units,
    );
  }
} 