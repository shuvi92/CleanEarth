import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:timwan/models/image_data.dart';

class TrashReport {
  /// Unique Id of report
  String uid;

  /// User Id of the trash reporter.
  String reporterUid;

  /// Tags assigned to the report
  List<String> tags;

  /// User Id of the user who cleaned up the trash report.
  String cleanerUid;

  /// Image data of the report, contains image url & filename.
  ImageData imageData;

  /// Location data of the report, contains geohash & coordinates.
  GeoFirePoint position;

  /// Id of the event if the report is associated with an event, else null.
  String eventUid;

  /// Timestamp of the report creation.
  DateTime createdAt;

  TrashReport({
    this.reporterUid,
    this.tags,
    this.cleanerUid,
    this.imageData,
    this.position,
    this.eventUid,
    this.createdAt,
  });

  TrashReport.fromJson(Map<String, dynamic> json, String reportUid) {
    uid = reportUid;
    reporterUid = json['reporter_uid'];
    tags = json['tags'].cast<String>();
    cleanerUid = json['cleaner_uid'];
    imageData = json['image_data'] != null
        ? new ImageData.fromJson(
            json['image_data'],
          )
        : null;
    position = json['position'] != null
        ? new GeoFirePoint(
            json['position']['geopoint'].latitude,
            json['position']['geopoint'].longitude,
          )
        : null;
    eventUid = json['event_uid'];
    createdAt = (json['created_at'] as Timestamp).toDate();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reporter_uid'] = this.reporterUid;
    data['tags'] = this.tags;
    data['cleaner_uid'] = this.cleanerUid;
    if (imageData != null) {
      data['image_data'] = this.imageData.toJson();
    }
    if (this.position != null) {
      data['position'] = this.position.data;
    }
    data['event_uid'] = this.eventUid;
    data['created_at'] = this.createdAt;
    return data;
  }
}
