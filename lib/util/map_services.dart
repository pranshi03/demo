import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';

class MapServices {
  static MapServices? _instance;
  MapServices._internal();

  static MapServices get instance {
    _instance ??= MapServices._internal();
    return _instance!;
  }

  /// Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Check location permission status
  Future<LocationPermission> checkLocationPermission() async {
    return await Geolocator.checkPermission();
  }

  /// Request location permission
  Future<LocationPermission> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      // Open app settings
      await openAppSettings();
    }

    return permission;
  }

  /// Get current position
  Future<Position?> getCurrentPosition() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

      // Check permissions
      LocationPermission permission = await checkLocationPermission();
      if (permission == LocationPermission.denied) {
        permission = await requestLocationPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      return position;
    } catch (e) {
      print('Error getting current position: $e');
      return null;
    }
  }

  /// Get address from coordinates
  Future<String> getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        String address = '';

        if (place.street != null && place.street!.isNotEmpty) {
          address += '${place.street}, ';
        }

        if (place.subLocality != null && place.subLocality!.isNotEmpty) {
          address += '${place.subLocality}, ';
        }

        if (place.locality != null && place.locality!.isNotEmpty) {
          address += '${place.locality}, ';
        }

        if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) {
          address += '${place.administrativeArea}, ';
        }

        if (place.country != null && place.country!.isNotEmpty) {
          address += place.country!;
        }

        // Remove trailing comma and space if exists
        if (address.endsWith(', ')) {
          address = address.substring(0, address.length - 2);
        }

        return address.isNotEmpty ? address : 'Address not found';
      }

      return 'Address not found';
    } catch (e) {
      print('Error getting address: $e');
      return 'Error getting address';
    }
  }

  /// Get current location address
  Future<Map<String, dynamic>> getCurrentLocationAddress() async {
    try {
      Position? position = await getCurrentPosition();

      if (position != null) {
        String address = await getAddressFromCoordinates(
            position.latitude,
            position.longitude
        );

        return {
          'success': true,
          'latitude': position.latitude,
          'longitude': position.longitude,
          'address': address,
          'accuracy': position.accuracy,
          'timestamp': position.timestamp,
        };
      } else {
        return {
          'success': false,
          'error': 'Could not get current position',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Watch position changes (for real-time location updates)
  Stream<Position> watchPosition() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update every 10 meters
      ),
    );
  }

  /// Calculate distance between two points
  double calculateDistance(
      double startLatitude,
      double startLongitude,
      double endLatitude,
      double endLongitude,
      ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }
}