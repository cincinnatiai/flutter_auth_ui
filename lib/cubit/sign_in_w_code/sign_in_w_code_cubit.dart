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
      switch (result) {
        case SignInResult.signedIn:
          emit(const ReusableLoadedState());
          break;
        case SignInResult.codeMismatch:
          emit(ReusableErrorState(error: 'code-mismatch'.i18n()));
          break;
        case SignInResult.incorrectCredentials:
          emit(ReusableErrorState(error: 'credentials-error'.i18n()));
          break;
        case SignInResult.userChallengeException:
          emit(ReusableErrorState(error: 'user-challenge-exception'.i18n()));
          break;
        case SignInResult.newPasswordRequiredException:
          emit(ReusableErrorState(error: 'new-password-required'.i18n()));
          break;
        case SignInResult.incorrectStateException:
          emit(ReusableErrorState(error: 'incorrect-state-exception'.i18n()));
          break;
        case SignInResult.generalException:
          emit(ReusableErrorState(error: 'general-exception'.i18n()));
          break;
        case SignInResult.userNotConfirmedException:
          emit(ReusableErrorState(error: 'confirm-account'.i18n()));
          break;
      }
    } catch (e) {
      ErrorHandler.refactorError(e);
      emit(ReusableErrorState(error: e.toString()));
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
