import 'package:dio/dio.dart';

class CitySearchService {
  final Dio _dio;

  CitySearchService(this._dio);

  /// Get city suggestions based on search query
  Future<List<CitySuggestion>> getCitySuggestions(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }

    try {
      // Clean and format the query
      final cleanQuery = _cleanQuery(query);
      
      // Using OpenWeatherMap Geocoding API for city suggestions
      final response = await _dio.get(
        'http://api.openweathermap.org/geo/1.0/direct',
        queryParameters: {
          'q': cleanQuery,
          'limit': 25, // Increased limit for better global results
          'appid': '23f2d2acf1d24354415f71448c5a423e',
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data as List<dynamic>;
        final suggestions = data.map((city) => CitySuggestion.fromJson(city)).toList();
        
        // If no results with cleaned query, try with original query
        if (suggestions.isEmpty && cleanQuery != query.trim()) {
          final fallbackResponse = await _dio.get(
            'http://api.openweathermap.org/geo/1.0/direct',
            queryParameters: {
              'q': query.trim(),
              'limit': 25,
              'appid': '23f2d2acf1d24354415f71448c5a423e',
            },
          );
          
          if (fallbackResponse.statusCode == 200 && fallbackResponse.data != null) {
            final List<dynamic> fallbackData = fallbackResponse.data as List<dynamic>;
            return fallbackData.map((city) => CitySuggestion.fromJson(city)).toList();
          }
        }
        
        return suggestions;
      }

      return [];
    } catch (e) {
      print('Error getting city suggestions: $e');
      return [];
    }
  }

  /// Validate if a city exists with multiple search attempts
  Future<bool> validateCity(String cityName) async {
    try {
      // Try multiple search variations
      final searchVariations = _getSearchVariations(cityName);
      
      for (final variation in searchVariations) {
        final response = await _dio.get(
          'http://api.openweathermap.org/geo/1.0/direct',
          queryParameters: {
            'q': variation,
            'limit': 1,
            'appid': '23f2d2acf1d24354415f71448c5a423e',
          },
        );

        if (response.statusCode == 200 && response.data != null) {
          final List<dynamic> data = response.data as List<dynamic>;
          if (data.isNotEmpty) {
            return true;
          }
        }
      }

      return false;
    } catch (e) {
      print('Error validating city: $e');
      return false;
    }
  }

  /// Get city coordinates by name with multiple search attempts
  Future<CityCoordinates?> getCityCoordinates(String cityName) async {
    try {
      // Try multiple search variations
      final searchVariations = _getSearchVariations(cityName);
      
      for (final variation in searchVariations) {
        final response = await _dio.get(
          'http://api.openweathermap.org/geo/1.0/direct',
          queryParameters: {
            'q': variation,
            'limit': 1,
            'appid': '23f2d2acf1d24354415f71448c5a423e',
          },
        );

        if (response.statusCode == 200 && response.data != null) {
          final List<dynamic> data = response.data as List<dynamic>;
          if (data.isNotEmpty) {
            return CityCoordinates.fromJson(data.first);
          }
        }
      }

      return null;
    } catch (e) {
      print('Error getting city coordinates: $e');
      return null;
    }
  }

  /// Clean and format the search query
  String _cleanQuery(String query) {
    // Remove common suffixes that might cause issues
    String cleaned = query.trim();
    
    // Remove "City" suffix if present
    if (cleaned.toLowerCase().endsWith(' city')) {
      cleaned = cleaned.substring(0, cleaned.length - 5);
    }
    
    // Remove "Town" suffix if present
    if (cleaned.toLowerCase().endsWith(' town')) {
      cleaned = cleaned.substring(0, cleaned.length - 5);
    }
    
    // Remove "Village" suffix if present
    if (cleaned.toLowerCase().endsWith(' village')) {
      cleaned = cleaned.substring(0, cleaned.length - 8);
    }
    
    // Remove "District" suffix if present
    if (cleaned.toLowerCase().endsWith(' district')) {
      cleaned = cleaned.substring(0, cleaned.length - 9);
    }
    
    // Remove extra spaces
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ');
    
    return cleaned;
  }

