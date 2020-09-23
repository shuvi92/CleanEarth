import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:timwan/models/cleanup_event.dart';
import 'package:timwan/models/trash_report.dart';
import 'package:timwan/models/user.dart';

class FirestoreService {
  final CollectionReference _usersCollectionRef =
      Firestore.instance.collection('users');
  final CollectionReference _eventsCollectionRef =
      Firestore.instance.collection('events');
  final CollectionReference _reportsCollectionRef =
      Firestore.instance.collection('reports');
  final CollectionReference _volunteersCollectionRef =
      Firestore.instance.collection('volunteers');

  Geoflutterfire geo = Geoflutterfire();

  /// key in document snapshot where location data is stored
  String field = 'position';

  StreamSubscription _nearbyReportsSubscription;
  final StreamController<List<TrashReport>> _nearbyReportsController =
      StreamController<List<TrashReport>>.broadcast();

  StreamSubscription _nearbyEventsSubscription;
  final StreamController<List<CleanupEvent>> _nearbyEventsController =
      StreamController<List<CleanupEvent>>.broadcast();

  // This will hold the stream of reports of current selected event
  StreamSubscription _reportsFromEventSubscription;
  final StreamController<List<TrashReport>> _reportsFromEventController =
      StreamController<List<TrashReport>>.broadcast();

  // This will hold the stream of volunteers of current selected event
  StreamSubscription _volunteersFromEventSubscription;
  final StreamController<List<User>> _volunteersFromEventController =
      StreamController<List<User>>.broadcast();

