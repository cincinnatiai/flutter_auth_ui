import 'package:auth_common/constants/dimens.dart';
import 'package:auth_common/enums/auth_enums.dart';
import 'package:auth_ui/cubit/sign_up/sign_up_cubit.dart';
import 'package:auth_ui/cubit/sign_up/sign_up_state.dart';
import 'package:auth_ui/screens/sign_up/components/sign_up_device_screen.dart';
import 'package:auth_ui/screens/sign_up/components/sign_up_web_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUp extends StatefulWidget {
  final String logoImagePath;
  final String signUpImagePath;
  final bool availableConfirmationCodeScreen;
  final ImageSize imageSize;

  const SignUp({
    super.key,
    required this.logoImagePath,
    required this.signUpImagePath,
    required this.availableConfirmationCodeScreen,
    this.imageSize = ImageSize.defaultSize,
  });

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late final RegistrationCubit cubit;
  bool isSignUpLoading = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    cubit = context.read<RegistrationCubit>();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(body: BlocBuilder<RegistrationCubit, RegistrationEvent>(
      builder: (context, state) {
        if (state is RegistrationLoading) {
          isSignUpLoading = true;
        }
        if (state is RegistrationLoaded) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            Navigator.of(context)
                .pushNamed('/confirmation-code', arguments: state.userData);
          });
        }

        if (state is RegistrationError) {
          isSignUpLoading = false;
          errorMessage = state.message;
        }
        return size.width > DimensAuthUi.maxWidth
            ? SignUpWebScreen(
                logoImagePath: widget.logoImagePath,
                signUpImagePath: widget.signUpImagePath,
                availableConfirmationCodeScreen:
                    widget.availableConfirmationCodeScreen,
                isSignUpLoading: isSignUpLoading,
                errorMessage: errorMessage,
                imageSize: widget.imageSize,
                signUpAction: (email, password, confirmPassword) {
                  if (password == confirmPassword) {
                    cubit.onEvent(RegistrationTapped(email, password));
                  }
                },
                updateErrorMessage: (errorMessage) {
                  setState(() {
                    errorMessage = errorMessage;
                  });
                },
              )
            : SignUpDeviceScreen(
                logoImagePath: widget.logoImagePath,
                signUpImagePath: widget.signUpImagePath,
                availableConfirmationCodeScreen:
                    widget.availableConfirmationCodeScreen,
                isSignUpLoading: isSignUpLoading,
                errorMessage: errorMessage,
                signUpAction: (email, password, confirmPassword) {
                  if (password == confirmPassword) {
                    cubit.onEvent(RegistrationTapped(email, password));
                  }
                },
                updateErrorMessage: (errorMessage) {
                  setState(() {
                    errorMessage = errorMessage;
                  });
                },
              );
      },
    ));
  }
}
