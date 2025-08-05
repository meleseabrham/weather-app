import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/theme_constants.dart';
import '../../../../core/services/weather_background_service.dart';
import '../../domain/entities/forecast_entity.dart';

class WeatherForecastList extends StatelessWidget {
  final ForecastEntity forecast;

  const WeatherForecastList({
    super.key,
    required this.forecast,
  });

  @override
  Widget build(BuildContext context) {
    // Group forecasts by day
    final dailyForecasts = _groupForecastsByDay();

    return Container(
      padding: const EdgeInsets.all(ThemeConstants.spacingL),
      decoration: BoxDecoration(
        color: ThemeConstants.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusL),
        border: Border.all(
          color: ThemeConstants.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '5-Day Forecast',
            style: ThemeConstants.heading3.copyWith(
              color: ThemeConstants.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: ThemeConstants.spacingL),
          Column(
            children: dailyForecasts.map((dayForecast) {
              return Padding(
                padding: const EdgeInsets.only(bottom: ThemeConstants.spacingM),
                child: _buildForecastItem(dayForecast),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildForecastItem(Map<String, dynamic> dayForecast) {
    final date = dayForecast['date'] as DateTime;
    final weather = dayForecast['weather'];
    final minTemp = dayForecast['minTemp'] as double;
    final maxTemp = dayForecast['maxTemp'] as double;
    final icon = dayForecast['icon'] as String;
    final description = dayForecast['description'] as String;

    // Get dynamic background based on average temperature and weather condition
    final avgTemp = (minTemp + maxTemp) / 2;
    final isNight = WeatherBackgroundService.isNightTime();
    final backgroundGradient = WeatherBackgroundService.getForecastItemBackground(
      description, 
      avgTemp, 
      isNight: isNight
    );

    return Container(
      padding: const EdgeInsets.all(ThemeConstants.spacingM),
      decoration: BoxDecoration(
        gradient: backgroundGradient,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusM),
        border: Border.all(
          color: ThemeConstants.white.withOpacity(0.4),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Date and Day Info Row
          Row(
            children: [
              // Weather Icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: ThemeConstants.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusS),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusS),
                  child: Image.network(
                    '${AppConstants.weatherIconBaseUrl}$icon${AppConstants.weatherIconSuffix}',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        _getWeatherIcon(description),
                        size: 30,
                        color: ThemeConstants.white,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: ThemeConstants.spacingM),
              
              // Date and Day Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('EEEE').format(date), // Full day name
                      style: ThemeConstants.bodyMedium.copyWith(
                        color: ThemeConstants.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      DateFormat('MMM d, yyyy').format(date), // Full date
                      style: ThemeConstants.bodySmall.copyWith(
                        color: ThemeConstants.white.withOpacity(0.85),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Temperature Range
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${maxTemp.round()}°',
                    style: ThemeConstants.heading3.copyWith(
                      color: ThemeConstants.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    '${minTemp.round()}°',
                    style: ThemeConstants.bodyMedium.copyWith(
                      color: ThemeConstants.white.withOpacity(0.85),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: ThemeConstants.spacingM),
          
          // Weather Condition Button (like the image)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: ThemeConstants.spacingS),
            decoration: BoxDecoration(
              color: ThemeConstants.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusM),
              border: Border.all(
                color: ThemeConstants.white.withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Text(
              description.toUpperCase(),
              style: ThemeConstants.bodyMedium.copyWith(
                color: ThemeConstants.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          const SizedBox(height: ThemeConstants.spacingS),
          
          // Temperature indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: ThemeConstants.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: ThemeConstants.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              _getTemperatureLabel(avgTemp),
              style: ThemeConstants.bodySmall.copyWith(
                color: ThemeConstants.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getTemperatureLabel(double temperature) {
    if (temperature < 0) return 'VERY COLD';
    if (temperature < 10) return 'COLD';
    if (temperature < 20) return 'COOL';
    if (temperature < 25) return 'MILD';
    if (temperature < 30) return 'WARM';
    if (temperature < 35) return 'HOT';
    return 'VERY HOT';
  }

  List<Map<String, dynamic>> _groupForecastsByDay() {
    final Map<String, Map<String, dynamic>> dailyData = {};
    final now = DateTime.now();

    for (final weather in forecast.forecasts) {
      final dateKey = DateFormat('yyyy-MM-dd').format(weather.dateTime);
      
      // Skip forecasts that are too close to current time (within 3 hours)
      if (weather.dateTime.difference(now).inHours < 3) {
        continue;
      }
      
      if (!dailyData.containsKey(dateKey)) {
        dailyData[dateKey] = {
          'date': weather.dateTime,
          'minTemp': weather.minTemperature,
          'maxTemp': weather.maxTemperature,
          'weather': weather,
          'icon': weather.icon,
          'description': weather.description,
        };
      } else {
        // Update min/max temperatures
        final existing = dailyData[dateKey]!;
        if (weather.minTemperature < existing['minTemp']) {
          existing['minTemp'] = weather.minTemperature;
        }
        if (weather.maxTemperature > existing['maxTemp']) {
          existing['maxTemp'] = weather.maxTemperature;
        }
      }
    }

    // Convert to list and sort by date
    final sortedForecasts = dailyData.values.toList()
      ..sort((a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime));

    // Take only the next 5 days
    return sortedForecasts.take(5).toList();
  }

  IconData _getWeatherIcon(String description) {
    final desc = description.toLowerCase();
    if (desc.contains('clear')) return Icons.wb_sunny;
    if (desc.contains('cloud')) return Icons.cloud;
    if (desc.contains('rain') || desc.contains('drizzle')) return Icons.grain;
    if (desc.contains('snow')) return Icons.ac_unit;
    if (desc.contains('thunder')) return Icons.flash_on;
    if (desc.contains('mist') || desc.contains('fog')) return Icons.cloud;
    return Icons.wb_sunny;
  }
} 