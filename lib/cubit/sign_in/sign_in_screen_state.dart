import 'package:flutter/cupertino.dart';

enum LoginScreenState {
  none,
  loading,
  showLoginCodeInput,
  emailError,
  passwordError,
  loginErrorPasswordOrEmail,
  networkError,
  loggedIn,
  clearEmailError,
  clearPasswordError,
  clearCodeError,
  notConfirmedError,
  loginWithBiometrics
}

@immutable
abstract class LoginScreenEvent {}

class FocusRemovedEntered implements LoginScreenEvent {
  final String? password;
  final String? email;

  FocusRemovedEntered(this.password, this.email);
}

class EmailEditingBegun implements LoginScreenEvent {}

class PasswordEditingBegun implements LoginScreenEvent {}

class CodeEditingBegun implements LoginScreenEvent {}

class ForgotPasswordTapped implements LoginScreenEvent {}

class RegisterTapped implements LoginScreenEvent {}

class ShowLoginCode implements LoginScreenEvent {}

class LoginButtonWithCodeTapped implements LoginScreenEvent {
  final String? email;
  final String? password;
  final String? code;

  LoginButtonWithCodeTapped(this.email, this.password, this.code);
}
