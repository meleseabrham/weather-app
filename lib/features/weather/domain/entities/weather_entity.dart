class WeatherEntity {
  final double temperature;
  final double feelsLike;
  final double minTemperature;
  final double maxTemperature;
  final int humidity;
  final int pressure;
  final double windSpeed;
  final int windDirection;
  final String description;
  final String icon;
  final String main;
  final int visibility;
  final double? rain;
  final double? snow;
  final int clouds;
  final DateTime dateTime;
  final String cityName;
  final String countryCode;
  final double latitude;
  final double longitude;

  const WeatherEntity({
    required this.temperature,
    required this.feelsLike,
    required this.minTemperature,
    required this.maxTemperature,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.windDirection,
    required this.description,
    required this.icon,
    required this.main,
    required this.visibility,
    this.rain,
    this.snow,
    required this.clouds,
    required this.dateTime,
    required this.cityName,
    required this.countryCode,
    required this.latitude,
    required this.longitude,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WeatherEntity &&
        other.temperature == temperature &&
        other.feelsLike == feelsLike &&
        other.minTemperature == minTemperature &&
        other.maxTemperature == maxTemperature &&
        other.humidity == humidity &&
        other.pressure == pressure &&
        other.windSpeed == windSpeed &&
        other.windDirection == windDirection &&
        other.description == description &&
        other.icon == icon &&
        other.main == main &&
        other.visibility == visibility &&
        other.rain == rain &&
        other.snow == snow &&
        other.clouds == clouds &&
        other.dateTime == dateTime &&
        other.cityName == cityName &&
        other.countryCode == countryCode &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode {
    return temperature.hashCode ^
        feelsLike.hashCode ^
        minTemperature.hashCode ^
        maxTemperature.hashCode ^
        humidity.hashCode ^
        pressure.hashCode ^
        windSpeed.hashCode ^
        windDirection.hashCode ^
        description.hashCode ^
        icon.hashCode ^
        main.hashCode ^
        visibility.hashCode ^
        rain.hashCode ^
        snow.hashCode ^
        clouds.hashCode ^
        dateTime.hashCode ^
        cityName.hashCode ^
        countryCode.hashCode ^
        latitude.hashCode ^
        longitude.hashCode;
  }

  @override
  String toString() {
    return 'WeatherEntity(temperature: $temperature, feelsLike: $feelsLike, minTemperature: $minTemperature, maxTemperature: $maxTemperature, humidity: $humidity, pressure: $pressure, windSpeed: $windSpeed, windDirection: $windDirection, description: $description, icon: $icon, main: $main, visibility: $visibility, rain: $rain, snow: $snow, clouds: $clouds, dateTime: $dateTime, cityName: $cityName, countryCode: $countryCode, latitude: $latitude, longitude: $longitude)';
  }
} 