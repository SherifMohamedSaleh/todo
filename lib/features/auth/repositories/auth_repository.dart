import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:todo_app/features/auth/models/login_response_model.dart';

import '../../../core/api/api_di_register.dart';
import '../../../core/api/endpoint.dart';
import '../models/login_request_model.dart';
import 'auth_di_register.dart';

class AuthRepository {
  final _client = ApiDiRegister.apiClient;
  final keyToken = 'token';

  Future<LoginResponseModel?> loginWithEmailAndPassword(
      LoginRequestModel model) async {
    try {
      var jsonResponse = await _client.post(EndPoints.login,
          body: model.toJson(), isFormData: true);

      var decoded = jsonDecode(jsonResponse);
      LoginResponseModel response = LoginResponseModel.fromJson(decoded);
      saveToken(response.data?.token ?? "");

      return response;
    } catch (e, _) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

// Write token value
  saveToken(String token) async {
    await AuthDiRegister.storage.write(
      key: keyToken,
      value: token,
    );
  }

// Read token value
  Future<String> readToken() async {
    String? value = await AuthDiRegister.storage.read(key: keyToken);
    return value ?? "";
  }
}
