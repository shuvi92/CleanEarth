import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:timwan/models/reports_stats.dart';

class CleanupEvent {
  ///
  String uid;

  ///
  String title;

  ///
  String description;

  /// Cleanup event's owner data.
  Owner owner;

  ///
  DateTime startTime;

  ///
  DateTime endTime;

  /// Center point of cleanup event.
  GeoFirePoint position;

  /// Radius of cleanup event from center position.
  double radius;

  /// Computed stats for the specific event.
  ReportsStats stats;

  /// Number of volunteers registered for the event.
  int volunteerCount;

  /// Timestamp of the report creation.
  DateTime createdAt;

  CleanupEvent({
    @required this.title,
    this.description,
    @required this.owner,
    this.startTime,
    this.endTime,
    @required this.position,
    @required this.radius,
    this.stats,
    this.volunteerCount,
    this.createdAt,
  });

  CleanupEvent.fromJson(Map<String, dynamic> json, String _uid) {
    uid = _uid;
    title = json['title'];
    description = json['description'];
    owner = json['owner'] != null
        ? new Owner.fromJson(
            json['owner'],
          )
        : null;
    startTime = (json['start_time'] as Timestamp).toDate();
    endTime = (json['end_time'] as Timestamp).toDate();
    position = json['position'] != null
        ? new GeoFirePoint(
            json['position']['geopoint'].latitude,
            json['position']['geopoint'].longitude,
          )
        : null;
    radius = json['radius'].toDouble();
    stats = json['stats'] != null
        ? new ReportsStats.fromJson(
            json['stats'],
          )
        : null;
    volunteerCount = json['volunteer_count'];
    createdAt = (json['created_at'] as Timestamp).toDate();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    if (this.owner != null) {
      data['owner'] = this.owner.toJson();
    }
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    if (this.position != null) {
      data['position'] = this.position.data;
    }
    data['radius'] = this.radius;
    if (this.stats != null) {
      data['stats'] = this.stats.toJson();
    }
    data['volunteer_count'] = volunteerCount;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class Owner {
  String fullName;
  String uid;

  Owner({this.fullName, this.uid});

  Owner.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['full_name'] = this.fullName;
    data['uid'] = this.uid;
    return data;
  }
}
