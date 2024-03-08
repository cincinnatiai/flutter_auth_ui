import 'package:auth_common/contracts/auth_formatter_contract.dart';
import 'package:auth_common/contracts/auth_repository_contract.dart';
import 'package:auth_common/enums/auth_enums.dart';
import 'package:bloc/bloc.dart';
import 'package:common/reusable_classes/error_handler.dart';
import 'package:common/reusable_classes/reusable_state.dart';
import 'package:localization/localization.dart';

class EmailCodeCubit extends Cubit<ReusableState> {
  final AuthRepositoryContract _authRepo;
  final AuthFormatterContract _formValidator;
  EmailCodeCubit({
    required AuthRepositoryContract authRepo,
    required AuthFormatterContract formValidator,
  })  : _authRepo = authRepo,
        _formValidator = formValidator,
        super(ReusableInitialState());

  void confirmEmail(
      String email, String password, String confirmationCode) async {
    emit(ReusableLoadingState());
    try {
      if (!validateEmail(email) || !validatePassword(password)) {
        return;
      }
      final SignInResult result =
          await _authRepo.signInWithCode(email, password, confirmationCode);
      if (result == SignInResult.signedIn) {
        emit(const ReusableLoadedState());
      } else {
        emit(ReusableErrorState(error: _getErrorForSignIn(result)));
      }
    } catch (e) {
      ErrorHandler.refactorError(e);
      emit(ReusableErrorState(error: e.toString()));
    }
  }

  String _getErrorForSignIn(SignInResult result) {
    switch (result) {
      case SignInResult.codeMismatch:
        return 'code-mismatch'.i18n();
      case SignInResult.incorrectCredentials:
        return 'credentials-error'.i18n();
      case SignInResult.userChallengeException:
        return 'user-challenge-exception'.i18n();
      case SignInResult.newPasswordRequiredException:
        return 'new-password-required'.i18n();
      case SignInResult.incorrectStateException:
        return 'incorrect-state-exception'.i18n();
      case SignInResult.generalException:
        return 'general-exception'.i18n();
      case SignInResult.userNotConfirmedException:
        return 'confirm-account'.i18n();
      default:
        return 'general-exception'.i18n();
    }
  }

  void resendCode(String email) async {
    await _authRepo.requestAuthentificationCode(email);
  }

  bool validateEmail(String? email) {
    final bool isValid = _formValidator.validateEmail(email) == true;
    if (!isValid) {
      emit(ReusableErrorState(error: "sign-up-error-empty".i18n()));
    }
    return isValid;
  }

  bool validatePassword(String? password) {
    final bool isValid = _formValidator.validatePassword(password);
    if (!isValid) {
      emit(ReusableErrorState(error: 'sign-up-error-password'.i18n()));
    }
    return isValid;
  }
}
