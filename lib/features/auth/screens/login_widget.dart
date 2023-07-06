// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:todo_app/features/auth/cubit/login_cubit.dart';
import 'package:todo_app/features/auth/models/login_request_model.dart';

import '../../../core/api/api_di_register.dart';
import '../../../core/dialog_function.dart';
import '../../../core/app_widget.dart';
import '../cubit/login_states.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController usernameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  validateFieldNotEmpty(String? value, String error) {
    if (value == null || value.isEmpty == true || value.trim().isEmpty) {
      return error;
    }

    return null;
  }

  _onLoginButtonPressed(
      {required String email,
      required String password,
      required GlobalKey<FormState> formKey,
      required BuildContext context}) async {
    if (await ApiDiRegister.connectiviyClient.isConnected) {
      if (formKey.currentState!.validate() == true) {
        // login user with firebase firestore
        LoginCubit.get(context).loginUser(LoginRequestModel(
            email: "flutter-task@test.com", password: "12345678"));
      }
    } else {
      CustomDialogs.showError("noInternet", context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginLoadingState) {
            debugPrint(' login  Loading');
            EasyLoading.show(
                status: "loading",
                maskType: EasyLoadingMaskType.black,
                dismissOnTap: false);
          } else if (state is LoginSuccessState) {
            EasyLoading.dismiss();
            CustomDialogs.showConfirm(
              confirmMsg: "you have logedin successfully",
              context: context,
              onOkFunction: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            );

            // TODO add something here
          } else if (state is LoginWrongPasswordState) {
            EasyLoading.dismiss();

            CustomDialogs.showWarning("wrong password", context: context);
          } else if (state is LoginErrorState) {
            debugPrint(' error state login');
            EasyLoading.dismiss();

            CustomDialogs.showWarning("wrong user please try again",
                context: context);
          }
        },
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.all(30),
            height: 600,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  AppWidgets.textFormField(
                    keyValue: "usernameLabel",
                    controller: usernameController,
                    labelText: "usernameLabel",
                    validator: (value) => validateFieldNotEmpty(
                      value,
                      "usernameEmptyMessage",
                    ),
                    keyboardType: TextInputType.text,
                    prefixIcon: Icons.email,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  AppWidgets.textFormField(
                    keyValue: "passwordLabel",
                    controller: passwordController,
                    labelText: "passwordLabel",
                    suffixIcon: IconButton(
                      onPressed: () =>
                          LoginCubit.get(context).changePasswordVisibility(),
                      icon: Icon(
                        LoginCubit.get(context).suffix,
                      ),
                    ),
                    obscureText: LoginCubit.get(context).isPassword,
                    validator: (value) => validateFieldNotEmpty(
                      value,
                      "passwordEmptyMessage",
                    ),
                    prefixIcon: Icons.lock,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: AppWidgets.outlineButton(
                          keyValue: "loginButton",
                          onPressed: () => _onLoginButtonPressed(
                              formKey: _formKey,
                              email: usernameController.text,
                              password: passwordController.text,
                              context: context),
                          text: "loginButton",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
