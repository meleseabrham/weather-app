import 'package:flutter/material.dart';
import '../../../../core/constants/theme_constants.dart';

class WeatherInfoDialog extends StatelessWidget {
  const WeatherInfoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ThemeConstants.darkGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusL),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.9,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Padding(
          padding: const EdgeInsets.all(ThemeConstants.spacingL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: ThemeConstants.white,
                    size: 20,
                  ),
                  const SizedBox(width: ThemeConstants.spacingS),
                  Expanded(
                    child: Text(
                      'Weather Data Information',
                      style: ThemeConstants.heading3.copyWith(
                        color: ThemeConstants.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: ThemeConstants.spacingL),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Why does weather data differ between apps?',
                        style: ThemeConstants.bodyLarge.copyWith(
                          color: ThemeConstants.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: ThemeConstants.spacingM),
                      
                      _buildInfoSection(
                        'Data Sources',
                        '• This app uses OpenWeatherMap API\n• Google uses its own weather data\n• Different weather stations and models',
                      ),
                      
                      _buildInfoSection(
                        'Update Frequency',
                        '• OpenWeatherMap: Every 10-15 minutes\n• Google: More frequent updates\n• Real-time vs. periodic updates',
                      ),
                      
                      _buildInfoSection(
                        'Forecasting Models',
                        '• Different algorithms and models\n• Various weather prediction methods\n• Location precision differences',
                      ),
                      
                      _buildInfoSection(
                        'Accuracy Tips',
                        '• Check multiple weather sources\n• Consider local weather stations\n• Note the data update time\n• Weather can vary within cities',
                      ),
                      
                      const SizedBox(height: ThemeConstants.spacingM),
                      
                      Container(
                        padding: const EdgeInsets.all(ThemeConstants.spacingM),
                        decoration: BoxDecoration(
                          color: ThemeConstants.primaryBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(ThemeConstants.radiusM),
                          border: Border.all(
                            color: ThemeConstants.primaryBlue.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.lightbulb_outline,
                              color: ThemeConstants.primaryBlue,
                              size: 20,
                            ),
                            const SizedBox(width: ThemeConstants.spacingS),
                            Expanded(
                              child: Text(
                                'For the most accurate weather, check multiple sources and consider local conditions.',
                                style: ThemeConstants.bodyMedium.copyWith(
                                  color: ThemeConstants.primaryBlue,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Actions
              const SizedBox(height: ThemeConstants.spacingM),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Got it!',
                      style: ThemeConstants.bodyMedium.copyWith(
                        color: ThemeConstants.primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: ThemeConstants.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: ThemeConstants.bodyMedium.copyWith(
              color: ThemeConstants.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: ThemeConstants.spacingXS),
          Text(
            content,
            style: ThemeConstants.bodySmall.copyWith(
              color: ThemeConstants.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
} 