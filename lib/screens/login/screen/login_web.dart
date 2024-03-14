import 'package:auth_common/constants/dimens.dart';
import 'package:auth_common/enums/auth_enums.dart';
import 'package:auth_ui/screens/login/form/login_form.dart';
import 'package:common/widget/images/image_banner.dart';
import 'package:flutter/material.dart';

class LoginWebScreen extends StatelessWidget {
  final String logoImagePath;
  final String signInImagePath;
  final Function(String email, String password, String code, bool persistUser)
      logInAction;
  final bool? validatingCredentials;
  final bool? activateCodeFeature;
  final bool? activeForgotPassword;
  final ImageSize imageSize;

  const LoginWebScreen({
    super.key,
    required this.logoImagePath,
    required this.signInImagePath,
    required this.logInAction,
    required this.validatingCredentials,
    required this.imageSize,
    this.activateCodeFeature = false,
    this.activeForgotPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double width = getWidthFromImageSize(imageSize, size.width);
    return Row(
      children: [
        ImageBanner(
          width: width,
          height: imageSize == ImageSize.fullSize ? size.height : null,
          backgroundColor: const Color.fromRGBO(236, 254, 246, 1),
          path: signInImagePath,
          fit: BoxFit.cover,
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

  double getWidthFromImageSize(ImageSize imageSize, double width) {
    switch (imageSize) {
      case ImageSize.fullSize:
        return width * 0.43;
      case ImageSize.defaultSize:
        return width / DimensAuthUi.widthScaleFactor;
    }
  }
}
