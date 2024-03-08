import 'package:auth_common/contracts/auth_repository_contract.dart';
import 'package:auth_common/contracts/user_auth_repo_contract.dart';
import 'package:auth_common/enums/auth_enums.dart';
import 'package:auth_ui/arguments/confirmation_code_arguments.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:localization/localization.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final AuthRepositoryContract _authRepositoryContract;
  final UserAuthRepoContract _userRepository;

  AuthenticationCubit({
    required AuthRepositoryContract authRepository,
    required UserAuthRepoContract userRepository,
  })  : _authRepositoryContract = authRepository,
        _userRepository = userRepository,
        super(AuthenticationInitial());

  late final String userEmail;
  late final String userPassword;

  void logIn(
      String email, String password, String? code, bool persistUser) async {
    emit(AuthenticationLoading());

    try {
      if (email == "" || password == "") {
        emit(LoginError(error: 'credentials-error'.i18n()));
      } else {
        SignInResult result =
            await _authRepositoryContract.signIn(email, password);
        handleSignInResult(result, email, password);
      }
    } catch (e) {
      emit(AuthenticationError());
    }
  }

  void handleSignInResult(SignInResult result, String email, String password) {
    if (result == SignInResult.signedIn) {
      emit(SuccessLogin());
    } else if (result == SignInResult.userNotConfirmedException) {
      emit(AuthenticationNotConfirmed(
        userData:
            ConfirmationCodeArguments(userEmail: email, userPassword: password),
      ));
    } else {
      emit(LoginError(error: _getErrorForSignIn(result)));
    }
  }

  void isUserAuthorized() async {
    try {
      emit(AuthenticationLoading());
      await _userRepository.fetchUser();
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthUserForm());
    }
  }

  String _getErrorForSignIn(SignInResult response) {
    switch (response) {
      case SignInResult.incorrectCredentials:
        return 'credentials-error'.i18n();
      case SignInResult.userChallengeException:
        return 'user-challenge-exception'.i18n();
      case SignInResult.newPasswordRequiredException:
        return 'new-password-required'.i18n();
      case SignInResult.incorrectStateException:
        return 'incorrect-state-exception-login'.i18n();
      case SignInResult.generalException:
      case SignInResult.userNotConfirmedException:
        return 'verify-account'.i18n();
      case SignInResult.codeMismatch:
        return 'code-mismatch'.i18n();
      default:
        return 'general-exception'.i18n();
    }
  }

  void signOut() async {
    try {
      emit(SignOutLoading());
      await _authRepositoryContract.signOut();
      emit(SignOutLoaded());
    } catch (e) {
      emit(SignOutError());
    }
  }
}
