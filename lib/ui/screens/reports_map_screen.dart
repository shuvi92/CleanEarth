import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:timwan/models/trash_report.dart';

class ReportsMapScreen extends StatelessWidget {
  final List<TrashReport> reports;
  final Function({String reportUid}) onMarkCleaned;

  const ReportsMapScreen({
    Key key,
    this.reports,
    this.onMarkCleaned,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LatLng _center = LatLng(30, 40);
    if (reports != null && reports.isNotEmpty) {
      _center = LatLng(
        reports.first.position.latitude,
        reports.first.position.longitude,
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.terrain,
            markers: _createMarkers(),
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 10,
            ),
          ),
          SizedBox(
            height: 80.0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Set<Marker> _createMarkers() {
    if (reports == null) return <Marker>[].toSet();
    return reports
        .map((e) => Marker(
            markerId: MarkerId(e.uid),
            infoWindow: InfoWindow(
              title: e.tags.toString(),
              snippet: (e.cleanerUid == null || e.cleanerUid.isEmpty)
                  ? 'Tap to mark it cleaned!'
                  : 'Report is cleaned!',
              onTap: () {
                if (e.cleanerUid == null || e.cleanerUid.isEmpty)
                  onMarkCleaned(reportUid: e.uid);
              },
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              (e.cleanerUid == null || e.cleanerUid.isEmpty)
                  ? BitmapDescriptor.hueRed
                  : BitmapDescriptor.hueGreen,
            ),
            position: LatLng(
              e.position.latitude,
              e.position.longitude,
            )))
        .toSet();
  }
}
