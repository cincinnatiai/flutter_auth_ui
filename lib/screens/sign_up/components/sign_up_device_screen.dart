import 'package:auth_common/constants/dimens.dart';
import 'package:auth_ui/screens/sign_up/form/sign_up_form.dart';
import 'package:common/widget/images/image_banner.dart';
import 'package:flutter/material.dart';

class SignUpDeviceScreen extends StatelessWidget {
  final BuildContext? parentContext;
  final String logoImagePath;
  final String signUpImagePath;
  final Function(
    String email,
    String password,
    String confirmPassword,
  ) signUpAction;
  final bool availableConfirmationCodeScreen;
  final bool isSignUpLoading;
  final String errorMessage;
  final Function(String errorMessage) updateErrorMessage;

  const SignUpDeviceScreen({
    super.key,
    this.parentContext,
    required this.logoImagePath,
    required this.signUpImagePath,
    required this.signUpAction,
    required this.availableConfirmationCodeScreen,
    required this.isSignUpLoading,
    required this.errorMessage,
    required this.updateErrorMessage,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    const backgroundColor = Color.fromRGBO(236, 254, 246, 1);
    return SingleChildScrollView(
      child: Stack(
        children: [
          ImageBanner(
            width: double.infinity,
            backgroundColor: backgroundColor,
            path: signUpImagePath,
            fit: BoxFit.fitHeight,
          ),
          Center(
            child: Container(
              height: height,
              color: Colors.white70,
              width: double.infinity,
              padding: const EdgeInsets.all(DimensAuthUi.paddingDevice),
              constraints:
                  const BoxConstraints(maxWidth: DimensAuthUi.maxWidth),
              child: SignUpForm(
                parentContext: parentContext,
                logoImagePath: logoImagePath,
                signUpAction: signUpAction,
                availableConfirmationCodeScreen:
                    availableConfirmationCodeScreen,
                isSignUpLoading: isSignUpLoading,
                errorMessage: errorMessage,
                updateErrorMessage: (errorMessage) =>
                    updateErrorMessage(errorMessage),
              ),
            ),
          )
        ],
      ),
    );
  }
}
