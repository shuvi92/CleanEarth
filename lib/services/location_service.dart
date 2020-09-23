import 'dart:async';

import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';

class LocationService {
  GeoFirePoint _currentLocation;
  GeoFirePoint get currentLocation => _currentLocation;

  StreamSubscription<LocationData> _locationStream;

  Location location = new Location();

  Future<GeoFirePoint> getUserLocation() async {
    try {
      LocationData _locationData = await location.getLocation();
      _currentLocation = GeoFirePoint(
        _locationData.latitude,
        _locationData.longitude,
      );
    } catch (e) {
      print('Could not get location: ${e.toString()}');
    }
    return _currentLocation;
  }

  Future listenToUserLocation() async {
    try {
      location.requestPermission().then((value) {
        if (value == PermissionStatus.granted) {
          _locationStream = location.onLocationChanged.listen((_locationData) {
            if (_locationData != null) {
              _currentLocation = GeoFirePoint(
                _locationData.latitude,
                _locationData.longitude,
              );
            }
          });
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void cancelLocationStream() {
    if (_locationStream != null) {
      _locationStream.cancel();
    }
  }

  String getDistance({
    double latitude,
    double longitude,
  }) {
    if (_currentLocation == null) return 'unknown';
    return _currentLocation
        .distance(
          lat: latitude,
          lng: longitude,
        )
        .toStringAsFixed(2);
  }
}
