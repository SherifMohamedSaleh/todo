import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'api_di_register.dart';
import 'api_method.dart';
import 'endpoint.dart';

class DioClient implements ApiMethods {
  static dynamic _parseAndDecode(String response) {
    return jsonDecode(response) as dynamic;
  }

  static Future<dynamic> parseJson(String text) {
    return compute(_parseAndDecode, text);
  }

  Dio client = Dio();
  DioClient() {
    client
      ..options.baseUrl = EndPoints.baseUrl
      ..options.responseType = ResponseType.plain
      ..options.followRedirects = false
      ..options.sendTimeout = const Duration(minutes: 2)
      ..options.receiveTimeout = const Duration(minutes: 2)
      ..options.validateStatus = (status) {
        return status! < 500;
      }
      ..transformer = (BackgroundTransformer()..jsonDecodeCallback = parseJson)
      ..interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: true,
          error: true,
        ),
      );
  }

  @override
  Future get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await client.get(path,
          queryParameters: queryParameters,
          cancelToken: ApiDiRegister.cancelationToken);

      return response.data;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        EasyLoading.dismiss();
        // CustomDialogs.showError(LocaleKeys.timeOutError.i18n());
      }
    }
  }

  @override
  Future post(
    String path, {
    Map<String, dynamic>? body,
    bool isFormData = false,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await client.post(path,
          options: options,
          queryParameters: queryParameters,
          data: isFormData ? FormData.fromMap(body!) : body,
          cancelToken: ApiDiRegister.cancelationToken);
      return response.data;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        EasyLoading.dismiss();
        // CustomDialogs.showError(LocaleKeys.timeOutError.i18n());
      }
    }
  }

  @override
  Future put(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await client.put(path,
          queryParameters: queryParameters,
          data: body,
          cancelToken: ApiDiRegister.cancelationToken);
      return response.data;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.connectionTimeout) {
        EasyLoading.dismiss();
        // CustomDialogs.showError(LocaleKeys.assetsTimeOutError.i18n());
      } else if (e.type == DioExceptionType.connectionError) {
        EasyLoading.dismiss();
        // CustomDialogs.showError(LocaleKeys.serverError.i18n());
      } else {
        EasyLoading.dismiss();
        // CustomDialogs.showError(e.message.toString());
      }
    }
  }
}
