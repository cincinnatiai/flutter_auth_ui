import 'package:auth_ui/arguments/confirmation_code_arguments.dart';

enum RegistrationState {
  none,
  loading,
  error,
  emailError,
  passwordError,
  networkError,
  successfullyRegistered,
  accountExists,
  clearEmailError,
  clearPasswordError,
  strongPasswordError
}

abstract class RegistrationEvent {}

class RegistrationTapped implements RegistrationEvent {
  final String? email;
  final String? password;

  RegistrationTapped(this.email, this.password);
}

class RegistrationNone implements RegistrationEvent {}

class RegistrationLoading implements RegistrationEvent {}

class RegistrationLoaded implements RegistrationEvent {
  final String message;
  final ConfirmationCodeArguments userData;

  const RegistrationLoaded({
    required this.message,
    required this.userData,
  });
}

class RegistrationError implements RegistrationEvent {
  final String message;

  const RegistrationError({required this.message});
}