  /// Get multiple search variations for a city name
  List<String> _getSearchVariations(String cityName) {
    final variations = <String>[];
    final cleanName = _cleanQuery(cityName);
    
    // Add the cleaned name
    variations.add(cleanName);
    
    // Add with common country codes for better results
    final countryCodes = [
      'US', 'GB', 'CA', 'AU', 'DE', 'FR', 'IT', 'ES', 'JP', 'CN', 'IN', 'BR', 'RU', 'ET', 'KE', 'NG', 'ZA', 'EG', 'MA', 'TN'
    ];
    
    // Add variations with country codes
    for (final code in countryCodes) {
      variations.add('$cleanName,$code');
    }
    
    // Add common city name variations
    if (cleanName.toLowerCase().contains('new york')) {
      variations.add('New York,US');
      variations.add('New York City,US');
      variations.add('NYC,US');
    }
    
    if (cleanName.toLowerCase().contains('london')) {
      variations.add('London,GB');
      variations.add('London,UK');
    }
    
    if (cleanName.toLowerCase().contains('paris')) {
      variations.add('Paris,FR');
    }
    
    if (cleanName.toLowerCase().contains('tokyo')) {
      variations.add('Tokyo,JP');
    }
    
    if (cleanName.toLowerCase().contains('beijing')) {
      variations.add('Beijing,CN');
      variations.add('Peking,CN');
    }
    
    if (cleanName.toLowerCase().contains('mumbai')) {
      variations.add('Mumbai,IN');
      variations.add('Bombay,IN');
    }
    
    if (cleanName.toLowerCase().contains('moscow')) {
      variations.add('Moscow,RU');
    }
    
    if (cleanName.toLowerCase().contains('sydney')) {
      variations.add('Sydney,AU');
    }
    
    if (cleanName.toLowerCase().contains('toronto')) {
      variations.add('Toronto,CA');
    }
    
    if (cleanName.toLowerCase().contains('berlin')) {
      variations.add('Berlin,DE');
    }
    
    if (cleanName.toLowerCase().contains('madrid')) {
      variations.add('Madrid,ES');
    }
    
    if (cleanName.toLowerCase().contains('rome')) {
      variations.add('Rome,IT');
    }
    
    if (cleanName.toLowerCase().contains('rio de janeiro')) {
      variations.add('Rio de Janeiro,BR');
      variations.add('Rio,BR');
    }
    
    if (cleanName.toLowerCase().contains('sao paulo')) {
      variations.add('Sao Paulo,BR');
    }
    
    if (cleanName.toLowerCase().contains('lagos')) {
      variations.add('Lagos,NG');
    }
    
    if (cleanName.toLowerCase().contains('nairobi')) {
      variations.add('Nairobi,KE');
    }
    
    if (cleanName.toLowerCase().contains('johannesburg')) {
      variations.add('Johannesburg,ZA');
    }
    
    if (cleanName.toLowerCase().contains('cairo')) {
      variations.add('Cairo,EG');
    }
    
    if (cleanName.toLowerCase().contains('casablanca')) {
      variations.add('Casablanca,MA');
    }
    
    if (cleanName.toLowerCase().contains('tunis')) {
      variations.add('Tunis,TN');
    }
    
    // Ethiopian cities (keeping for local users)
    if (cleanName.toLowerCase().contains('bahir dar') || 
        cleanName.toLowerCase().contains('bahirdar')) {
      variations.add('Bahir Dar,ET');
      variations.add('Bahir Dar,Ethiopia');
      variations.add('Bahirdar,ET');
      variations.add('Bahirdar,Ethiopia');
    }
    
    if (cleanName.toLowerCase().contains('addis ababa') || 
        cleanName.toLowerCase().contains('addisababa')) {
      variations.add('Addis Ababa,ET');
      variations.add('Addis Ababa,Ethiopia');
      variations.add('Addisababa,ET');
      variations.add('Addisababa,Ethiopia');
    }
    
    if (cleanName.toLowerCase().contains('gondar') || 
        cleanName.toLowerCase().contains('gonder')) {
      variations.add('Gondar,ET');
      variations.add('Gondar,Ethiopia');
      variations.add('Gonder,ET');
      variations.add('Gonder,Ethiopia');
    }
    
    if (cleanName.toLowerCase().contains('mekelle') || 
        cleanName.toLowerCase().contains('mekele')) {
      variations.add('Mekelle,ET');
      variations.add('Mekelle,Ethiopia');
      variations.add('Mekele,ET');
      variations.add('Mekele,Ethiopia');
    }
    
    if (cleanName.toLowerCase().contains('hawassa') || 
        cleanName.toLowerCase().contains('awasa')) {
      variations.add('Hawassa,ET');
      variations.add('Hawassa,Ethiopia');
      variations.add('Awasa,ET');
      variations.add('Awasa,Ethiopia');
    }
    
    if (cleanName.toLowerCase().contains('dire dawa') || 
        cleanName.toLowerCase().contains('diredawa')) {
      variations.add('Dire Dawa,ET');
      variations.add('Dire Dawa,Ethiopia');
      variations.add('Diredawa,ET');
      variations.add('Diredawa,Ethiopia');
    }
    
    if (cleanName.toLowerCase().contains('jimma') || 
        cleanName.toLowerCase().contains('jima')) {
      variations.add('Jimma,ET');
      variations.add('Jimma,Ethiopia');
      variations.add('Jima,ET');
      variations.add('Jima,Ethiopia');
    }
    
    // Remove duplicates and return
    return variations.toSet().toList();
  }
}

class CitySuggestion {
  final String name;
  final String country;
  final String state;
  final double lat;
  final double lon;

  CitySuggestion({
    required this.name,
    required this.country,
    required this.state,
    required this.lat,
    required this.lon,
  });

  factory CitySuggestion.fromJson(Map<String, dynamic> json) {
    return CitySuggestion(
      name: json['name'] as String? ?? '',
      country: json['country'] as String? ?? '',
      state: json['state'] as String? ?? '',
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lon: (json['lon'] as num?)?.toDouble() ?? 0.0,
    );
  }

  String get displayName {
    if (state.isNotEmpty) {
      return '$name, $state, $country';
    }
    return '$name, $country';
  }
}

class CityCoordinates {
  final String name;
  final String country;
  final double lat;
  final double lon;

  CityCoordinates({
    required this.name,
    required this.country,
    required this.lat,
    required this.lon,
  });

  factory CityCoordinates.fromJson(Map<String, dynamic> json) {
    return CityCoordinates(
      name: json['name'] as String? ?? '',
      country: json['country'] as String? ?? '',
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lon: (json['lon'] as num?)?.toDouble() ?? 0.0,
    );
  }
} 