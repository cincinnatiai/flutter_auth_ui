import 'package:flutter/cupertino.dart';

@immutable
abstract class PasswordScreenEvent {}

class FocusRemovedEntered implements PasswordScreenEvent {
  final String? password;
  final String? email;

  FocusRemovedEntered(this.password, this.email);
}

class EmailEditingBegun implements PasswordScreenEvent {}

class PasswordEditingBegun implements PasswordScreenEvent {}

class CodeEditingBegun implements PasswordScreenEvent {}

class RegisterTapped implements PasswordScreenEvent {}

class ShowPasswordAndCode implements PasswordScreenEvent {}

class RetrivePasswordButtonWithCodeTapped implements PasswordScreenEvent {
  final String? email;
  final String? password;
  final String? code;

  RetrivePasswordButtonWithCodeTapped(this.email, this.password, this.code);
}
