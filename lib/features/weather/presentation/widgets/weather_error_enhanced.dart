import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/theme_constants.dart';
import '../../../location/data/exceptions/location_exception.dart';

class WeatherErrorEnhanced extends StatelessWidget {
  final String errorMessage;
  final VoidCallback? onRetry;
  final VoidCallback? onSearchCity;
  final VoidCallback? onEnableLocation; // New callback for automatic location enabling

  const WeatherErrorEnhanced({
    super.key,
    required this.errorMessage,
    this.onRetry,
    this.onSearchCity,
    this.onEnableLocation, // New parameter
  });

  @override
  Widget build(BuildContext context) {
    final errorInfo = _parseError(errorMessage);
    
    return Container(
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
            child: Icon(
              _getErrorIcon(errorInfo.type),
              size: 40,
              color: ThemeConstants.white,
            ),
          ),
          
          const SizedBox(height: ThemeConstants.spacingL),
          
          // Error Title
          Text(
            errorInfo.title,
            style: ThemeConstants.heading2.copyWith(
              color: ThemeConstants.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: ThemeConstants.spacingM),
          
          // Error Message
          Text(
            errorInfo.message,
            style: ThemeConstants.bodyMedium.copyWith(
              color: ThemeConstants.white.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: ThemeConstants.spacingXL),
          
          // Action Buttons
          _buildActionButtons(errorInfo),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ErrorInfo errorInfo) {
    return Column(
      children: [
        // Primary Action Button
        if (onRetry != null || onEnableLocation != null)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _getPrimaryButtonAction(errorInfo.type),
              icon: const Icon(Icons.refresh),
              label: Text(_getPrimaryButtonText(errorInfo.type)),
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeConstants.white,
                foregroundColor: ThemeConstants.primaryBlue,
                padding: const EdgeInsets.symmetric(
                  horizontal: ThemeConstants.spacingL,
                  vertical: ThemeConstants.spacingM,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusM),
                ),
              ),
            ),
          ),
        
        if ((onRetry != null || onEnableLocation != null) && onSearchCity != null)
          const SizedBox(height: ThemeConstants.spacingM),
        
        // Secondary Action Button
        if (onSearchCity != null)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onSearchCity,
              icon: const Icon(Icons.search),
              label: const Text('Search City'),
              style: OutlinedButton.styleFrom(
                foregroundColor: ThemeConstants.white,
                side: BorderSide(color: ThemeConstants.white.withOpacity(0.5)),
                padding: const EdgeInsets.symmetric(
                  horizontal: ThemeConstants.spacingL,
                  vertical: ThemeConstants.spacingM,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusM),
                ),
              ),
            ),
          ),
      ],
    );
  }

  VoidCallback? _getPrimaryButtonAction(ErrorType type) {
    switch (type) {
      case ErrorType.locationServiceDisabled:
      case ErrorType.locationPermissionDenied:
        return onEnableLocation ?? onRetry; // Use onEnableLocation if available, fallback to onRetry
      default:
        return onRetry;
    }
  }

  String _getPrimaryButtonText(ErrorType type) {
    switch (type) {
      case ErrorType.locationServiceDisabled:
      case ErrorType.locationPermissionDenied:
        return 'Enable Location';
      case ErrorType.networkError:
        return 'Check Connection';
      case ErrorType.timeout:
        return 'Try Again';
      case ErrorType.cityNotFound:
        return 'Search Again';
      default:
        return 'Try Again';
    }
  }

  IconData _getErrorIcon(ErrorType type) {
    switch (type) {
      case ErrorType.locationServiceDisabled:
      case ErrorType.locationPermissionDenied:
        return Icons.location_off;
      case ErrorType.networkError:
        return Icons.wifi_off;
      case ErrorType.timeout:
        return Icons.timer_off;
      case ErrorType.cityNotFound:
        return Icons.location_city;
      default:
        return Icons.error_outline;
    }
  }

  ErrorInfo _parseError(String errorMessage) {
    final message = errorMessage.toLowerCase();
    
    if (message.contains('your device location is off')) {
      return ErrorInfo(
        'Location Services Disabled',
        'Your device location is off. Please enable location services to get weather for your current location.',
        ErrorType.locationServiceDisabled,
      );
    }
    
    if (message.contains('location services are disabled')) {
      return ErrorInfo(
        'Location Services Disabled',
        'Please enable location services in your device settings to get weather for your current location.',
        ErrorType.locationServiceDisabled,
      );
    }
    
    if (message.contains('location permission') || message.contains('permission denied')) {
      return ErrorInfo(
        'Location Permission Required',
        'Please grant location permission to get weather for your current location.',
        ErrorType.locationPermissionDenied,
      );
    }
    
    if (message.contains('network') || message.contains('connection') || message.contains('internet')) {
      return ErrorInfo(
        'No Internet Connection',
        'Please check your internet connection and try again.',
        ErrorType.networkError,
      );
    }
    
    if (message.contains('timeout')) {
      return ErrorInfo(
        'Request Timeout',
        'The request took too long to complete. Please try again.',
        ErrorType.timeout,
      );
    }
    
    if (message.contains('city not found') || message.contains('not found')) {
      return ErrorInfo(
        'City Not Found',
        'The city you searched for was not found. Please check the spelling or try a different city name.',
        ErrorType.cityNotFound,
      );
    }
    
    return ErrorInfo(
      'Something Went Wrong',
      'An unexpected error occurred. Please try again.',
      ErrorType.unknown,
    );
  }
}

class ErrorInfo {
  final String title;
  final String message;
  final ErrorType type;

  ErrorInfo(this.title, this.message, this.type);
}

enum ErrorType {
  locationServiceDisabled,
  locationPermissionDenied,
  networkError,
  timeout,
  cityNotFound,
  unknown,
} 