  Future createEvent(CleanupEvent event) async {
    try {
      await _eventsCollectionRef.add(event.toJson());
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }
      return e.toString();
    }
  }

  Future createReport(TrashReport report) async {
    try {
      await _reportsCollectionRef.add(report.toJson());
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }
      return e.toString();
    }
  }

  Stream<List<CleanupEvent>> listenToNearbyEvents({
    @required GeoFirePoint point,
    double radius = 50.0,
  }) {
    try {
      _nearbyEventsSubscription = geo
          .collection(collectionRef: _eventsCollectionRef)
          .within(center: point, radius: radius, field: field)
          .listen((snapshot) {
        var events = snapshot
            .map((document) => CleanupEvent.fromJson(
                  document.data,
                  document.documentID,
                ))
            .toList();

        _nearbyEventsController.add(events);
      });
    } catch (e) {
      print(e.toString());
    }

    return _nearbyEventsController.stream;
  }

  void cancelNearbyEventsSubscription() {
    _nearbyEventsSubscription?.cancel();
  }

  Stream<List<TrashReport>> listenToNearbyReports({
    @required GeoFirePoint point,
    double radius = 25.0,
  }) {
    try {
      _nearbyReportsSubscription = geo
          .collection(collectionRef: _reportsCollectionRef)
          .within(
            center: point,
            radius: radius,
            field: field,
            strictMode: true,
          )
          .listen((snapshot) {
        if (snapshot.isNotEmpty) {
          var reports = snapshot
              .map((document) => TrashReport.fromJson(
                    document.data,
                    document.documentID,
                  ))
              .toList();

          _nearbyReportsController.add(reports);
        }
      });
    } catch (e) {
      print(e.toString());
    }

    return _nearbyReportsController.stream;
  }

  void cancelNearbyReportsSubscription() {
    _nearbyReportsSubscription?.cancel();
  }

  Future createUser(User user) async {
    try {
      await _usersCollectionRef.document(user.uid).setData(user.toJson());
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }
      return e.toString();
    }
  }

  Future getUser(String uid) async {
    try {
      var userData = await _usersCollectionRef.document(uid).get();
      return User.fromJson(userData.data);
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }
      return e.toString();
    }
  }

  Future getUsersReports({String uid}) async {
    try {
      var reports = await _reportsCollectionRef
          .where(
            'reporter_uid',
            isEqualTo: uid,
          )
          .getDocuments();

      if (reports.documents.isNotEmpty) {
        return reports.documents
            .map(
              (snapshot) => TrashReport.fromJson(
                snapshot.data,
                snapshot.documentID,
              ),
            )
            .toList();
      }
    } catch (e) {
      return e.message;
    }
  }

  Future getUsersCleanedReports({String uid}) async {
    try {
      var reports = await _reportsCollectionRef
          .where(
            'cleaner_uid',
            isEqualTo: uid,
          )
          .getDocuments();

      if (reports.documents.isNotEmpty) {
        return reports.documents
            .map(
              (snapshot) => TrashReport.fromJson(
                snapshot.data,
                snapshot.documentID,
              ),
            )
            .toList();
      }
    } catch (e) {
      return e.message;
    }
  }

  Future getUsersCreatedEvents({String uid}) async {
    try {
      var events = await _eventsCollectionRef
          .where('owner.uid', isEqualTo: uid)
          .getDocuments();

      if (events.documents.isNotEmpty) {
        return events.documents
            .map(
              (snapshot) => CleanupEvent.fromJson(
                snapshot.data,
                snapshot.documentID,
              ),
            )
            .toList();
      }
    } catch (e) {
      return e.message;
    }
  }

  Future getUsersVolunteeredEvents({String uid}) async {
    try {
      var eventUids = await _volunteersCollectionRef
          .where(
            'user_uid',
            isEqualTo: uid,
          )
          .getDocuments();

      if (eventUids.documents.isNotEmpty) {
        List<String> onlyUids = eventUids.documents
            .map(
              (e) => e.data['event_uid'].toString(),
            )
            .toList();

        // resolved all promises of `onlyUids`
        var events = await Future.wait(
          onlyUids.map((e) => _eventsCollectionRef.document(e).get()),
        );

        if (events.isNotEmpty) {
          return events
              .map(
                (snapshot) => CleanupEvent.fromJson(
                  snapshot.data,
                  snapshot.documentID,
                ),
              )
              .toList();
        }
      }
    } catch (e) {
      return e.message;
    }
  }

  Future addUserToEvent({
    String eventUid,
    String userUid,
    String fullName,
  }) async {
    if (eventUid.isEmpty || userUid.isEmpty) {
      return;
    }

    try {
      await _volunteersCollectionRef.document('${eventUid}_$userUid').setData({
        'event_uid': eventUid,
        'user_uid': userUid,
        'full_name': fullName,
      });
    } catch (e) {
      return e.message;
    }
  }

  Future markReportCleaned({String reportUid, String userUid}) async {
    try {
      await _reportsCollectionRef.document(reportUid).setData({
        'cleaner_uid': userUid,
      }, merge: true);
    } catch (e) {
      return e.message;
    }
  }

  Stream<List<TrashReport>> listenToReportsFromEvent({
    String eventUid,
  }) {
    try {
      _reportsFromEventSubscription = _reportsCollectionRef
          .where(
            'event_uid',
            isEqualTo: eventUid,
          )
          .snapshots()
          .listen((snapshot) {
        var reports = snapshot.documents
            .map((doc) => TrashReport.fromJson(
                  doc.data,
                  doc.documentID,
                ))
            .toList();

        _reportsFromEventController.add(reports);
      });
    } catch (e) {
      print(e.message);
    }

    return _reportsFromEventController.stream;
  }

  void cancelReportsFromEventSubscription() {
    _reportsFromEventSubscription?.cancel();
  }

  Stream<List<User>> listenToVolunteersFromEvent({
    String eventUid,
  }) {
    try {
      _volunteersFromEventSubscription = _volunteersCollectionRef
          .where(
            'event_uid',
            isEqualTo: eventUid,
          )
          .snapshots()
          .listen((snapshot) {
        var users = snapshot.documents
            .map((e) => User(
                  uid: e.data['user_uid'],
                  fullName: e.data['full_name'],
                ))
            .toList();

        _volunteersFromEventController.add(users);
      });
    } catch (e) {
      print(e.message);
    }

    return _volunteersFromEventController.stream;
  }

  void cancelVolunteerssFromEventSubscription() {
    _volunteersFromEventSubscription?.cancel();
  }

  Future isUserPartOfEvent({
    String eventUid,
    String userUid,
  }) async {
    try {
      var result =
          await _volunteersCollectionRef.document('${eventUid}_$userUid').get();

      // if "eventUid_userUid" exists
      // the user is part of the event
      return result.exists;
    } catch (e) {
      return e.message;
    }
  }
}
