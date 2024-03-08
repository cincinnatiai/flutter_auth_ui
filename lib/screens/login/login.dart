library auth_ui;

import 'package:auth_common/constants/dimens.dart';
import 'package:auth_ui/screens/login/screen/login_device.dart';
import 'package:auth_ui/screens/login/screen/login_web.dart';
import 'package:flutter/material.dart';

class LogIn extends StatefulWidget {
  final String logoImagePath;
  final String signInImagePath;
  final Function(String email, String password, String code, bool persistUser)
      logInAction;
  final bool? validatingCredentials;
  final bool? activateCodeFeature;
  final bool? activeForgotPassword;

  const LogIn({
    super.key,
    required this.logoImagePath,
    required this.signInImagePath,
    required this.logInAction,
    required this.validatingCredentials,
    this.activateCodeFeature = false,
    this.activeForgotPassword = false,
  });

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (size.width > DimensAuthUi.maxWidth) {
      return LoginWebScreen(
        logoImagePath: widget.logoImagePath,
        signInImagePath: widget.signInImagePath,
        logInAction: widget.logInAction,
        validatingCredentials: widget.validatingCredentials,
      );
    } else {
      return LoginDeviceScreen(
        logoImagePath: widget.logoImagePath,
        logInAction: widget.logInAction,
        validatingCredentials: widget.validatingCredentials,
        signInImagePath: widget.signInImagePath,
      );
    }
  }
}
