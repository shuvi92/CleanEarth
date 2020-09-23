import 'package:get_it/get_it.dart';
import 'package:timwan/services/authentication_service.dart';
import 'package:timwan/services/cloud_storage_service.dart';
import 'package:timwan/services/firestore_service.dart';
import 'package:timwan/services/image_picker_service.dart';
import 'package:timwan/services/location_service.dart';
import 'package:timwan/services/navigation_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => FirestoreService());
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => LocationService());
  locator.registerLazySingleton(() => CloudStorageService());
  locator.registerLazySingleton(() => ImagePickerService());
}
