import 'weather_entity.dart';

class ForecastEntity {
  final List<WeatherEntity> forecasts;
  final String cityName;
  final String countryCode;
  final double latitude;
  final double longitude;

  const ForecastEntity({
    required this.forecasts,
    required this.cityName,
    required this.countryCode,
    required this.latitude,
    required this.longitude,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ForecastEntity &&
        other.forecasts == forecasts &&
        other.cityName == cityName &&
        other.countryCode == countryCode &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode {
    return forecasts.hashCode ^
        cityName.hashCode ^
        countryCode.hashCode ^
        latitude.hashCode ^
        longitude.hashCode;
  }

  @override
  String toString() {
    return 'ForecastEntity(forecasts: $forecasts, cityName: $cityName, countryCode: $countryCode, latitude: $latitude, longitude: $longitude)';
  }
} 