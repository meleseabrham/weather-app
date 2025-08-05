import 'package:flutter/material.dart';
import '../../../../core/utils/result.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/weather_entity.dart';
import '../../domain/entities/forecast_entity.dart';
import '../../domain/usecases/get_current_weather.dart';
import '../../domain/usecases/get_weather_forecast.dart';
import '../../../location/data/services/location_service.dart';
import '../../../location/domain/entities/location_entity.dart';
import '../../../location/data/exceptions/location_exception.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../data/services/city_search_service.dart';
import '../../data/services/nominatim_service.dart';

enum WeatherStatus { initial, loading, success, error }

class WeatherProvider extends ChangeNotifier {
  final GetCurrentWeather getCurrentWeather;
  final GetWeatherForecast getWeatherForecast;
  final LocationService locationService;
  final ConnectivityService connectivityService;
  final CitySearchService citySearchService;
  final NominatimService nominatimService;

  WeatherProvider({
    required this.getCurrentWeather,
    required this.getWeatherForecast,
    required this.locationService,
    required this.connectivityService,
    required this.citySearchService,
    required this.nominatimService,
  });

  WeatherStatus _status = WeatherStatus.initial;
  WeatherEntity? _currentWeather;
  ForecastEntity? _forecast;
  String? _errorMessage;
  String _units = 'metric';
  LocationEntity? _currentLocation;

  WeatherStatus get status => _status;
  WeatherEntity? get currentWeather => _currentWeather;
  ForecastEntity? get forecast => _forecast;
  String? get errorMessage => _errorMessage;
  String get units => _units;
  LocationEntity? get currentLocation => _currentLocation;

  Future<void> setUnits(String units) async {
    if (_units != units) {
      _units = units;
      
      // Check if we have current location weather
      if (_currentLocation != null) {
        // Refresh current location weather with new units
        await fetchCurrentLocationWeather();
      } else if (_currentWeather != null) {
        // Refresh city weather with new units
        await fetchWeatherByCity(_currentWeather!.cityName);
        await fetchForecastByCity(_currentWeather!.cityName);
      } else {
        // No weather data available, check if location services are enabled
        bool locationEnabled = await locationService.isLocationServiceEnabled();
        if (!locationEnabled) {
          _setError('Your device location is off. Please enable location services to get weather for your current location.');
          return;
        }
        
        // Try to get current location
        await fetchCurrentLocationWeather();
      }
      
      notifyListeners();
    }
  }

  Future<void> fetchWeatherByLocation({
    required double latitude,
    required double longitude,
    String? cityName,
  }) async {
    _setStatus(WeatherStatus.loading);
    _clearError();

    final weatherResult = await getCurrentWeather(
      latitude: latitude,
      longitude: longitude,
      cityName: cityName,
      units: _units,
    );

    weatherResult.fold(
      (weather) {
        _currentWeather = weather;
        _setStatus(WeatherStatus.success);
      },
      (failure) {
        _setError(failure.message);
      },
    );
  }

  Future<void> fetchForecastByLocation({
    required double latitude,
    required double longitude,
    String? cityName,
  }) async {
    _setStatus(WeatherStatus.loading);
    _clearError();

    final forecastResult = await getWeatherForecast(
      latitude: latitude,
      longitude: longitude,
      cityName: cityName,
      units: _units,
    );

    forecastResult.fold(
      (forecast) {
        _forecast = forecast;
        _setStatus(WeatherStatus.success);
      },
      (failure) {
        _setError(failure.message);
      },
    );
  }

