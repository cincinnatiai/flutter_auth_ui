library auth_ui;

import 'package:auth_common/enums/auth_enums.dart';
import 'package:auth_ui/screens/login/login.dart';
import 'package:auth_ui/screens/logo/logo_screen.dart';
import 'package:flutter/material.dart';

class AuthUILibrary extends StatefulWidget {
  final bool? showLogo;
  final bool? enableLocalizations;
  final String logoImagePath;
  final String signInImagePath;
  final ImageSize imageSize;
  final Function(
    String email,
    String password,
    String? code,
    bool persistUser,
  ) logInAction;
  final String? errorLoginMessage;
  final bool? validatingCredentials;

  const AuthUILibrary({
    super.key,
    this.showLogo = false,
    required this.logoImagePath,
    required this.signInImagePath,
    required this.logInAction,
    this.enableLocalizations = false,
    this.errorLoginMessage,
    this.validatingCredentials = false,
    this.imageSize = ImageSize.defaultSize,
  });

  @override
  State<AuthUILibrary> createState() => _AuthUILibraryState();
}

class _AuthUILibraryState extends State<AuthUILibrary> {
  bool logoBeenShown = false;
  late final Locale? currentLocale;
  late final List<String> localizationRoutes;
  late final List<String> libraryLocale;

  ThemeData? parentTheme;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        logoBeenShown = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !widget.showLogo!
          ? LogIn(
              logoImagePath: widget.logoImagePath,
              logInAction: (email, password, code, persistUser) {
                widget.logInAction(email, password, code, persistUser);
              },
              validatingCredentials: widget.validatingCredentials!,
              imageSize: widget.imageSize,
              signInImagePath: widget.signInImagePath,
            )
          : LogoScreen(
              logoPath: widget.logoImagePath,
            ),
    );
  }
}
