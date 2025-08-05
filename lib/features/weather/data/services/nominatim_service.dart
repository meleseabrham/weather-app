import 'package:dio/dio.dart';

class NominatimService {
  final Dio _dio;

  NominatimService(Dio dio) : _dio = dio;

  /// Search for places using Nominatim API (OpenStreetMap)
  Future<List<PlaceSearchResult>> searchPlaces(String query) async {
    try {
      print('🔍 Searching places with Nominatim for: "$query"');
      
      if (query.trim().isEmpty) {
        print('❌ Query is empty, returning empty list');
        return [];
      }

      final url = 'https://nominatim.openstreetmap.org/search';
      final params = {
        'q': query,
        'format': 'json',
        'limit': 10,
        'addressdetails': 1,
      };
      
      print('🌐 Making request to: $url');
      print('📝 Parameters: $params');

      final response = await _dio.get(
        url, 
        queryParameters: params,
        options: Options(
          headers: {
            'User-Agent': 'WeatherApp/1.0 (https://github.com/yourusername/weatherapp)',
          },
        ),
      );

      print('📡 Response status: ${response.statusCode}');
      print('📄 Found ${response.data.length} results');

      if (response.statusCode == 200) {
        final List<dynamic> results = response.data;
        return results.map((place) => PlaceSearchResult.fromNominatimJson(place)).toList();
      }

      return [];
    } catch (e) {
      print('💥 Error searching places with Nominatim: $e');
      print('🔄 Falling back to OpenWeatherMap Geocoding API');
      return await _fallbackToOpenWeatherMap(query);
    }
  }

  /// Get place details including coordinates
  Future<PlaceDetails?> getPlaceDetails(String placeId) async {
    try {
      print('🔍 Getting place details for: $placeId');
      
      final url = 'https://nominatim.openstreetmap.org/lookup';
      final params = {
        'osm_ids': placeId,
        'format': 'json',
        'addressdetails': 1,
      };

      final response = await _dio.get(
        url, 
        queryParameters: params,
        options: Options(
          headers: {
            'User-Agent': 'WeatherApp/1.0 (https://github.com/yourusername/weatherapp)',
          },
        ),
      );

      if (response.statusCode == 200 && response.data.isNotEmpty) {
        return PlaceDetails.fromNominatimJson(response.data[0]);
      }

      return null;
    } catch (e) {
      print('💥 Error getting place details: $e');
      return null;
    }
  }

  /// Search for places with autocomplete suggestions
  Future<List<PlaceAutocompleteResult>> getAutocompleteSuggestions(String input) async {
    try {
      print('🔍 Getting autocomplete suggestions for: "$input"');
      
      if (input.trim().isEmpty) {
        print('❌ Input is empty, returning empty list');
        return [];
      }

      final url = 'https://nominatim.openstreetmap.org/search';
      final params = {
        'q': input,
        'format': 'json',
        'limit': 8,
        'addressdetails': 1,
      };
      
      print('🌐 Making request to: $url');
      print('📝 Parameters: $params');

      final response = await _dio.get(
        url, 
        queryParameters: params,
        options: Options(
          headers: {
            'User-Agent': 'WeatherApp/1.0 (https://github.com/yourusername/weatherapp)',
          },
        ),
      );

      print('📡 Response status: ${response.statusCode}');
      print('📄 Found ${response.data.length} suggestions');

      if (response.statusCode == 200) {
        final List<dynamic> results = response.data;
        return results.map((place) => PlaceAutocompleteResult.fromNominatimJson(place)).toList();
      }

      return [];
    } catch (e) {
      print('💥 Error getting autocomplete suggestions with Nominatim: $e');
      print('🔄 Falling back to OpenWeatherMap Geocoding API');
      return await _fallbackToOpenWeatherMapAutocomplete(input);
    }
  }

  /// Fallback to OpenWeatherMap Geocoding API
  Future<List<PlaceSearchResult>> _fallbackToOpenWeatherMap(String query) async {
    try {
      print('🌍 Using OpenWeatherMap Geocoding API fallback for: "$query"');
      
      final url = 'http://api.openweathermap.org/geo/1.0/direct';
      final params = {
        'q': query,
        'limit': 10,
        'appid': 'demo', // Using demo key for fallback
      };
      
      print('🌐 Making fallback request to: $url');
      
      final response = await _dio.get(url, queryParameters: params);
      
      if (response.statusCode == 200) {
        final List<dynamic> results = response.data;
        print('✅ OpenWeatherMap fallback found ${results.length} results');
        
        return results.map((result) => PlaceSearchResult(
          placeId: '${result['lat']},${result['lon']}',
          name: result['name'] ?? '',
          formattedAddress: '${result['name']}, ${result['country']}',
          latitude: result['lat']?.toDouble(),
          longitude: result['lon']?.toDouble(),
        )).toList();
      }
      
      return [];
    } catch (e) {
      print('💥 Error in OpenWeatherMap fallback: $e');
      return [];
    }
  }

