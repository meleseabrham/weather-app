import '../../domain/entities/weather_entity.dart';

class WeatherModel extends WeatherEntity {
  const WeatherModel({
    required super.temperature,
    required super.feelsLike,
    required super.minTemperature,
    required super.maxTemperature,
    required super.humidity,
    required super.pressure,
    required super.windSpeed,
    required super.windDirection,
    required super.description,
    required super.icon,
    required super.main,
    required super.visibility,
    super.rain,
    super.snow,
    required super.clouds,
    required super.dateTime,
    required super.cityName,
    required super.countryCode,
    required super.latitude,
    required super.longitude,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      throw Exception('Invalid JSON response');
    }
    
    final weather = json['weather'] as List? ?? [];
    if (weather.isEmpty) {
      throw Exception('No weather data available');
    }
    
    final main = json['main'] as Map<String, dynamic>? ?? {};
    final wind = json['wind'] as Map<String, dynamic>? ?? {};
    final clouds = json['clouds'] as Map<String, dynamic>? ?? {};
    final sys = json['sys'] as Map<String, dynamic>? ?? {};
    final coord = json['coord'] as Map<String, dynamic>? ?? {};

    return WeatherModel(
      temperature: (main['temp'] as num?)?.toDouble() ?? 0.0,
      feelsLike: (main['feels_like'] as num?)?.toDouble() ?? 0.0,
      minTemperature: (main['temp_min'] as num?)?.toDouble() ?? 0.0,
      maxTemperature: (main['temp_max'] as num?)?.toDouble() ?? 0.0,
      humidity: main['humidity'] as int? ?? 0,
      pressure: main['pressure'] as int? ?? 0,
      windSpeed: (wind['speed'] as num?)?.toDouble() ?? 0.0,
      windDirection: wind['deg'] as int? ?? 0,
      description: weather.first['description'] as String? ?? 'Unknown',
      icon: weather.first['icon'] as String? ?? '01d',
      main: weather.first['main'] as String? ?? 'Clear',
      visibility: json['visibility'] as int? ?? 10000,
      rain: json['rain'] != null ? (json['rain']['1h'] as num?)?.toDouble() : null,
      snow: json['snow'] != null ? (json['snow']['1h'] as num?)?.toDouble() : null,
      clouds: clouds['all'] as int? ?? 0,
      dateTime: DateTime.fromMillisecondsSinceEpoch(((json['dt'] as int?) ?? DateTime.now().millisecondsSinceEpoch ~/ 1000) * 1000),
      cityName: json['name'] as String? ?? 'Unknown City',
      countryCode: sys['country'] as String? ?? 'Unknown',
      latitude: (coord['lat'] as num?)?.toDouble() ?? 0.0,
      longitude: (coord['lon'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'main': {
        'temp': temperature,
        'feels_like': feelsLike,
        'temp_min': minTemperature,
        'temp_max': maxTemperature,
        'humidity': humidity,
        'pressure': pressure,
      },
      'wind': {
        'speed': windSpeed,
        'deg': windDirection,
      },
      'weather': [
        {
          'description': description,
          'icon': icon,
          'main': main,
        }
      ],
      'visibility': visibility,
      'rain': rain != null ? {'1h': rain} : null,
      'snow': snow != null ? {'1h': snow} : null,
      'clouds': {'all': clouds},
      'dt': dateTime.millisecondsSinceEpoch ~/ 1000,
      'name': cityName,
      'sys': {'country': countryCode},
      'coord': {
        'lat': latitude,
        'lon': longitude,
      },
    };
  }
} 