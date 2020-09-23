import 'package:flutter/foundation.dart';
import 'package:timwan/constants/route_names.dart';
import 'package:timwan/locator.dart';
import 'package:timwan/services/authentication_service.dart';
import 'package:timwan/services/navigation_service.dart';
import 'package:timwan/viewmodels/base_model.dart';

class SignInViewModel extends BaseModel {
  final AuthenticationService _auth = locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future signInAnonymously() async {
    setIsLoading(true);
    setErrors("");

    var result = await _auth.signInAnonymously();
    setIsLoading(false);

    if (result is bool) {
      if (result) {
        _navigationService.navigateTo(DashboardScreenRoute);
      } else {
        setErrors("Unknown error, please try again later.");
      }
    } else {
      setErrors(result);
    }
  }

  Future signInWithEmail({
    @required String email,
    @required String password,
  }) async {
    setIsLoading(true);
    setErrors("");

    var result = await _auth.signInWithEmail(
      email: email,
      password: password,
    );
    setIsLoading(false);

    if (result is bool) {
      if (result) {
        _navigationService.navigateTo(DashboardScreenRoute);
      } else {
        setErrors("Unknown error, please try again later.");
      }
    } else {
      setErrors(result);
    }
  }

  void navigateToSignUp() {
    _navigationService.navigateTo(SignUpScreenRoute);
  }
}
