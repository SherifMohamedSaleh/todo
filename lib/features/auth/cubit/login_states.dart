abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class LoginSuccessState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginErrorState extends LoginStates {}

class LoginWrongPasswordState extends LoginStates {}

class LoginChangePasswordVisibilityState extends LoginStates {}
