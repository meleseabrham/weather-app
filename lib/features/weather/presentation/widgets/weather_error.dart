import 'package:flutter/material.dart';
import '../../../../core/constants/theme_constants.dart';

class WeatherError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const WeatherError({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(ThemeConstants.spacingL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Error Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: ThemeConstants.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusXL),
              ),
              child: const Icon(
                Icons.error_outline,
                size: 40,
                color: ThemeConstants.white,
              ),
            ),
            
            const SizedBox(height: ThemeConstants.spacingL),
            
            // Error Title
            Text(
              'Oops!',
              style: ThemeConstants.heading2.copyWith(
                color: ThemeConstants.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: ThemeConstants.spacingM),
            
            // Error Message
            Text(
              message,
              style: ThemeConstants.bodyLarge.copyWith(
                color: ThemeConstants.white.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: ThemeConstants.spacingXL),
            
            // Retry Button
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeConstants.white,
                foregroundColor: ThemeConstants.primaryBlue,
                padding: const EdgeInsets.symmetric(
                  horizontal: ThemeConstants.spacingXL,
                  vertical: ThemeConstants.spacingM,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusM),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 