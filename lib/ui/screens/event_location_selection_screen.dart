import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:timwan/ui/widgets/loading_button.dart';

class EventLocationSelectionScreen extends StatefulWidget {
  final double latitude;
  final double longitude;
  final double radius;

  const EventLocationSelectionScreen({
    Key key,
    this.latitude,
    this.longitude,
    this.radius,
  }) : super(key: key);

  @override
  _EventLocationSelectionScreenState createState() =>
      _EventLocationSelectionScreenState();
}

class _EventLocationSelectionScreenState
    extends State<EventLocationSelectionScreen> {
  double _value = 1;
  LatLng _position;
  Set<Circle> _circles = <Circle>[].toSet();

  @override
  void initState() {
    _value = widget.radius;
    _position = LatLng(
      widget.latitude,
      widget.longitude,
    );
    _circles = _buildCircle(_position, widget.radius);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _initialPosition = CameraPosition(
      zoom: _getZoom(),
      target: LatLng(
        widget.latitude,
        widget.longitude,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          GoogleMap(
            initialCameraPosition: _initialPosition,
            circles: _circles,
            myLocationButtonEnabled: true,
            onCameraMove: (position) {
              setState(() {
                _position = position.target;
                _circles = _buildCircle(_position, _value);
              });
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              height: 150,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Select Radius: ${_value.toStringAsFixed(2)} miles'),
                  SliderTheme(
                    data: SliderThemeData(
                      showValueIndicator: ShowValueIndicator.always,
                    ),
                    child: Slider(
                      min: 0.1,
                      max: 50.1,
                      value: _value,
                      divisions: 500,
                      label: '${_value.toStringAsFixed(2)} miles',
                      onChanged: (value) {
                        setState(() {
                          _value = value;
                          _circles = _buildCircle(_position, value);
                        });
                      },
                    ),
                  ),
                  LoadingButton(
                    title: 'Done',
                    onPressed: () {
                      Navigator.of(context).pop({
                        'radius': _value,
                        'latitude': _position.latitude,
                        'longitude': _position.longitude,
                      });
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Set<Circle> _buildCircle(LatLng center, double radius) {
    return [
      Circle(
        circleId: CircleId('$radius'),
        // converting miles -> meters
        radius: radius * 1609.34,
        center: center,
        fillColor: Colors.greenAccent.withOpacity(0.5),
        strokeWidth: 3,
      )
    ].toSet();
  }
  
  double _getZoom() {
    return (16 - log((_value * 2 * 1609.34) / 500) / log(2)).floorToDouble();
  }
}
