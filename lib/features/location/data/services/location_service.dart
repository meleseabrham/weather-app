import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../domain/entities/location_entity.dart';
import '../exceptions/location_exception.dart';

class LocationService {
  /// Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Check location permission status
  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  /// Request location permission
  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  /// Enable location services and request permissions automatically
  Future<LocationEntity> enableLocationAndGetCurrentLocation() async {
    try {
      // First, check if location services are enabled
      bool serviceEnabled = await isLocationServiceEnabled();
      
      // If location services are disabled, try to enable them
      if (!serviceEnabled) {
        // Open location settings to let user enable location services
        bool locationEnabled = await Geolocator.openLocationSettings();
        
        // Wait a bit for user to potentially enable location
        await Future.delayed(const Duration(seconds: 2));
        
        // Check again if location services are now enabled
        serviceEnabled = await isLocationServiceEnabled();
        
        if (!serviceEnabled) {
          throw LocationException(
            'Location services are disabled',
            'Please enable location services in your device settings to get weather for your current location.',
            LocationErrorType.serviceDisabled,
          );
        }
      }

      // Check permission status
      LocationPermission permission = await checkPermission();
      
      // If permission is denied, request it
      if (permission == LocationPermission.denied) {
        permission = await requestPermission();
        if (permission == LocationPermission.denied) {
          throw LocationException(
            'Location permission denied',
            'Please grant location permission to get weather for your current location.',
            LocationErrorType.permissionDenied,
          );
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw LocationException(
          'Location permission permanently denied',
          'Location permission has been permanently denied. Please enable it in your device settings.',
          LocationErrorType.permissionDeniedForever,
        );
      }

      // Now get the current location
      return await getCurrentLocation();
    } catch (e) {
      if (e is LocationException) {
        rethrow;
      }
      throw LocationException(
        'Failed to enable location',
        'Unable to enable location services. Please try again.',
        LocationErrorType.unknown,
      );
    }
  }

  /// Get current location
  Future<LocationEntity> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw LocationException(
          'Location services are disabled',
          'Please enable location services in your device settings to get weather for your current location.',
          LocationErrorType.serviceDisabled,
        );
      }

      // Check permission status
      LocationPermission permission = await checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await requestPermission();
        if (permission == LocationPermission.denied) {
          throw LocationException(
            'Location permission denied',
            'Please grant location permission to get weather for your current location.',
            LocationErrorType.permissionDenied,
          );
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw LocationException(
          'Location permission permanently denied',
          'Location permission has been permanently denied. Please enable it in your device settings.',
          LocationErrorType.permissionDeniedForever,
        );
      }

      // Get current position with timeout
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw LocationException(
            'Location request timeout',
            'Unable to get your location. Please check your GPS signal and try again.',
            LocationErrorType.timeout,
          );
        },
      );

      // Get address from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw LocationException(
            'Address lookup timeout',
            'Unable to get address information. Please try again.',
            LocationErrorType.timeout,
          );
        },
      );

      if (placemarks.isEmpty) {
        throw LocationException(
          'No address found',
          'Unable to determine your location address. Please try again.',
          LocationErrorType.noAddress,
        );
      }

      Placemark placemark = placemarks.first;

      return LocationEntity(
        latitude: position.latitude,
        longitude: position.longitude,
        cityName: placemark.locality ?? 'Unknown City',
        countryCode: placemark.isoCountryCode ?? 'Unknown',
        countryName: placemark.country ?? 'Unknown',
        stateName: placemark.administrativeArea ?? '',
        postalCode: placemark.postalCode ?? '',
        address: _buildAddress(placemark),
      );
    } catch (e) {
      if (e is LocationException) {
        rethrow;
      }
      
      // Handle network-related errors
      if (e.toString().contains('network') || e.toString().contains('connection')) {
        throw LocationException(
          'Network error',
          'Unable to get location due to network issues. Please check your internet connection.',
          LocationErrorType.networkError,
        );
      }
      
      throw LocationException(
        'Unknown error',
        'An unexpected error occurred while getting your location. Please try again.',
        LocationErrorType.unknown,
      );
    }
  }

  String _buildAddress(Placemark placemark) {
    List<String> addressParts = [];
    
    if (placemark.street != null && placemark.street!.isNotEmpty) {
      addressParts.add(placemark.street!);
    }
    
    if (placemark.locality != null && placemark.locality!.isNotEmpty) {
      addressParts.add(placemark.locality!);
    }
    
    if (placemark.administrativeArea != null && placemark.administrativeArea!.isNotEmpty) {
      addressParts.add(placemark.administrativeArea!);
    }
    
    if (placemark.country != null && placemark.country!.isNotEmpty) {
      addressParts.add(placemark.country!);
    }
    
    return addressParts.join(', ');
  }
} 