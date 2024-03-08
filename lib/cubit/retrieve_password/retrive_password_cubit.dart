import 'package:auth_common/contracts/auth_formatter_contract.dart';
import 'package:auth_common/contracts/auth_repository_contract.dart';
import 'package:auth_common/enums/auth_enums.dart';
import 'package:auth_ui/cubit/retrieve_password/retrieve_password_state.dart';
import 'package:bloc/bloc.dart';

abstract class RetrievePasswordCubitContract {
  void onEvent(PasswordScreenEvent event);
}

class RetrievePasswordCubit extends Cubit<PasswordState>
    implements RetrievePasswordCubitContract {
  final AuthRepositoryContract _authRepo;
  final AuthFormatterContract _formValidator;

  RetrievePasswordCubit(
      {required AuthRepositoryContract authRepo,
      required AuthFormatterContract formValidator})
      : _authRepo = authRepo,
        _formValidator = formValidator,
        super(PasswordState.none);

  @override
  void onEvent(PasswordScreenEvent event) {
    if (event is RetrivePasswordButtonWithCodeTapped) {
      _changePassword(event);
    } else if (event is EmailEditingBegun) {
      emit(PasswordState.clearEmailError);
    } else if (event is PasswordEditingBegun) {
      emit(PasswordState.clearPasswordError);
    } else if (event is ShowPasswordAndCode) {
      emit(PasswordState.showPasswordAndCodeInput);
    } else if (event is CodeEditingBegun) {
      emit(PasswordState.clearCodeError);
    }
  }

  void _changePassword(RetrivePasswordButtonWithCodeTapped event) async {
    if (!_validateEmail(event.email)) {
      return;
    }
    emit(PasswordState.loading);

    final PasswordResult result;
    if (event.code == null || event.code?.isEmpty == true) {
      result = await _authRepo.passwordRecoveryRequest(event.email!);
    } else {
      if (_validatePassword(event.password)) {
        result = await _authRepo.passwordConfirmation(
            event.email!, event.password!, event.code!);
      } else {
        return;
      }
    }
    switch (result) {
      case PasswordResult.success:
        emit(PasswordState.passwordChanged);
        break;
      case PasswordResult.userNotFound:
        emit(PasswordState.retrievepasswordErrorPasswordOrEmail);
        break;
      case PasswordResult.userNotConfirmedException:
        emit(PasswordState.notConfirmedError);
        break;
      case PasswordResult.codeMismatch:
        emit(PasswordState.codeMismatch);
        break;
      case PasswordResult.strongPasswordException:
        emit(PasswordState.strongPasswordError);
        break;
      default:
        break;
    }
  }

  bool _validateEmail(String? email) {
    final bool isValid = _formValidator.validateEmail(email) == true;
    if (!isValid) {
      emit(PasswordState.emailError);
    }
    return isValid;
  }

  bool _validatePassword(String? password) {
    final bool isValid = _formValidator.validatePassword(password);
    if (!isValid) emit(PasswordState.passwordError);
    return isValid;
  }
}
