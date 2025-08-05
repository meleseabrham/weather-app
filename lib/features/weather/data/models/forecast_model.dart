import '../../domain/entities/forecast_entity.dart';
import '../../domain/entities/weather_entity.dart';
import 'weather_model.dart';

class ForecastModel extends ForecastEntity {
  const ForecastModel({
    required super.forecasts,
    required super.cityName,
    required super.countryCode,
    required super.latitude,
    required super.longitude,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      throw Exception('Invalid JSON response');
    }
    
    final city = json['city'] as Map<String, dynamic>? ?? {};
    final list = json['list'] as List? ?? [];
    
    final forecasts = list.map((item) {
      return WeatherModel.fromJson(item);
    }).toList();

    final coord = city['coord'] as Map<String, dynamic>? ?? {};

    return ForecastModel(
      forecasts: forecasts,
      cityName: city['name'] as String? ?? 'Unknown City',
      countryCode: city['country'] as String? ?? 'Unknown',
      latitude: (coord['lat'] as num?)?.toDouble() ?? 0.0,
      longitude: (coord['lon'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': {
        'name': cityName,
        'country': countryCode,
        'coord': {
          'lat': latitude,
          'lon': longitude,
        },
      },
      'list': forecasts.map((forecast) {
        if (forecast is WeatherModel) {
          return forecast.toJson();
        }
        return {};
      }).toList(),
    };
  }
} 