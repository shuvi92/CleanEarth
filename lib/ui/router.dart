import 'package:flutter/material.dart';
import 'package:timwan/constants/route_names.dart';
import 'package:timwan/models/cleanup_event.dart';
import 'package:timwan/ui/screens/create_event_screen.dart';
import 'package:timwan/ui/screens/create_report_screen.dart';
import 'package:timwan/ui/screens/dashboard_screen.dart';
import 'package:timwan/ui/screens/event_details_screen.dart';
import 'package:timwan/ui/screens/event_location_selection_screen.dart';
import 'package:timwan/ui/screens/reports_map_screen.dart';
import 'package:timwan/ui/screens/signin_screen.dart';
import 'package:timwan/ui/screens/signup_screen.dart';
import 'package:timwan/ui/screens/user_details_screen.dart';
import 'package:timwan/ui/screens/user_events_screen.dart';
import 'package:timwan/ui/screens/user_reports_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SignInScreenRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: SignInScreen(),
      );
    case SignUpScreenRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: SignUpScreen(),
      );
    case DashboardScreenRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: DashboardScreen(),
      );
    case UserDetailsScreenRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: UserDetailsScreen(),
      );
    case EventDetailsScreenRoute:
      var event = settings.arguments as CleanupEvent;
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: EventDetailsScreen(
          event: event,
        ),
      );
    case CreateEventScreenRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: CreateEventScreen(),
      );
    case CreateReportScreenRoute:
      var eventUid = settings.arguments as String;
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: CreateReportScreen(
          eventUid: eventUid,
        ),
      );
    case ReportsMapScreenRoute:
      var args = settings.arguments as Map<String, dynamic>;
      var reports = args['reports'];
      var cb = args['cb'];
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: ReportsMapScreen(
          reports: reports,
          onMarkCleaned: cb,
        ),
      );
    case EventLocationSelectionScreenRoute:
      var args = settings.arguments as Map<String, double>;
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: EventLocationSelectionScreen(
          latitude: args['latitude'],
          longitude: args['longitude'],
          radius: args['radius'],
        ),
      );
    case UserReportsScreenRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: UserReportsScreen(),
      );
    case UserEventsScreenRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: UserEventsScreen(),
      );
    default:
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(
            child: Text('Error occured, please restart the app!'),
          ),
        ),
      );
  }
}

PageRoute _getPageRoute({String routeName, Widget viewToShow}) {
  return MaterialPageRoute(
    settings: RouteSettings(
      name: routeName,
    ),
    builder: (_) => viewToShow,
  );
}
