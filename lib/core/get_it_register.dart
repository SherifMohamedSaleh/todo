import 'package:get_it/get_it.dart';

import '../features/auth/repositories/auth_di_register.dart';

import 'api/api_di_register.dart';

class GetItRegister {
  static Future<void> setupGetIt() async {
    GetIt.I.allowReassignment = true;

    ApiDiRegister.initApiClient();

    AuthDiRegister.initAuthDi();
  }
}
