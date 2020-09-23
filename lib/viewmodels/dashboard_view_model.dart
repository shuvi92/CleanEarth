import 'dart:async';

import 'package:timwan/constants/route_names.dart';
import 'package:timwan/locator.dart';
import 'package:timwan/models/cleanup_event.dart';
import 'package:timwan/models/reports_stats.dart';
import 'package:timwan/models/trash_report.dart';
import 'package:timwan/services/authentication_service.dart';
import 'package:timwan/services/firestore_service.dart';
import 'package:timwan/services/location_service.dart';
import 'package:timwan/services/navigation_service.dart';
import 'package:timwan/utils.dart';
import 'package:timwan/viewmodels/base_model.dart';

class DashboardViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final LocationService _locationService = locator<LocationService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  // @deprecated
  ReportsStats _stats = ReportsStats();
  ReportsStats get stats => _stats;

  List<TrashReport> _reports;
  List<TrashReport> get reports => _reports;

  List<CleanupEvent> _events;
  List<CleanupEvent> get events => _events;

  StreamSubscription _reportsStreamSubscription;
  StreamSubscription _eventsStreamSubscription;

  Future initilize() async {
    _locationService.listenToUserLocation();
    await listenToNearbyReports();
    await listenToNearbyEvents();
  }

  Future listenToNearbyReports() async {
    setIsLoading(true);
    setErrors("");

    var position = await _locationService.getUserLocation();
    _reportsStreamSubscription = _firestoreService
        .listenToNearbyReports(point: position)
        .listen((reports) {
      if (reports != null) {
        _reports = reports;
        _stats = calculateStats(reports);
      }

      setIsLoading(false);
    });
  }

  Future listenToNearbyEvents() async {
    setIsLoading(true);
    setErrors("");

    var position = await _locationService.getUserLocation();
    _eventsStreamSubscription = _firestoreService
        .listenToNearbyEvents(point: position)
        .listen((events) {
      if (events != null && events.length > 0) {
        _events = events;
      }

      setIsLoading(false);
    });
  }

  String getDistance(CleanupEvent event) {
    return _locationService.getDistance(
      latitude: event.position.latitude,
      longitude: event.position.longitude,
    );
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
    _eventsStreamSubscription?.cancel();
    _reportsStreamSubscription?.cancel();
    _firestoreService.cancelNearbyEventsSubscription();
    _firestoreService.cancelNearbyReportsSubscription();
    _locationService.cancelLocationStream();
    super.dispose();
  }

  void navigateToCreateReport() {
    _navigationService.navigateTo(CreateReportScreenRoute);
  }

  void navigateToUserDetails() {
    _navigationService.navigateTo(UserDetailsScreenRoute);
  }

  void navigateToEventDetails(CleanupEvent event) {
    _navigationService.navigateTo(
      EventDetailsScreenRoute,
      arguments: event,
    );
  }
}
