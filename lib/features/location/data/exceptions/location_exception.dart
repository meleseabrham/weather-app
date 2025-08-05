enum LocationErrorType {
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
  timeout,
  noAddress,
  networkError,
  unknown,
}

class LocationException implements Exception {
  final String title;
  final String message;
  final LocationErrorType type;

  LocationException(this.title, this.message, this.type);

  @override
  String toString() {
    return 'LocationException: $title - $message';
  }

  /// Get user-friendly error message
  String get userMessage => message;

  /// Get error title
  String get errorTitle => title;

  /// Check if this is a permission-related error
  bool get isPermissionError {
    return type == LocationErrorType.permissionDenied ||
           type == LocationErrorType.permissionDeniedForever;
  }

  /// Check if this is a service-related error
  bool get isServiceError {
    return type == LocationErrorType.serviceDisabled;
  }

  /// Check if this is a timeout error
  bool get isTimeoutError {
    return type == LocationErrorType.timeout;
  }

  /// Check if this is a network error
  bool get isNetworkError {
    return type == LocationErrorType.networkError;
  }
} 