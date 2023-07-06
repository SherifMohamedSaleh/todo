import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/login_request_model.dart';
import '../repositories/auth_di_register.dart';
import 'login_states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  final repository = AuthDiRegister.authRepository;

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void loginUser(LoginRequestModel model) async {
    emit(LoginLoadingState());
    try {
      var result = await repository.loginWithEmailAndPassword(model);
      if (result == null) {
        emit(LoginErrorState());
      } else {
        emit(LoginSuccessState());
      }
    } catch (error) {
      emit(LoginErrorState());
    }
  }

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(LoginChangePasswordVisibilityState());
  }
}
