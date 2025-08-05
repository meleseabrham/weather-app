import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  // API Configuration
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  static String get apiKey => dotenv.env['OPENWEATHER_API_KEY'] ?? 'demo';
  static const String weatherEndpoint = '/weather';
  static const String forecastEndpoint = '/forecast';
  
  // App Configuration
  static const String appName = 'Weather App';
  static const String appVersion = '1.0.0';
  
  // Storage Keys
  static const String lastLocationKey = 'last_location';
  static const String themeKey = 'theme_mode';
  static const String unitsKey = 'units';
  
  // Default Values
  static const String defaultCity = 'London';
  static const String defaultUnits = 'metric';
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Weather Icons Base URL
  static const String weatherIconBaseUrl = 'https://openweathermap.org/img/wn/';
  static const String weatherIconSuffix = '@2x.png';
} 