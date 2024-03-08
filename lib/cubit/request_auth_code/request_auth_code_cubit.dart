import 'package:auth_common/contracts/auth_repository_contract.dart';
import 'package:auth_common/enums/auth_enums.dart';
import 'package:bloc/bloc.dart';
import 'package:common/reusable_classes/error_handler.dart';
import 'package:common/reusable_classes/reusable_state.dart';
import 'package:localization/localization.dart';
import 'package:auth_common/contracts/auth_formatter_contract.dart';

class VerificationCodeCubit extends Cubit<ReusableState> {
  final AuthRepositoryContract _authRepo;
  final AuthFormatterContract formValidator;

  VerificationCodeCubit(
      {required AuthRepositoryContract authRepo, required this.formValidator})
      : _authRepo = authRepo,
        super(ReusableInitialState());

  void requestVerificationCode(String email) async {
    if (!validateEmail(email)) {
      return;
    }
    emit(ReusableLoadingState());
    try {
      final VerificationResult result =
          await _authRepo.requestAuthentificationCode(email);
      switch (result) {
        case VerificationResult.success:
          emit(const ReusableLoadedState());
          break;
        case VerificationResult.userNotFound:
          emit(ReusableErrorState(error: 'user-not-found'.i18n()));
          break;
        case VerificationResult.generalException:
          emit(ReusableErrorState(error: 'general-exception'.i18n()));
          break;
      }
    } catch (e) {
      ErrorHandler.refactorError(e);
      emit(ReusableErrorState(error: e.toString()));
    }
  }

  bool validateEmail(String? email) {
    final bool isValid = formValidator.validateEmail(email) == true;
    if (!isValid) {
      emit(ReusableErrorState(error: 'email-error'.i18n()));
    }
    return isValid;
  }
}
