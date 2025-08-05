import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/theme_constants.dart';
import '../../domain/entities/weather_entity.dart';
import 'weather_source_indicator.dart';

class WeatherHeader extends StatelessWidget {
  final WeatherEntity weather;

  const WeatherHeader({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.spacingM),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Location and Date
          Flexible(child: _buildLocationAndDate()),
          
          const SizedBox(height: ThemeConstants.spacingS),
          
          // Temperature and Weather Icon
          Flexible(child: _buildTemperatureAndIcon()),
          
          const SizedBox(height: ThemeConstants.spacingXS),
          
          // Weather Description
          Flexible(child: _buildWeatherDescription()),
          
          const SizedBox(height: ThemeConstants.spacingXS),
          
          // Data Source Indicator
          Flexible(child: WeatherSourceIndicator(lastUpdated: weather.dateTime)),
        ],
      ),
    );
  }

  Widget _buildLocationAndDate() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on,
              color: ThemeConstants.white.withOpacity(0.8),
              size: 14,
            ),
            const SizedBox(width: ThemeConstants.spacingXS),
            Flexible(
              child: Text(
                weather.cityName,
                style: ThemeConstants.heading1.copyWith(
                  color: ThemeConstants.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: ThemeConstants.spacingXS),
        Text(
          '${weather.cityName}, ${weather.countryCode}',
          style: ThemeConstants.bodyLarge.copyWith(
            color: ThemeConstants.white.withOpacity(0.8),
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: ThemeConstants.spacingXS),
        Text(
          DateFormat('EEEE, MMMM d').format(_getValidDate(weather.dateTime)),
          style: ThemeConstants.bodyMedium.copyWith(
            color: ThemeConstants.white.withOpacity(0.7),
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTemperatureAndIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Weather Icon
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: ThemeConstants.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusL),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(ThemeConstants.radiusL),
            child: Image.network(
              '${AppConstants.weatherIconBaseUrl}${weather.icon}${AppConstants.weatherIconSuffix}',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  _getWeatherIcon(weather.main),
                  size: 25,
                  color: ThemeConstants.white,
                );
              },
            ),
          ),
        ),
        
        const SizedBox(width: ThemeConstants.spacingM),
        
        // Temperature
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${weather.temperature.round()}°',
              style: ThemeConstants.heading1.copyWith(
                color: ThemeConstants.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Feels like ${weather.feelsLike.round()}°',
              style: ThemeConstants.bodyMedium.copyWith(
                color: ThemeConstants.white.withOpacity(0.8),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeatherDescription() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ThemeConstants.spacingM,
        vertical: ThemeConstants.spacingS,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.25),
            Colors.white.withOpacity(0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusL),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        weather.description.toUpperCase(),
        style: ThemeConstants.bodyLarge.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  DateTime _getValidDate(DateTime weatherDate) {
    final now = DateTime.now();
    final difference = now.difference(weatherDate).inDays.abs();
    
    // If the date difference is more than 7 days, use current date
    if (difference > 7) {
      print('Weather date seems incorrect: $weatherDate, using current date: $now'); // Debug log
      return now;
    }
    
    return weatherDate;
  }

  IconData _getWeatherIcon(String mainWeather) {
    switch (mainWeather.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
      case 'drizzle':
        return Icons.grain;
      case 'snow':
        return Icons.ac_unit;
      case 'thunderstorm':
        return Icons.flash_on;
      case 'mist':
      case 'fog':
        return Icons.cloud;
      default:
        return Icons.wb_sunny;
    }
  }
} 