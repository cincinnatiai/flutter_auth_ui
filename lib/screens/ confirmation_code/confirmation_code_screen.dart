import 'package:auth_common/constants/dimens.dart';
import 'package:auth_ui/arguments/confirmation_code_arguments.dart';
import 'package:auth_ui/cubit/sign_in_w_code/sign_in_w_code_cubit.dart';
import 'package:auth_ui/screens/%20confirmation_code/form/confirmation_code_device_form.dart';
import 'package:auth_ui/screens/%20confirmation_code/form/confirmation_code_web_form.dart';
import 'package:common/reusable_classes/reusable_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfirmationCodeScreen extends StatefulWidget {
  final String logoImagePath;
  final String confirmationImagePath;
  final String nextScreen;

  const ConfirmationCodeScreen({
    super.key,
    required this.logoImagePath,
    required this.confirmationImagePath,
    required this.nextScreen,
  });

  @override
  State<ConfirmationCodeScreen> createState() => _ConfirmationCodeScreenState();
}

class _ConfirmationCodeScreenState extends State<ConfirmationCodeScreen> {
  late final EmailCodeCubit cubit;
  late final ConfirmationCodeArguments args;
  bool initializedArgs = false;
  bool isLoading = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    cubit = context.read<EmailCodeCubit>();
  }

  void initializeArgs() {
    if (initializedArgs == false) {
      args = ModalRoute.of(context)!.settings.arguments
          as ConfirmationCodeArguments;
    }
    initializedArgs = true;
  }

  @override
  Widget build(BuildContext context) {
    initializeArgs();
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocBuilder<EmailCodeCubit, ReusableState>(
        builder: (context, state) {
          if (state is ReusableLoadingState) {
            isLoading = true;
          }
          if (state is ReusableErrorState) {
            errorMessage = state.error;
            isLoading = false;
          }
          if (state is ReusableLoadedState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  widget.nextScreen, (route) => false,
                  arguments: args.userEmail);
            });
          }
          return size.width > DimensAuthUi.maxWidth
              ? ConfirmationCodeWebForm(
                  email: args.userEmail,
                  logoImagePath: widget.logoImagePath,
                  confirmationCodeImagePath: widget.confirmationImagePath,
                  isLoading: isLoading,
                  errorMessage: errorMessage,
                  confirmCodeAction: (confirmationCode) => cubit.confirmEmail(
                      args.userEmail, args.userPassword, confirmationCode),
                  requestConfirmationCode: () =>
                      cubit.resendCode(args.userEmail),
                )
              : ConfirmationCodeDeviceForm(
                  email: args.userEmail,
                  logoImagePath: widget.logoImagePath,
                  confirmationCodeImagePath: widget.confirmationImagePath,
                  isLoading: isLoading,
                  errorMessage: errorMessage,
                  confirmCodeAction: (confirmationCode) => cubit.confirmEmail(
                      args.userEmail, args.userPassword, confirmationCode),
                  requestConfirmationCode: () =>
                      cubit.resendCode(args.userEmail),
                );
        },
      ),
    );
  }
}
