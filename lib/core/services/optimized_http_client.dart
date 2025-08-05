import 'package:dio/dio.dart';

class OptimizedHttpClient {
  static Dio? _instance;
  
  static Dio get instance {
    _instance ??= _createOptimizedClient();
    return _instance!;
  }

  static Dio _createOptimizedClient() {
    // Create Dio instance with optimizations
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10), // Reduced from 30
        receiveTimeout: const Duration(seconds: 15), // Reduced from 30
        sendTimeout: const Duration(seconds: 10),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'User-Agent': 'WeatherApp/1.0',
        },
      ),
    );

    // Add retry interceptor for better reliability
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.sendTimeout) {
            // Retry once on timeout
            try {
              final response = await dio.request(
                error.requestOptions.path,
                data: error.requestOptions.data,
                queryParameters: error.requestOptions.queryParameters,
                options: Options(
                  method: error.requestOptions.method,
                  headers: error.requestOptions.headers,
                ),
              );
              handler.resolve(response);
              return;
            } catch (retryError) {
              handler.reject(error);
              return;
            }
          }
          handler.reject(error);
        },
      ),
    );

    return dio;
  }

  // Preload common data
  static Future<void> preloadCommonData() async {
    final dio = instance;
    
    // Preload common city data
    final commonCities = ['London', 'New York', 'Tokyo', 'Paris', 'Sydney'];
    
    for (final city in commonCities) {
      try {
        await dio.get(
          'https://api.openweathermap.org/data/2.5/weather',
          queryParameters: {
            'q': city,
            'appid': 'demo', // Will be replaced with actual key
            'units': 'metric',
          },
        );
      } catch (e) {
        // Ignore preload errors
      }
    }
  }
} 