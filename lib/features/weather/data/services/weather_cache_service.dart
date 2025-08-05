import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart';
import '../models/weather_forecast_model.dart';

class WeatherCacheService {
  static const String _weatherCacheKey = 'weather_cache';
  static const String _forecastCacheKey = 'forecast_cache';
  static const String _searchCacheKey = 'search_cache';
  static const Duration _cacheExpiry = Duration(minutes: 10); // Cache for 10 minutes

  // Cache current weather data
  static Future<void> cacheWeatherData(String cityName, WeatherModel weather) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheData = {
      'cityName': cityName,
      'data': weather.toJson(),
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    await prefs.setString('${_weatherCacheKey}_$cityName', jsonEncode(cacheData));
  }

  // Get cached weather data
  static Future<WeatherModel?> getCachedWeatherData(String cityName) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedString = prefs.getString('${_weatherCacheKey}_$cityName');
    
    if (cachedString != null) {
      final cacheData = jsonDecode(cachedString);
      final timestamp = DateTime.fromMillisecondsSinceEpoch(cacheData['timestamp']);
      
      // Check if cache is still valid
      if (DateTime.now().difference(timestamp) < _cacheExpiry) {
        return WeatherModel.fromJson(cacheData['data']);
      }
    }
    return null;
  }

  // Cache forecast data
  static Future<void> cacheForecastData(String cityName, WeatherForecastModel forecast) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheData = {
      'cityName': cityName,
      'data': forecast.toJson(),
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    await prefs.setString('${_forecastCacheKey}_$cityName', jsonEncode(cacheData));
  }

  // Get cached forecast data
  static Future<WeatherForecastModel?> getCachedForecastData(String cityName) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedString = prefs.getString('${_forecastCacheKey}_$cityName');
    
    if (cachedString != null) {
      final cacheData = jsonDecode(cachedString);
      final timestamp = DateTime.fromMillisecondsSinceEpoch(cacheData['timestamp']);
      
      // Check if cache is still valid
      if (DateTime.now().difference(timestamp) < _cacheExpiry) {
        return WeatherForecastModel.fromJson(cacheData['data']);
      }
    }
    return null;
  }

  // Cache search suggestions
  static Future<void> cacheSearchSuggestions(String query, List<dynamic> suggestions) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheData = {
      'query': query,
      'suggestions': suggestions,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    await prefs.setString('${_searchCacheKey}_${query.toLowerCase()}', jsonEncode(cacheData));
  }

  // Get cached search suggestions
  static Future<List<dynamic>?> getCachedSearchSuggestions(String query) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedString = prefs.getString('${_searchCacheKey}_${query.toLowerCase()}');
    
    if (cachedString != null) {
      final cacheData = jsonDecode(cachedString);
      final timestamp = DateTime.fromMillisecondsSinceEpoch(cacheData['timestamp']);
      
      // Cache search suggestions for 1 hour
      if (DateTime.now().difference(timestamp) < const Duration(hours: 1)) {
        return cacheData['suggestions'];
      }
    }
    return null;
  }

  // Clear all cache
  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    
    for (final key in keys) {
      if (key.startsWith(_weatherCacheKey) || 
          key.startsWith(_forecastCacheKey) || 
          key.startsWith(_searchCacheKey)) {
        await prefs.remove(key);
      }
    }
  }

  // Get cache size info
  static Future<Map<String, int>> getCacheInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    
    int weatherCacheCount = 0;
    int forecastCacheCount = 0;
    int searchCacheCount = 0;
    
    for (final key in keys) {
      if (key.startsWith(_weatherCacheKey)) weatherCacheCount++;
      if (key.startsWith(_forecastCacheKey)) forecastCacheCount++;
      if (key.startsWith(_searchCacheKey)) searchCacheCount++;
    }
    
    return {
      'weather': weatherCacheCount,
      'forecast': forecastCacheCount,
      'search': searchCacheCount,
    };
  }
} 