  Future<void> fetchWeatherByCity(String cityName) async {
    print('Fetching weather for city: $cityName'); // Debug log
    _setStatus(WeatherStatus.loading);
    _clearError();

    try {
      // Check network connectivity first
      bool isConnected = await connectivityService.isConnected();
      if (!isConnected) {
        _setError('No Internet Connection: Please check your internet connection and try again.');
        return;
      }

      // Validate city exists first
      bool cityExists = await citySearchService.validateCity(cityName);
      if (!cityExists) {
        _setError('City not found: "$cityName" was not found. Please check the spelling or try a different city name.');
        return;
      }

      final weatherResult = await getCurrentWeather.callByCity(
        cityName: cityName,
        units: _units,
      );

      weatherResult.fold(
        (weather) {
          print('Weather data received for: ${weather.cityName}'); // Debug log
          _currentWeather = weather;
          _setStatus(WeatherStatus.success);
        },
        (failure) {
          print('Weather fetch failed: ${failure.message}'); // Debug log
          // Check if it's a 404 error (city not found)
          if (failure.message.contains('404') || failure.message.contains('not found')) {
            _setError('City not found: "$cityName" was not found. Please check the spelling or try a different city name.');
          } else {
            _setError(failure.message);
          }
        },
      );
    } catch (e) {
      print('Weather fetch error: ${e.toString()}'); // Debug log
      if (e.toString().contains('404')) {
        _setError('City not found: "$cityName" was not found. Please check the spelling or try a different city name.');
      } else {
        _setError('Failed to fetch weather data: ${e.toString()}');
      }
    }
  }

  Future<void> fetchForecastByCity(String cityName) async {
    print('Fetching forecast for city: $cityName'); // Debug log
    _setStatus(WeatherStatus.loading);
    _clearError();

    try {
      // Check network connectivity first
      bool isConnected = await connectivityService.isConnected();
      if (!isConnected) {
        _setError('No Internet Connection: Please check your internet connection and try again.');
        return;
      }

      final forecastResult = await getWeatherForecast.callByCity(
        cityName: cityName,
        units: _units,
      );

      forecastResult.fold(
        (forecast) {
          print('Forecast data received for: ${forecast.cityName}'); // Debug log
          _forecast = forecast;
          _setStatus(WeatherStatus.success);
        },
        (failure) {
          print('Forecast fetch failed: ${failure.message}'); // Debug log
          // Check if it's a 404 error (city not found)
          if (failure.message.contains('404') || failure.message.contains('not found')) {
            _setError('City not found: "$cityName" was not found. Please check the spelling or try a different city name.');
          } else {
            _setError(failure.message);
          }
        },
      );
    } catch (e) {
      _setError('Failed to fetch forecast data: ${e.toString()}');
    }
  }

