import 'package:auth_common/constants/dimens.dart';
import 'package:auth_ui/screens/login/form/login_form.dart';
import 'package:common/widget/images/svg_banner.dart';
import 'package:flutter/material.dart';

class LoginWebScreen extends StatelessWidget {
  final String logoImagePath;
  final String signInImagePath;
  final Function(String email, String password, String code, bool persistUser)
      logInAction;
  final bool? validatingCredentials;
  final bool? activateCodeFeature;
  final bool? activeForgotPassword;

  const LoginWebScreen({
    super.key,
    required this.logoImagePath,
    required this.signInImagePath,
    required this.logInAction,
    required this.validatingCredentials,
    this.activateCodeFeature = false,
    this.activeForgotPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Row(
      children: [
        SVGBanner(
          width: screenSize.width / DimensAuthUi.widthScaleFactor,
          backgroundColor: const Color.fromRGBO(236, 254, 246, 1),
          path: signInImagePath,
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: DimensAuthUi.padding),
            constraints: const BoxConstraints(maxWidth: DimensAuthUi.maxWidth),
            child: SingleChildScrollView(
              child: LoginForm(
                logoImagePath: logoImagePath,
                logInAction: logInAction,
                validatingCredentials: validatingCredentials,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
