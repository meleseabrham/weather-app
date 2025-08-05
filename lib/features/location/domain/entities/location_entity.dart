class LocationEntity {
  final double latitude;
  final double longitude;
  final String? cityName;
  final String? countryCode;
  final String? countryName;
  final String? stateName;
  final String? postalCode;
  final String? address;

  const LocationEntity({
    required this.latitude,
    required this.longitude,
    this.cityName,
    this.countryCode,
    this.countryName,
    this.stateName,
    this.postalCode,
    this.address,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocationEntity &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.cityName == cityName &&
        other.countryCode == countryCode &&
        other.countryName == countryName &&
        other.stateName == stateName &&
        other.postalCode == postalCode &&
        other.address == address;
  }

  @override
  int get hashCode {
    return latitude.hashCode ^
        longitude.hashCode ^
        cityName.hashCode ^
        countryCode.hashCode ^
        countryName.hashCode ^
        stateName.hashCode ^
        postalCode.hashCode ^
        address.hashCode;
  }

  @override
  String toString() {
    return 'LocationEntity(latitude: $latitude, longitude: $longitude, cityName: $cityName, countryCode: $countryCode, countryName: $countryName, stateName: $stateName, postalCode: $postalCode, address: $address)';
  }
} 