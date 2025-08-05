import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/constants/app_constants.dart';
import 'core/constants/theme_constants.dart';
import 'features/weather/data/datasources/weather_remote_data_source.dart';
import 'features/weather/data/repositories/weather_repository_impl.dart';
import 'features/weather/domain/usecases/get_current_weather.dart';
import 'features/weather/domain/usecases/get_weather_forecast.dart';
import 'features/weather/presentation/providers/weather_provider.dart';
import 'features/weather/presentation/pages/weather_home_page.dart';
import 'features/location/data/services/location_service.dart';
import 'core/services/connectivity_service.dart';
import 'features/weather/data/services/city_search_service.dart';
import 'features/weather/data/services/nominatim_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables safely
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print('Warning: Could not load .env file: $e');
    print('Using default API key (demo mode)');
  }
  
  // Initialize Hive for local storage
  await Hive.initFlutter();
  
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Dio instance for HTTP requests
        Provider<Dio>(
          create: (_) => Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 30),
              receiveTimeout: const Duration(seconds: 30),
            ),
          ),
        ),
        
        // Weather remote data source
        Provider<WeatherRemoteDataSource>(
          create: (context) => WeatherRemoteDataSourceImpl(
            dio: context.read<Dio>(),
          ),
        ),
        
        // Weather repository
        Provider<WeatherRepositoryImpl>(
          create: (context) => WeatherRepositoryImpl(
            remoteDataSource: context.read<WeatherRemoteDataSource>(),
          ),
        ),
        
        // Use cases
        Provider<GetCurrentWeather>(
          create: (context) => GetCurrentWeather(
            context.read<WeatherRepositoryImpl>(),
          ),
        ),
        
        Provider<GetWeatherForecast>(
          create: (context) => GetWeatherForecast(
            context.read<WeatherRepositoryImpl>(),
          ),
        ),
        
        // Location service
        Provider<LocationService>(
          create: (_) => LocationService(),
        ),
        
        // Connectivity service
        Provider<ConnectivityService>(
          create: (_) => ConnectivityService(),
        ),
        
        // City search service
        Provider<CitySearchService>(
          create: (context) => CitySearchService(context.read<Dio>()),
        ),

        // Nominatim service
        Provider<NominatimService>(
          create: (context) => NominatimService(context.read<Dio>()),
        ),
        
        // Weather provider
        ChangeNotifierProvider<WeatherProvider>(
          create: (context) => WeatherProvider(
            getCurrentWeather: context.read<GetCurrentWeather>(),
            getWeatherForecast: context.read<GetWeatherForecast>(),
            locationService: context.read<LocationService>(),
            connectivityService: context.read<ConnectivityService>(),
            citySearchService: context.read<CitySearchService>(),
            nominatimService: context.read<NominatimService>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: ThemeConstants.primaryBlue,
            brightness: Brightness.light,
          ),
          // fontFamily: 'Poppins',
          appBarTheme: AppBarTheme(
            backgroundColor: ThemeConstants.primaryBlue,
            foregroundColor: ThemeConstants.white,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: ThemeConstants.heading3.copyWith(
              color: ThemeConstants.white,
            ),
          ),
          cardTheme: CardThemeData(
            elevation: 4,
            shadowColor: ThemeConstants.black.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ThemeConstants.radiusL),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeConstants.primaryBlue,
              foregroundColor: ThemeConstants.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ThemeConstants.radiusM),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: ThemeConstants.spacingL,
                vertical: ThemeConstants.spacingM,
              ),
            ),
          ),
        ),
        home: const WeatherHomePage(),
      ),
    );
  }
}
