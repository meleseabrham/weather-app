import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/theme_constants.dart';
import '../../../../core/services/weather_background_service.dart';
import '../providers/weather_provider.dart';
import '../widgets/weather_header.dart';
import '../widgets/weather_details_card.dart';
import '../widgets/weather_forecast_list.dart';
import '../widgets/weather_error_enhanced.dart';
import '../widgets/nominatim_search_bar.dart';
import '../widgets/unit_toggle.dart';
import '../widgets/location_button.dart';

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({Key? key}) : super(key: key);

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  @override
  void initState() {
    super.initState();
    // Fetch current location weather when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().fetchCurrentLocationWeather();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Allow content to resize when keyboard appears
      body: Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
          // Get dynamic background based on weather condition
          LinearGradient backgroundGradient;
          
          if (weatherProvider.status == WeatherStatus.success && 
              weatherProvider.currentWeather != null) {
            final weatherCondition = weatherProvider.currentWeather!.description;
            final isNight = WeatherBackgroundService.isNightTime();
            backgroundGradient = WeatherBackgroundService.getWeatherBackground(
              weatherCondition, 
              isNight: isNight
            );
          } else {
            // Default OpenWeatherMap theme for loading/error states
            backgroundGradient = LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFFFF6B35), // OpenWeatherMap orange
                const Color(0xFF4A90E2), // OpenWeatherMap blue
                const Color(0xFF2C3E50), // OpenWeatherMap dark blue
              ],
            );
          }
          
          return Container(
            decoration: BoxDecoration(
              gradient: backgroundGradient,
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Search Bar and Controls - Fixed height to prevent overflow
                  Container(
                    padding: const EdgeInsets.all(ThemeConstants.spacingL),
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // Prevent unnecessary expansion
                      children: [
                        // Google Places Search Bar
                        NominatimSearchBar(
                          onPlaceSelected: (placeName, latitude, longitude) {
                            weatherProvider.fetchWeatherByCoordinates(latitude, longitude, placeName);
                          },
                        ),
                        
                        const SizedBox(height: ThemeConstants.spacingM),
                        
                        // Controls Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Unit Toggle (C°/F°) - Now on the left
                            UnitToggle(
                              currentUnit: weatherProvider.units,
                              onUnitChanged: (unit) {
                                weatherProvider.setUnits(unit);
                              },
                            ),
                            
                            // Location Button (eye icon) - Now on the right
                            LocationButton(
                              onPressed: () {
                                weatherProvider.fetchCurrentLocationWeather();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Content - Flexible to take remaining space
                  Flexible(
                    child: _buildContent(weatherProvider),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(WeatherProvider weatherProvider) {
    switch (weatherProvider.status) {
      case WeatherStatus.initial:
        return _buildLoadingState();
        
      case WeatherStatus.loading:
        return _buildLoadingState();
        
      case WeatherStatus.success:
        return _buildSuccessState(weatherProvider);
        
      case WeatherStatus.error:
        return _buildErrorState(weatherProvider);
    }
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: ThemeConstants.white,
          ),
          const SizedBox(height: ThemeConstants.spacingM),
          Text(
            'Loading weather data...',
            style: ThemeConstants.bodyMedium.copyWith(color: ThemeConstants.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState(WeatherProvider weatherProvider) {
    final weather = weatherProvider.currentWeather;
    final forecast = weatherProvider.forecast;

    if (weather == null) {
      return _buildErrorState(weatherProvider);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.spacingL),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.3, // Minimum height
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Prevent unnecessary expansion
          children: [
            // Weather Header
            WeatherHeader(weather: weather),
            
            const SizedBox(height: ThemeConstants.spacingL),
            
            // Weather Details
            if (weather != null) WeatherDetailsCard(weather: weather),
            
            const SizedBox(height: ThemeConstants.spacingL),
            
            // Weather Forecast
            if (forecast != null) WeatherForecastList(forecast: forecast),
            
            const SizedBox(height: ThemeConstants.spacingL),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(WeatherProvider weatherProvider) {
    return Center(
      child: WeatherErrorEnhanced(
        errorMessage: weatherProvider.errorMessage ?? 'An unknown error occurred',
        onRetry: () {
          weatherProvider.fetchCurrentLocationWeather();
        },
        onEnableLocation: () {
          weatherProvider.enableLocationAndFetchWeather();
        },
      ),
    );
  }
} 