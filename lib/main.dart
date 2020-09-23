import 'package:flutter/material.dart';
import 'package:timwan/locator.dart';
import 'package:timwan/services/navigation_service.dart';
import 'package:timwan/ui/router.dart';
import 'package:timwan/ui/screens/splash_screen.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CleanEarth',
      navigatorKey: locator<NavigationService>().navigationKey,
      onGenerateRoute: generateRoute,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}
