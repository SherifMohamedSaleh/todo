import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'connectivity.dart';
import 'dio_client.dart';

class ApiDiRegister {
  static CancelToken get cancelationToken => GetIt.I.get<CancelToken>();
  static DioClient get apiClient => GetIt.I.get<DioClient>();
  static InternetConnectionChecker get checkerClient =>
      GetIt.I.get<InternetConnectionChecker>();

  static NetworkInfo get connectiviyClient => GetIt.I.get<NetworkInfo>();

  static initApiClient() {
    GetIt.I.registerSingleton<CancelToken>(CancelToken());
    GetIt.I.registerSingleton<DioClient>(DioClient());
    GetIt.I.registerSingleton<InternetConnectionChecker>(
        InternetConnectionChecker());
    GetIt.I.registerSingleton<NetworkInfo>(
        NetworkInfoImpl(connectionChecker: checkerClient));
  }

  static renewCancellationToken() {
    var isRegistered = GetIt.I.isRegistered<CancelToken>();
    if (isRegistered) {
      GetIt.I.unregister<CancelToken>();
    }
    GetIt.I.registerSingleton<CancelToken>(CancelToken());
  }
}