  void _setStatus(WeatherStatus status) {
    _status = status;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _status = WeatherStatus.error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  /// Fetch weather for current location
  Future<void> fetchCurrentLocationWeather() async {
    print('Fetching current location weather...'); // Debug log
    _setStatus(WeatherStatus.loading);
    _clearError();

    try {
      // Check network connectivity first
      bool isConnected = await connectivityService.isConnected();
      if (!isConnected) {
        _setError('No Internet Connection: Please check your internet connection and try again.');
        return;
      }

      // Get current location
      _currentLocation = await locationService.getCurrentLocation();
      print('Current location: ${_currentLocation!.cityName}'); // Debug log

      // Fetch weather for current location
      final weatherResult = await getCurrentWeather(
        latitude: _currentLocation!.latitude,
        longitude: _currentLocation!.longitude,
        cityName: _currentLocation!.cityName,
        units: _units,
      );

      weatherResult.fold(
        (weather) {
          print('Current location weather received for: ${weather.cityName}'); // Debug log
          _currentWeather = weather;
          _setStatus(WeatherStatus.success);
        },
        (failure) {
          print('Current location weather fetch failed: ${failure.message}'); // Debug log
          _setError(failure.message);
        },
      );

      // Fetch forecast for current location
      final forecastResult = await getWeatherForecast(
        latitude: _currentLocation!.latitude,
        longitude: _currentLocation!.longitude,
        cityName: _currentLocation!.cityName,
        units: _units,
      );

      forecastResult.fold(
        (forecast) {
          print('Current location forecast received for: ${forecast.cityName}'); // Debug log
          _forecast = forecast;
        },
        (failure) {
          print('Current location forecast fetch failed: ${failure.message}'); // Debug log
          // Don't set error for forecast failure, just log it
        },
      );
    } catch (e) {
      print('Current location weather error: ${e.toString()}'); // Debug log
      
      if (e is LocationException) {
        _setError('${e.errorTitle}: ${e.userMessage}');
      } else {
        _setError('Failed to get current location weather: ${e.toString()}');
      }
    }
  }

  /// Enable location services and fetch weather automatically
  Future<void> enableLocationAndFetchWeather() async {
    print('Enabling location and fetching weather...'); // Debug log
    _setStatus(WeatherStatus.loading);
    _clearError();

    try {
      // Check network connectivity first
      bool isConnected = await connectivityService.isConnected();
      if (!isConnected) {
        _setError('No Internet Connection: Please check your internet connection and try again.');
        return;
      }

      // Enable location services and get current location
      _currentLocation = await locationService.enableLocationAndGetCurrentLocation();
      print('Location enabled and current location: ${_currentLocation!.cityName}'); // Debug log

      // Fetch weather for current location
      final weatherResult = await getCurrentWeather(
        latitude: _currentLocation!.latitude,
        longitude: _currentLocation!.longitude,
        cityName: _currentLocation!.cityName,
        units: _units,
      );

      weatherResult.fold(
        (weather) {
          print('Current location weather received for: ${weather.cityName}'); // Debug log
          _currentWeather = weather;
          _setStatus(WeatherStatus.success);
        },
        (failure) {
          print('Current location weather fetch failed: ${failure.message}'); // Debug log
          _setError(failure.message);
        },
      );

      // Fetch forecast for current location
      final forecastResult = await getWeatherForecast(
        latitude: _currentLocation!.latitude,
        longitude: _currentLocation!.longitude,
        cityName: _currentLocation!.cityName,
        units: _units,
      );

      forecastResult.fold(
        (forecast) {
          print('Current location forecast received for: ${forecast.cityName}'); // Debug log
          _forecast = forecast;
        },
        (failure) {
          print('Current location forecast fetch failed: ${failure.message}'); // Debug log
          // Don't set error for forecast failure, just log it
        },
      );
    } catch (e) {
      print('Enable location and fetch weather error: ${e.toString()}'); // Debug log
      
      if (e is LocationException) {
        _setError('${e.errorTitle}: ${e.userMessage}');
      } else {
        _setError('Failed to enable location and get weather: ${e.toString()}');
      }
    }
  }

  /// Fetch weather by coordinates (from Google Places API)
  Future<void> fetchWeatherByCoordinates(double latitude, double longitude, String placeName) async {
    try {
      _setStatus(WeatherStatus.loading);
      
      print('Fetching weather for coordinates: $latitude, $longitude ($placeName)');
      
      // Fetch current weather by coordinates
      final weatherResult = await getCurrentWeather(
        latitude: latitude,
        longitude: longitude,
        cityName: placeName,
        units: _units,
      );
      
      if (weatherResult.isSuccess) {
        final weather = weatherResult.data!;
        // Create a new weather entity with the updated city name from Google Places
        final updatedWeather = WeatherEntity(
          temperature: weather.temperature,
          feelsLike: weather.feelsLike,
          minTemperature: weather.minTemperature,
          maxTemperature: weather.maxTemperature,
          humidity: weather.humidity,
          pressure: weather.pressure,
          windSpeed: weather.windSpeed,
          windDirection: weather.windDirection,
          description: weather.description,
          icon: weather.icon,
          main: weather.main,
          visibility: weather.visibility,
          rain: weather.rain,
          snow: weather.snow,
          clouds: weather.clouds,
          dateTime: weather.dateTime,
          cityName: placeName, // Use the place name from Google Places
          countryCode: weather.countryCode,
          latitude: weather.latitude,
          longitude: weather.longitude,
        );
        
        // Fetch forecast by coordinates
        final forecastResult = await getWeatherForecast(
          latitude: latitude,
          longitude: longitude,
          cityName: placeName,
          units: _units,
        );
        
        if (forecastResult.isSuccess) {
          _currentWeather = updatedWeather;
          _forecast = forecastResult.data!;
          _setStatus(WeatherStatus.success);
          print('Weather data received for coordinates: $latitude, $longitude ($placeName)');
        } else {
          _setError(forecastResult.failure!.message);
        }
      } else {
        _setError(weatherResult.failure!.message);
      }
    } catch (e) {
      _setError('Failed to fetch weather: ${e.toString()}');
    }
  }

  void reset() {
    _status = WeatherStatus.initial;
    _currentWeather = null;
    _forecast = null;
    _errorMessage = null;
    _currentLocation = null;
    notifyListeners();
  }
} 
