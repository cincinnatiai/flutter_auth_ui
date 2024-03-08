import 'package:auth_common/constants/dimens.dart';
import 'package:auth_ui/screens/login/form/login_form.dart';
import 'package:common/widget/images/svg_banner.dart';
import 'package:flutter/material.dart';

class LoginDeviceScreen extends StatelessWidget {
  final String logoImagePath;
  final String signInImagePath;

  final Function(String email, String password, String code, bool persistUser)
      logInAction;
  final bool? validatingCredentials;
  final bool? activateCodeFeature;
  final bool? activeForgotPassword;

  const LoginDeviceScreen({
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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Stack(
        children: [
          SVGBanner(
            width: width,
            height: height,
            backgroundColor: const Color.fromRGBO(236, 254, 246, 1),
            path: signInImagePath,
          ),
          Center(
            child: Container(
              height: height,
              color: Colors.white70,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  horizontal: DimensAuthUi.paddingDevice),
              constraints:
                  const BoxConstraints(maxWidth: DimensAuthUi.maxWidth),
              child: LoginForm(
                logoImagePath: logoImagePath,
                logInAction: logInAction,
                validatingCredentials: validatingCredentials,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
