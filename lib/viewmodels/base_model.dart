import 'package:flutter/foundation.dart';
import 'package:timwan/locator.dart';
import 'package:timwan/models/user.dart';
import 'package:timwan/services/authentication_service.dart';

class BaseModel extends ChangeNotifier {
  final _auth = locator<AuthenticationService>();

  User get currentUser => _auth.currentUser;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errors = "";
  String get errors => _errors;
  bool get hasErrors => _errors.isNotEmpty;

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setErrors(String value) {
    _errors = value;
    notifyListeners();
  }
}
