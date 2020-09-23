import 'dart:async';

import 'package:timwan/constants/route_names.dart';
import 'package:timwan/locator.dart';
import 'package:timwan/models/reports_stats.dart';
import 'package:timwan/models/trash_report.dart';
import 'package:timwan/models/user.dart';
import 'package:timwan/services/authentication_service.dart';
import 'package:timwan/services/firestore_service.dart';
import 'package:timwan/services/navigation_service.dart';
import 'package:timwan/utils.dart';
import 'package:timwan/viewmodels/base_model.dart';

class EventDetailsViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();

  bool _isUserPartOfEvent = false;
  bool get isUserPartOfEvent => _isUserPartOfEvent;

  StreamSubscription _eventStreamSubscription;
  List<TrashReport> _reports;
  List<TrashReport> get reports => _reports;

  StreamSubscription _volunteersStreamSubscription;
  List<User> _volunteers;
  List<User> get volunteers => _volunteers;

  ReportsStats _stats = ReportsStats(cleaned: 0, reported: 0);
  ReportsStats get stats => _stats;

  void initilize(String eventUid) async {
    setIsLoading(true);
    setErrors("");

    var result = await _firestoreService.isUserPartOfEvent(
      eventUid: eventUid,
      userUid: _authenticationService.currentUser.uid,
    );

    _eventStreamSubscription = _firestoreService
        .listenToReportsFromEvent(eventUid: eventUid)
        .listen((data) {
      if (data != null) {
        _reports = data;
        _stats = calculateStats(_reports);
        setIsLoading(false);
      }
    });

    _volunteersStreamSubscription = _firestoreService
        .listenToVolunteersFromEvent(eventUid: eventUid)
        .listen((data) {
      if (data != null) {
        _volunteers = data;
        setIsLoading(true);
      }
    });

    setIsLoading(false);

    if (result is bool) {
      _isUserPartOfEvent = result;
      notifyListeners();
    }
  }

  void onFabPressed(String eventUid) {
    if (_isUserPartOfEvent) {
      _navigationService.navigateTo(
        CreateReportScreenRoute,
        arguments: eventUid,
      );
    } else {
      setIsLoading(true);
      _firestoreService.addUserToEvent(
        eventUid: eventUid,
        userUid: _authenticationService.currentUser.uid,
        fullName: _authenticationService.currentUser.fullName,
      );
      initilize(eventUid);
      setIsLoading(false);
    }
  }

  void markCleanedCallback({String reportUid}) {
    setIsLoading(true);
    _firestoreService.markReportCleaned(
      reportUid: reportUid,
      userUid: _authenticationService.currentUser.uid,
    );
    setIsLoading(false);
  }

  void navigateToReportsMapScreen() {
    _navigationService.navigateTo(
      ReportsMapScreenRoute,
      arguments: {
        'reports': _reports,
        'cb': markCleanedCallback,
      },
    );
  }

  @override
  void dispose() {
    _eventStreamSubscription?.cancel();
    _volunteersStreamSubscription?.cancel();
    _firestoreService.cancelReportsFromEventSubscription();
    _firestoreService.cancelVolunteerssFromEventSubscription();
    super.dispose();
  }
}
