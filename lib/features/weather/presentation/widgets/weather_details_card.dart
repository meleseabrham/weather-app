import 'package:flutter/material.dart';
import '../../../../core/constants/theme_constants.dart';
import '../../domain/entities/weather_entity.dart';

class WeatherDetailsCard extends StatelessWidget {
  final WeatherEntity weather;

  const WeatherDetailsCard({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
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
            'Weather Details',
            style: ThemeConstants.heading3.copyWith(
              color: ThemeConstants.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: ThemeConstants.spacingL),
          _buildDetailsGrid(),
        ],
      ),
    );
  }

  Widget _buildDetailsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            _buildDetailItem(
              icon: Icons.thermostat,
              title: 'Temperature',
              value: '${weather.temperature.round()}°',
              subtitle: 'Min: ${weather.minTemperature.round()}° | Max: ${weather.maxTemperature.round()}°',
            ),
            const SizedBox(height: ThemeConstants.spacingM),
            _buildDetailItem(
              icon: Icons.water_drop,
              title: 'Humidity',
              value: '${weather.humidity}%',
              subtitle: 'Relative humidity',
            ),
            const SizedBox(height: ThemeConstants.spacingM),
            _buildDetailItem(
              icon: Icons.air,
              title: 'Wind',
              value: '${weather.windSpeed.toStringAsFixed(1)} m/s',
              subtitle: 'Direction: ${_getWindDirection(weather.windDirection)}',
            ),
            const SizedBox(height: ThemeConstants.spacingM),
            _buildDetailItem(
              icon: Icons.speed,
              title: 'Pressure',
              value: '${weather.pressure} hPa',
              subtitle: 'Atmospheric pressure',
            ),
            const SizedBox(height: ThemeConstants.spacingM),
            _buildDetailItem(
              icon: Icons.visibility,
              title: 'Visibility',
              value: '${(weather.visibility / 1000).toStringAsFixed(1)} km',
              subtitle: 'Clear visibility',
            ),
            const SizedBox(height: ThemeConstants.spacingM),
            _buildDetailItem(
              icon: Icons.cloud,
              title: 'Clouds',
              value: '${weather.clouds}%',
              subtitle: 'Cloud coverage',
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.spacingM),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFFF6B35).withOpacity(0.3), // OpenWeatherMap orange
            const Color(0xFF4A90E2).withOpacity(0.3), // OpenWeatherMap blue
          ],
        ),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusM),
        border: Border.all(
          color: ThemeConstants.white.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(ThemeConstants.spacingS),
            decoration: BoxDecoration(
              color: ThemeConstants.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusS),
            ),
            child: Icon(
              icon,
              color: ThemeConstants.white,
              size: 24, // Increased from 10 to 24
            ),
          ),
          const SizedBox(width: ThemeConstants.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: ThemeConstants.bodyMedium.copyWith(
                    color: ThemeConstants.white.withOpacity(0.95),
                    fontSize: 14, // Increased from 7 to 14
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: ThemeConstants.heading3.copyWith(
                    color: ThemeConstants.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18, // Increased from 9 to 18
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: ThemeConstants.bodySmall.copyWith(
                    color: ThemeConstants.white.withOpacity(0.85),
                    fontSize: 12, // Increased from 5 to 12
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getWindDirection(int degrees) {
    if (degrees >= 337.5 || degrees < 22.5) return 'N';
    if (degrees >= 22.5 && degrees < 67.5) return 'NE';
    if (degrees >= 67.5 && degrees < 112.5) return 'E';
    if (degrees >= 112.5 && degrees < 157.5) return 'SE';
    if (degrees >= 157.5 && degrees < 202.5) return 'S';
    if (degrees >= 202.5 && degrees < 247.5) return 'SW';
    if (degrees >= 247.5 && degrees < 292.5) return 'W';
    if (degrees >= 292.5 && degrees < 337.5) return 'NW';
    return 'N';
  }
} 