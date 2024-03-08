import 'package:auth_common/enums/auth_enums.dart';
import 'package:localization/localization.dart';

class PasswordScreenArguments {
  bool isEmailInError = false;
  bool isPasswordInError = false;
  bool isLoading = false;
  bool isCredentialsError = false;
  bool success = false;
  String? errorMessage;
}

PasswordScreenArguments createFromState(PasswordState state) {
  final PasswordScreenArguments args = PasswordScreenArguments();
  switch (state) {
    case PasswordState.emailError:
      args.isEmailInError = true;
      break;
    case PasswordState.passwordError:
      args.isPasswordInError = true;
      break;
    case PasswordState.clearEmailError:
      args.isEmailInError = false;
      break;
    case PasswordState.clearPasswordError:
      args.isPasswordInError = false;
      break;
    case PasswordState.loading:
      args.isLoading = true;
      break;
    case PasswordState.retrievepasswordErrorPasswordOrEmail:
      args.errorMessage = 'credentials-error'.i18n();
      break;
    case PasswordState.notConfirmedError:
      args.errorMessage = 'confirm-account-error'.i18n();
      break;
    case PasswordState.codeMismatch:
      args.errorMessage = 'code-mismatch'.i18n();
      break;
    case PasswordState.strongPasswordError:
      args.errorMessage = "strong-password-error".i18n();
      break;
    case PasswordState.passwordChanged:
      args.success = true;
      break;
    default:
      break;
  }
  return args;
}
