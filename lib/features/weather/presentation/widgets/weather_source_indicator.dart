import 'package:flutter/material.dart';
import '../../../../core/constants/theme_constants.dart';
import '../../../../core/services/weather_background_service.dart';
import 'weather_info_dialog.dart';

class WeatherSourceIndicator extends StatelessWidget {
  final DateTime lastUpdated;

  const WeatherSourceIndicator({
    super.key,
    required this.lastUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showInfoDialog(context),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.spacingM,
          vertical: ThemeConstants.spacingS,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              WeatherBackgroundService.getOpenWeatherMapButtonColor(),
              const Color(0xFFFF8C42).withOpacity(0.8), // OpenWeatherMap secondary orange
            ],
          ),
          borderRadius: BorderRadius.circular(ThemeConstants.radiusM),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.info_outline,
                color: Colors.white,
                size: 14,
              ),
            ),
            const SizedBox(width: ThemeConstants.spacingS),
            Text(
              'OpenWeatherMap • ${_getTimeAgo()}',
              style: ThemeConstants.bodySmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const WeatherInfoDialog(),
    );
  }

  String _getTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(lastUpdated);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
} 