  /// Fallback to OpenWeatherMap Geocoding API for autocomplete
  Future<List<PlaceAutocompleteResult>> _fallbackToOpenWeatherMapAutocomplete(String input) async {
    try {
      print('🌍 Using OpenWeatherMap Geocoding API fallback for autocomplete: "$input"');
      
      final url = 'http://api.openweathermap.org/geo/1.0/direct';
      final params = {
        'q': input,
        'limit': 8,
        'appid': 'demo', // Using demo key for fallback
      };
      
      print('🌐 Making fallback request to: $url');
      
      final response = await _dio.get(url, queryParameters: params);
      
      if (response.statusCode == 200) {
        final List<dynamic> results = response.data;
        print('✅ OpenWeatherMap fallback found ${results.length} results');
        
        return results.map((result) => PlaceAutocompleteResult(
          placeId: '${result['lat']},${result['lon']}',
          description: '${result['name']}, ${result['country']}',
          mainText: result['name'] ?? '',
          secondaryText: '${result['state'] ?? ''} ${result['country'] ?? ''}'.trim(),
          latitude: result['lat']?.toDouble(),
          longitude: result['lon']?.toDouble(),
        )).toList();
      }
      
      return [];
    } catch (e) {
      print('💥 Error in OpenWeatherMap fallback: $e');
      return [];
    }
  }
}

/// Model for place search results
class PlaceSearchResult {
  final String placeId;
  final String name;
  final String formattedAddress;
  final double? latitude;
  final double? longitude;

  PlaceSearchResult({
    required this.placeId,
    required this.name,
    required this.formattedAddress,
    this.latitude,
    this.longitude,
  });

  factory PlaceSearchResult.fromNominatimJson(Map<String, dynamic> json) {
    final address = json['address'] ?? {};
    
    return PlaceSearchResult(
      placeId: json['osm_id']?.toString() ?? '',
      name: json['name'] ?? address['city'] ?? address['town'] ?? address['village'] ?? '',
      formattedAddress: json['display_name'] ?? '',
      latitude: double.tryParse(json['lat']?.toString() ?? ''),
      longitude: double.tryParse(json['lon']?.toString() ?? ''),
    );
  }
}

/// Model for place autocomplete results
class PlaceAutocompleteResult {
  final String placeId;
  final String description;
  final String mainText;
  final String secondaryText;
  final double? latitude;
  final double? longitude;

  PlaceAutocompleteResult({
    required this.placeId,
    required this.description,
    required this.mainText,
    required this.secondaryText,
    this.latitude,
    this.longitude,
  });

  factory PlaceAutocompleteResult.fromNominatimJson(Map<String, dynamic> json) {
    final address = json['address'] ?? {};
    final displayName = json['display_name'] ?? '';
    
    // Extract main text (city/town name)
    String mainText = json['name'] ?? 
                     address['city'] ?? 
                     address['town'] ?? 
                     address['village'] ?? 
                     address['state'] ?? 
                     '';
    
    // Extract secondary text (state, country)
    String secondaryText = '';
    if (address['state'] != null && address['country'] != null) {
      secondaryText = '${address['state']}, ${address['country']}';
    } else if (address['country'] != null) {
      secondaryText = address['country'];
    } else if (address['state'] != null) {
      secondaryText = address['state'];
    }
    
    return PlaceAutocompleteResult(
      placeId: json['osm_id']?.toString() ?? '',
      description: displayName,
      mainText: mainText,
      secondaryText: secondaryText,
      latitude: double.tryParse(json['lat']?.toString() ?? ''),
      longitude: double.tryParse(json['lon']?.toString() ?? ''),
    );
  }
}

/// Model for place details
class PlaceDetails {
  final String placeId;
  final String name;
  final String formattedAddress;
  final double? latitude;
  final double? longitude;

  PlaceDetails({
    required this.placeId,
    required this.name,
    required this.formattedAddress,
    this.latitude,
    this.longitude,
  });

  factory PlaceDetails.fromNominatimJson(Map<String, dynamic> json) {
    final address = json['address'] ?? {};
    
    return PlaceDetails(
      placeId: json['osm_id']?.toString() ?? '',
      name: json['name'] ?? address['city'] ?? address['town'] ?? address['village'] ?? '',
      formattedAddress: json['display_name'] ?? '',
      latitude: double.tryParse(json['lat']?.toString() ?? ''),
      longitude: double.tryParse(json['lon']?.toString() ?? ''),
    );
  }
} 