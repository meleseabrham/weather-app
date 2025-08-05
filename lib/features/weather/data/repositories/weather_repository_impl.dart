import '../../../../core/utils/result.dart';
import '../../domain/entities/weather_entity.dart';
import '../../domain/entities/forecast_entity.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/weather_remote_data_source.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;

  WeatherRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<WeatherEntity>> getCurrentWeather({
    required double latitude,
    required double longitude,
    String? cityName,
    String units = 'metric',
  }) async {
    final result = await remoteDataSource.getCurrentWeather(
      latitude: latitude,
      longitude: longitude,
      cityName: cityName,
      units: units,
    );

    return result.fold(
      (weatherModel) => Success(weatherModel),
      (failure) => ResultFailure(failure),
    );
  }

  @override
  Future<Result<ForecastEntity>> getWeatherForecast({
    required double latitude,
    required double longitude,
    String? cityName,
    String units = 'metric',
  }) async {
    final result = await remoteDataSource.getWeatherForecast(
      latitude: latitude,
      longitude: longitude,
      cityName: cityName,
      units: units,
    );

    return result.fold(
      (forecastModel) => Success(forecastModel),
      (failure) => ResultFailure(failure),
    );
  }

  @override
  Future<Result<WeatherEntity>> getWeatherByCity({
    required String cityName,
    String units = 'metric',
  }) async {
    final result = await remoteDataSource.getWeatherByCity(
      cityName: cityName,
      units: units,
    );

    return result.fold(
      (weatherModel) => Success(weatherModel),
      (failure) => ResultFailure(failure),
    );
  }

  @override
  Future<Result<ForecastEntity>> getForecastByCity({
    required String cityName,
    String units = 'metric',
  }) async {
    final result = await remoteDataSource.getForecastByCity(
      cityName: cityName,
      units: units,
    );

    return result.fold(
      (forecastModel) => Success(forecastModel),
      (failure) => ResultFailure(failure),
    );
  }
} 