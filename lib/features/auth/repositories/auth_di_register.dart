import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'auth_repository.dart';

class AuthDiRegister {
  static AuthRepository get authRepository => GetIt.I.get<AuthRepository>();
  static FlutterSecureStorage get storage =>
      GetIt.I.get<FlutterSecureStorage>();

  static void initAuthDi() {
    // GetIt.I.registerSingleton<AuthHelper>(AuthHelper());
    GetIt.I.registerSingleton<AuthRepository>(AuthRepository());
    AndroidOptions getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
    IOSOptions getIosOptions() =>
        const IOSOptions(accessibility: KeychainAccessibility.first_unlock);
    GetIt.I.registerSingleton<FlutterSecureStorage>(FlutterSecureStorage(
        aOptions: getAndroidOptions(), iOptions: getIosOptions()));
  }
}
