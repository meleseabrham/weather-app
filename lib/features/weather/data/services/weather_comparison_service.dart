import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';

class WeatherComparisonService {
  final Dio _dio;

  WeatherComparisonService(this._dio);

  /// Get weather data from multiple sources for comparison
  Future<Map<String, dynamic>> getWeatherComparison(String cityName) async {
    try {
      // Get OpenWeatherMap data (your current source)
      final openWeatherData = await _getOpenWeatherData(cityName);
      
      // You could add other weather APIs here
      // For example: WeatherAPI, AccuWeather, etc.
      
      return {
        'openWeatherMap': openWeatherData,
        'timestamp': DateTime.now().toIso8601String(),
        'city': cityName,
      };
    } catch (e) {
      print('Error getting weather comparison: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> _getOpenWeatherData(String cityName) async {
    try {
      final response = await _dio.get(
        'https://api.openweathermap.org/data/2.5/weather',
        queryParameters: {
          'q': cityName,
          'appid': AppConstants.apiKey,
          'units': 'metric',
        },
      );

      if (response.statusCode == 200) {
        return {
          'temperature': response.data['main']['temp'],
          'feels_like': response.data['main']['feels_like'],
          'humidity': response.data['main']['humidity'],
          'description': response.data['weather'][0]['description'],
          'icon': response.data['weather'][0]['icon'],
          'wind_speed': response.data['wind']['speed'],
          'pressure': response.data['main']['pressure'],
          'visibility': response.data['visibility'],
          'last_updated': DateTime.now().toIso8601String(),
        };
      }
      return {};
    } catch (e) {
      print('Error getting OpenWeatherMap data: $e');
      return {};
    }
  }

  /// Get weather accuracy information
  String getAccuracyInfo() {
    return '''
Weather Data Source: OpenWeatherMap API

Accuracy Information:
• Updates every 10-15 minutes
• Uses multiple weather models
• Data from weather stations worldwide
• May differ from other sources due to:
  - Different forecasting models
  - Update frequency variations
  - Location precision differences
  - Microclimate variations

For the most accurate local weather, consider:
• Checking multiple weather apps
• Using local weather stations
• Considering the time of data update
''';
  }
} 