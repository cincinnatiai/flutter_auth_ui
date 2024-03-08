import 'package:auth_common/contracts/auth_formatter_contract.dart';
import 'package:auth_common/contracts/auth_repository_contract.dart';
import 'package:auth_common/enums/auth_enums.dart';
import 'package:auth_ui/arguments/confirmation_code_arguments.dart';
import 'package:auth_ui/cubit/sign_up/sign_up_state.dart';
import 'package:bloc/bloc.dart';
import 'package:localization/localization.dart';

class RegistrationCubit extends Cubit<RegistrationEvent> {
  final AuthRepositoryContract _authRepo;
  final AuthFormatterContract _formValidator;

  RegistrationCubit({
    required AuthRepositoryContract authRepo,
    required AuthFormatterContract formValidator,
  })  : _authRepo = authRepo,
        _formValidator = formValidator,
        super(RegistrationNone());

  void onEvent(RegistrationEvent event) {
    if (event is RegistrationTapped) {
      _registerUser(event);
    }
  }

  void _registerUser(RegistrationTapped event) async {
    if (!validateEmail(event.email) || !validatePassword(event.password)) {
      return;
    }
    emit(RegistrationLoading());
    final RegistrationResult result =
        await _authRepo.signUp(event.email!, event.password!);
    switch (result) {
      case RegistrationResult.success:
        emit(RegistrationLoaded(
            message: 'sign-up-success-message'.i18n(),
            userData: ConfirmationCodeArguments(
              userEmail: event.email!,
              userPassword: event.password!,
            )));
        break;
      case RegistrationResult.accountExists:
        emit(RegistrationError(message: 'account-exists-error'.i18n()));
        break;
      case RegistrationResult.generalException:
        emit(RegistrationError(message: 'general-exception'.i18n()));
        break;
      case RegistrationResult.strongPasswordException:
        emit(RegistrationError(message: 'strong-password-error'.i18n()));
        break;
      default:
        emit(RegistrationError(message: 'general-exception'.i18n()));
        break;
    }
  }

  bool validateEmail(String? email) {
    final bool isValid = _formValidator.validateEmail(email) == true;
    if (!isValid) {
      emit(RegistrationError(message: "sign-up-error-empty".i18n()));
    }
    return isValid;
  }

  bool validatePassword(String? password) {
    final bool isValid = _formValidator.validatePassword(password);
    if (!isValid) {
      emit(RegistrationError(message: 'sign-up-error-password'.i18n()));
    }
    return isValid;
  }
}
