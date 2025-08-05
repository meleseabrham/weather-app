import '../../../../core/utils/result.dart';
import '../entities/weather_entity.dart';
import '../entities/forecast_entity.dart';

abstract class WeatherRepository {
  Future<Result<WeatherEntity>> getCurrentWeather({
    required double latitude,
    required double longitude,
    String? cityName,
    String units = 'metric',
  });

  Future<Result<ForecastEntity>> getWeatherForecast({
    required double latitude,
    required double longitude,
    String? cityName,
    String units = 'metric',
  });

  Future<Result<WeatherEntity>> getWeatherByCity({
    required String cityName,
    String units = 'metric',
  });

  Future<Result<ForecastEntity>> getForecastByCity({
    required String cityName,
    String units = 'metric',
  });
} 