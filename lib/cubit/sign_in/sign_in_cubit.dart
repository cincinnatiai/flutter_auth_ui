import 'package:auth_common/contracts/auth_formatter_contract.dart';
import 'package:auth_common/contracts/auth_repository_contract.dart';
import 'package:auth_common/enums/auth_enums.dart';
import 'package:auth_ui/cubit/sign_in/sign_in_screen_state.dart';
import 'package:bloc/bloc.dart';

abstract class LoginCubitContract {
  void onEvent(LoginScreenEvent event);
}

class LoginCubit extends Cubit<LoginScreenState> implements LoginCubitContract {
  final AuthRepositoryContract _authRepo;
  final AuthFormatterContract _formValidator;

  LoginCubit({
    required AuthRepositoryContract authRepo,
    required AuthFormatterContract formValidator,
  })  : _authRepo = authRepo,
        _formValidator = formValidator,
        super(LoginScreenState.none);

  @override
  void onEvent(LoginScreenEvent event) {
    if (event is LoginButtonWithCodeTapped) {
      _loginUser(event);
    } else if (event is EmailEditingBegun) {
      emit(LoginScreenState.clearEmailError);
    } else if (event is PasswordEditingBegun) {
      emit(LoginScreenState.clearPasswordError);
    } else if (event is ShowLoginCode) {
      emit(LoginScreenState.showLoginCodeInput);
    } else if (event is CodeEditingBegun) {
      emit(LoginScreenState.clearCodeError);
    }
  }

  void _loginUser(LoginButtonWithCodeTapped event) async {
    if (!_validateEmail(event.email) || !_validatePassword(event.password)) {
      return;
    }
    emit(LoginScreenState.loading);

    final SignInResult result;
    if (event.code == null || event.code?.isEmpty == true) {
      result = await _authRepo.signIn(event.email!, event.password!);
    } else {
      result = await _authRepo.signInWithCode(
          event.email!, event.password!, event.code!);
    }
    switch (result) {
      case SignInResult.signedIn:
        emit(LoginScreenState.loggedIn);
        break;
      case SignInResult.incorrectCredentials:
        emit(LoginScreenState.loginErrorPasswordOrEmail);
        break;
      case SignInResult.userNotConfirmedException:
        emit(LoginScreenState.notConfirmedError);
        break;
      default:
        break;
    }
  }

  bool _validateEmail(String? email) {
    final bool isValid = _formValidator.validateEmail(email) == true;
    if (!isValid) {
      emit(LoginScreenState.emailError);
    }
    return isValid;
  }

  bool _validatePassword(String? password) {
    final bool isValid = _formValidator.validatePassword(password);
    if (!isValid) emit(LoginScreenState.passwordError);
    return isValid;
  }
}
