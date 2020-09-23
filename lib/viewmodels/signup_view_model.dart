import 'package:flutter/foundation.dart';
import 'package:timwan/constants/route_names.dart';
import 'package:timwan/locator.dart';
import 'package:timwan/services/authentication_service.dart';
import 'package:timwan/services/navigation_service.dart';
import 'package:timwan/viewmodels/base_model.dart';

class SignUpViewModel extends BaseModel {
  final AuthenticationService _authService = locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future signUp({
    @required String email,
    @required String password,
    @required String fullName,
  }) async {
    setIsLoading(true);
    setErrors("");

    var result = await _authService.signUpWithEmail(
      email: email,
      password: password,
      fullName: fullName,
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

  void navigateToSignIn() {
    _navigationService.navigateTo(SignInScreenRoute);
  }
}
