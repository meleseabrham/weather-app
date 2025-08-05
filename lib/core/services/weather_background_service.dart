import 'package:flutter/material.dart';

class WeatherBackgroundService {
  /// Get dynamic background gradient based on weather condition
  static LinearGradient getWeatherBackground(String weatherCondition, {bool isNight = false}) {
    final condition = weatherCondition.toLowerCase();
    
    // Enhanced OpenWeatherMap themed colors
    const openWeatherOrange = Color(0xFFFF6B35);
    const openWeatherBlue = Color(0xFF4A90E2);
    const openWeatherDarkBlue = Color(0xFF2C3E50);
    const openWeatherLightBlue = Color(0xFF87CEEB);
    const openWeatherYellow = Color(0xFFFFD700);
    const openWeatherGray = Color(0xFF708090);
    const openWeatherPurple = Color(0xFF8A2BE2);
    const openWeatherGreen = Color(0xFF32CD32);
    const openWeatherRainBlue = Color(0xFF5B9BD5);
    const openWeatherRainDark = Color(0xFF2E5984);
    const openWeatherSunnyYellow = Color(0xFFFFB347);
    const openWeatherSunnyOrange = Color(0xFFFF8C42);
    const openWeatherCloudGray = Color(0xFFB8C6DB);
    const openWeatherStormPurple = Color(0xFF6A4C93);
    
    // Night colors
    const nightBlue = Color(0xFF1E3A8A);
    const nightPurple = Color(0xFF4C1D95);
    const nightDark = Color(0xFF0F172A);
    const nightRainBlue = Color(0xFF1E3A5F);
    
    if (isNight) {
      // Night backgrounds
      if (condition.contains('clear')) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [nightBlue, nightPurple, nightDark],
        );
      } else if (condition.contains('cloud') || condition.contains('overcast')) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [nightPurple, nightDark, nightDark],
        );
      } else if (condition.contains('light rain')) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [nightRainBlue, nightPurple, nightDark],
        );
      } else if (condition.contains('rain') || condition.contains('drizzle')) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [nightDark, nightPurple, nightDark],
        );
      } else if (condition.contains('snow')) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [nightBlue, nightDark, nightDark],
        );
      } else if (condition.contains('thunder') || condition.contains('storm')) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [nightDark, nightPurple, nightDark],
        );
      } else {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [nightBlue, nightPurple, nightDark],
        );
      }
    } else {
      // Day backgrounds with more specific conditions
      if (condition.contains('clear') || condition.contains('sunny')) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [openWeatherSunnyYellow, openWeatherSunnyOrange, openWeatherOrange],
        );
      } else if (condition.contains('partly cloudy') || condition.contains('scattered clouds')) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [openWeatherSunnyYellow, openWeatherCloudGray, openWeatherBlue],
        );
      } else if (condition.contains('cloud') || condition.contains('overcast')) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [openWeatherCloudGray, openWeatherGray, openWeatherDarkBlue],
        );
      } else if (condition.contains('light rain') || condition.contains('drizzle')) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [openWeatherRainBlue, openWeatherBlue, openWeatherRainDark],
        );
      } else if (condition.contains('moderate rain')) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [openWeatherBlue, openWeatherRainDark, openWeatherPurple],
        );
      } else if (condition.contains('heavy rain') || condition.contains('shower rain')) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [openWeatherRainDark, openWeatherPurple, Colors.black],
        );
      } else if (condition.contains('snow')) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, openWeatherLightBlue, openWeatherBlue],
        );
      } else if (condition.contains('thunder') || condition.contains('storm')) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [openWeatherStormPurple, openWeatherPurple, Colors.black],
        );
      } else if (condition.contains('mist') || condition.contains('fog')) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [openWeatherGray, openWeatherLightBlue, openWeatherBlue],
        );
      } else if (condition.contains('haze') || condition.contains('smoke')) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [openWeatherGray, openWeatherYellow, openWeatherOrange],
        );
      } else if (condition.contains('dust') || condition.contains('sand')) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [openWeatherYellow, openWeatherSunnyOrange, openWeatherGray],
        );
      } else if (condition.contains('ash') || condition.contains('volcanic')) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [openWeatherGray, openWeatherPurple, Colors.black],
        );
      } else if (condition.contains('tornado') || condition.contains('squall')) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [openWeatherStormPurple, openWeatherPurple, Colors.black],
        );
      } else {
        // Default OpenWeatherMap theme
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [openWeatherOrange, openWeatherBlue, openWeatherDarkBlue],
        );
      }
    }
  }

  /// Get background gradient for forecast items based on temperature and weather condition
  static LinearGradient getForecastItemBackground(String weatherCondition, double temperature, {bool isNight = false}) {
    final condition = weatherCondition.toLowerCase();
    
    // Temperature-based colors
    const veryCold = Color(0xFF87CEEB); // Light blue for very cold
    const cold = Color(0xFF5B9BD5); // Blue for cold
    const cool = Color(0xFF4A90E2); // Light blue for cool
    const mild = Color(0xFF32CD32); // Green for mild
    const warm = Color(0xFFFFB347); // Orange for warm
    const hot = Color(0xFFFF6B35); // Red-orange for hot
    const veryHot = Color(0xFFDC143C); // Crimson for very hot
    
    // Weather condition colors
    const sunny = Color(0xFFFFD700); // Gold for sunny
    const cloudy = Color(0xFFB8C6DB); // Gray for cloudy
    const rainy = Color(0xFF5B9BD5); // Blue for rainy
    const snowy = Color(0xFFF0F8FF); // White for snowy
    const stormy = Color(0xFF6A4C93); // Purple for stormy
    
    // Determine base color based on temperature
    Color baseColor;
    if (temperature < 0) {
      baseColor = veryCold;
    } else if (temperature < 10) {
      baseColor = cold;
    } else if (temperature < 20) {
      baseColor = cool;
    } else if (temperature < 25) {
      baseColor = mild;
    } else if (temperature < 30) {
      baseColor = warm;
    } else if (temperature < 35) {
      baseColor = hot;
    } else {
      baseColor = veryHot;
    }
    
    // Determine weather color based on condition
    Color weatherColor;
    if (condition.contains('clear') || condition.contains('sunny')) {
      weatherColor = sunny;
    } else if (condition.contains('cloud') || condition.contains('overcast')) {
      weatherColor = cloudy;
    } else if (condition.contains('rain') || condition.contains('drizzle')) {
      weatherColor = rainy;
    } else if (condition.contains('snow')) {
      weatherColor = snowy;
    } else if (condition.contains('thunder') || condition.contains('storm')) {
      weatherColor = stormy;
    } else {
      weatherColor = baseColor;
    }
    
    // Create gradient based on temperature and weather
    if (temperature < 0) {
      // Very cold - blue to white gradient
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          veryCold.withOpacity(0.3),
          snowy.withOpacity(0.2),
          Colors.white.withOpacity(0.1),
        ],
      );
    } else if (temperature < 10) {
      // Cold - blue gradient
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          cold.withOpacity(0.3),
          cool.withOpacity(0.2),
          Colors.white.withOpacity(0.1),
        ],
      );
    } else if (temperature < 20) {
      // Cool - blue to green gradient
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          cool.withOpacity(0.3),
          mild.withOpacity(0.2),
          Colors.white.withOpacity(0.1),
        ],
      );
    } else if (temperature < 25) {
      // Mild - green gradient
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          mild.withOpacity(0.3),
          warm.withOpacity(0.2),
          Colors.white.withOpacity(0.1),
        ],
      );
    } else if (temperature < 30) {
      // Warm - orange gradient
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          warm.withOpacity(0.3),
          hot.withOpacity(0.2),
          Colors.white.withOpacity(0.1),
        ],
      );
    } else if (temperature < 35) {
      // Hot - red-orange gradient
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          hot.withOpacity(0.3),
          veryHot.withOpacity(0.2),
          Colors.white.withOpacity(0.1),
        ],
      );
    } else {
      // Very hot - crimson gradient
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          veryHot.withOpacity(0.3),
          Colors.red.withOpacity(0.2),
          Colors.white.withOpacity(0.1),
        ],
      );
    }
  }
  
  /// Get weather condition icon based on weather description
  static IconData getWeatherIcon(String weatherCondition) {
    final condition = weatherCondition.toLowerCase();
    
    if (condition.contains('clear') || condition.contains('sunny')) {
      return Icons.wb_sunny;
    } else if (condition.contains('cloud') || condition.contains('overcast')) {
      return Icons.cloud;
    } else if (condition.contains('rain') || condition.contains('drizzle')) {
      return Icons.grain;
    } else if (condition.contains('snow')) {
      return Icons.ac_unit;
    } else if (condition.contains('thunder') || condition.contains('storm')) {
      return Icons.flash_on;
    } else if (condition.contains('mist') || condition.contains('fog')) {
      return Icons.cloud;
    } else if (condition.contains('haze') || condition.contains('smoke')) {
      return Icons.cloud;
    } else if (condition.contains('dust') || condition.contains('sand')) {
      return Icons.grain;
    } else if (condition.contains('ash') || condition.contains('volcanic')) {
      return Icons.volcano;
    } else if (condition.contains('tornado') || condition.contains('squall')) {
      return Icons.air;
    } else {
      return Icons.wb_sunny;
    }
  }
  
  /// Check if it's night time based on current time
  static bool isNightTime() {
    final now = DateTime.now();
    final hour = now.hour;
    return hour < 6 || hour > 18; // Night time: 6 PM to 6 AM
  }
  
  /// Get OpenWeatherMap button background color
  static Color getOpenWeatherMapButtonColor() {
    return const Color(0xFFFF6B35).withOpacity(0.9); // OpenWeatherMap orange with transparency
  }
  
  /// Get OpenWeatherMap button text color
  static Color getOpenWeatherMapButtonTextColor() {
    return Colors.white;
  }
} 