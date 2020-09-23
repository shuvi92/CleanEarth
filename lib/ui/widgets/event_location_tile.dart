import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EventLocationTile extends StatelessWidget {
  final double latitude;
  final double longitude;
  final double radius;

  const EventLocationTile({
    Key key,
    this.radius,
    this.latitude,
    this.longitude,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _initialPosition = CameraPosition(
      target: LatLng(
        latitude,
        longitude,
      ),
      zoom: _getZoom(),
    );
    return Container(
      child: Card(
        child: GoogleMap(
          mapType: MapType.terrain,
          initialCameraPosition: _initialPosition,
          circles: _createCircle(),
        ),
      ),
    );
  }

  Set<Circle> _createCircle() {
    return [
      Circle(
        circleId: CircleId('center'),
        fillColor: Colors.greenAccent.withOpacity(0.5),
        // converting miles -> meters
        radius: radius * 1609.34,
        strokeWidth: 3,
        center: LatLng(
          latitude,
          longitude,
        ),
      )
    ].toSet();
  }

  double _getZoom() {
    return (16 - log((radius * 2 * 1609.34) / 500) / log(2)).floorToDouble();
  }
}
