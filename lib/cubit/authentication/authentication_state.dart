part of 'authentication_cubit.dart';

sealed class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

final class AuthenticationInitial extends AuthenticationState {}

final class SuccessLogin extends AuthenticationState {}

final class LoginError extends AuthenticationState {
  final String error;

  const LoginError({required this.error});

  @override
  List<Object> get props => [error];
}

final class AuthenticationError extends AuthenticationState {}

final class AuthenticationLoading extends AuthenticationState {}

final class SignOutLoading extends AuthenticationState {}

final class SignOutLoaded extends AuthenticationState {}

final class AuthenticationNotConfirmed extends AuthenticationState {
  final ConfirmationCodeArguments userData;

  const AuthenticationNotConfirmed({required this.userData});

  @override
  List<Object> get props => [userData];
}

final class SignOutError extends AuthenticationState {}
