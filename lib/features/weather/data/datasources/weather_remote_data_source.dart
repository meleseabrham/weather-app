import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';

abstract class WeatherRemoteDataSource {
  Future<Result<WeatherModel>> getCurrentWeather({
    required double latitude,
    required double longitude,
    String? cityName,
    String units = 'metric',
  });

  Future<Result<ForecastModel>> getWeatherForecast({
    required double latitude,
    required double longitude,
    String? cityName,
    String units = 'metric',
  });

  Future<Result<WeatherModel>> getWeatherByCity({
    required String cityName,
    String units = 'metric',
  });

  Future<Result<ForecastModel>> getForecastByCity({
    required String cityName,
    String units = 'metric',
  });
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final Dio dio;

  WeatherRemoteDataSourceImpl({required this.dio});

  @override
  Future<Result<WeatherModel>> getCurrentWeather({
    required double latitude,
    required double longitude,
    String? cityName,
    String units = 'metric',
  }) async {
    try {
      final queryParams = {
        'lat': latitude.toString(),
        'lon': longitude.toString(),
        'appid': AppConstants.apiKey,
        'units': units,
      };

      final response = await dio.get(
        '${AppConstants.baseUrl}${AppConstants.weatherEndpoint}',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 && response.data != null) {
        try { final weatherModel = WeatherModel.fromJson(response.data);
        return Success(weatherModel); } catch (e) { return ResultFailure(ServerFailure("Invalid weather data format: ${e.toString()}")); }
      } else {
        return const ResultFailure(ServerFailure('Failed to fetch weather data'));
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return const ResultFailure(NetworkFailure('Connection timeout'));
      } else if (e.type == DioExceptionType.connectionError) {
        return const ResultFailure(NetworkFailure('No internet connection'));
      } else {
        return ResultFailure(ServerFailure(e.message ?? 'Unknown error occurred'));
      }
    } catch (e) {
      return ResultFailure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<ForecastModel>> getWeatherForecast({
    required double latitude,
    required double longitude,
    String? cityName,
    String units = 'metric',
  }) async {
    try {
      final queryParams = {
        'lat': latitude.toString(),
        'lon': longitude.toString(),
        'appid': AppConstants.apiKey,
        'units': units,
      };

      final response = await dio.get(
        '${AppConstants.baseUrl}${AppConstants.forecastEndpoint}',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 && response.data != null) {
        final forecastModel = ForecastModel.fromJson(response.data);
        return Success(forecastModel);
      } else {
        return const ResultFailure(ServerFailure('Failed to fetch forecast data'));
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return const ResultFailure(NetworkFailure('Connection timeout'));
      } else if (e.type == DioExceptionType.connectionError) {
        return const ResultFailure(NetworkFailure('No internet connection'));
      } else {
        return ResultFailure(ServerFailure(e.message ?? 'Unknown error occurred'));
      }
    } catch (e) {
      return ResultFailure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<WeatherModel>> getWeatherByCity({
    required String cityName,
    String units = 'metric',
  }) async {
    try {
      final queryParams = {
        'q': cityName,
        'appid': AppConstants.apiKey,
        'units': units,
      };

      final response = await dio.get(
        '${AppConstants.baseUrl}${AppConstants.weatherEndpoint}',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 && response.data != null) {
        try { final weatherModel = WeatherModel.fromJson(response.data);
        return Success(weatherModel); } catch (e) { return ResultFailure(ServerFailure("Invalid weather data format: ${e.toString()}")); }
      } else {
        return const ResultFailure(ServerFailure('Failed to fetch weather data'));
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return const ResultFailure(NetworkFailure('Connection timeout'));
      } else if (e.type == DioExceptionType.connectionError) {
        return const ResultFailure(NetworkFailure('No internet connection'));
      } else {
        return ResultFailure(ServerFailure(e.message ?? 'Unknown error occurred'));
      }
    } catch (e) {
      return ResultFailure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<ForecastModel>> getForecastByCity({
    required String cityName,
    String units = 'metric',
  }) async {
    try {
      final queryParams = {
        'q': cityName,
        'appid': AppConstants.apiKey,
        'units': units,
      };

      final response = await dio.get(
        '${AppConstants.baseUrl}${AppConstants.forecastEndpoint}',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 && response.data != null) {
        final forecastModel = ForecastModel.fromJson(response.data);
        return Success(forecastModel);
      } else {
        return const ResultFailure(ServerFailure('Failed to fetch forecast data'));
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return const ResultFailure(NetworkFailure('Connection timeout'));
      } else if (e.type == DioExceptionType.connectionError) {
        return const ResultFailure(NetworkFailure('No internet connection'));
      } else {
        return ResultFailure(ServerFailure(e.message ?? 'Unknown error occurred'));
      }
    } catch (e) {
      return ResultFailure(ServerFailure(e.toString()));
    }
  }
} 
