import 'package:auth_common/constants/dimens.dart';
import 'package:auth_ui/screens/login/login_utils.dart';
import 'package:auth_ui/screens/login/widgets/error_login_message.dart';
import 'package:auth_ui/screens/login/widgets/forgot_password.dart';
import 'package:auth_ui/screens/login/widgets/login_w_code.dart';
import 'package:auth_ui/utils/logo_dimensions.dart';
import 'package:common/widget/buttons/custom_button.dart';
import 'package:common/widget/buttons/custom_text_button.dart';
import 'package:common/widget/checkboxes/custom_checkbox.dart';
import 'package:common/widget/images/image_banner.dart';
import 'package:common/widget/textfield.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class LoginForm extends StatefulWidget {
  final bool? showCompanyLogo;
  final String logoImagePath;
  final Function(String email, String password, String code, bool persistUser)
      logInAction;
  final bool? validatingCredentials;
  final bool? activateCodeFeature;
  final bool? activeForgotPassword;

  const LoginForm({
    super.key,
    this.showCompanyLogo = false,
    required this.logoImagePath,
    required this.logInAction,
    required this.validatingCredentials,
    this.activateCodeFeature = false,
    this.activeForgotPassword = false,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late final TextEditingController emailEditingController;
  late final TextEditingController passwordEditingController;
  late final TextEditingController codeEditingController;
  bool showLoginCode = false;
  bool hidePassword = true;
  bool hideCode = true;
  bool persistData = false;

  @override
  void initState() {
    super.initState();
    emailEditingController = TextEditingController();
    passwordEditingController = TextEditingController();
    codeEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final logoDimensions = LogoDimensions(context);
    final logoWidth = logoDimensions.calculateLogoWidth();
    final logoHeight = logoDimensions.calculateLogoHeight();

    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showCompanyLogo == true)
          ImageBanner(
            path: widget.logoImagePath,
            width: logoWidth,
            height: logoHeight,
          ),
        Padding(
          padding: const EdgeInsets.only(
              top: DimensAuthUi.padding, bottom: DimensAuthUi.paddingFormCard),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "login-title".i18n(),
                  style: theme.textTheme.headlineSmall,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: DimensAuthUi.paddingTitle),
                  child: Text(
                    "login-message".i18n(),
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: DimensAuthUi.paddingTextField),
                  child: CustomTextField(
                    controller: emailEditingController,
                    inputType: InputType.text,
                    labelText: 'email'.i18n(),
                    onChanged: (value) {
                      setState(() {
                        errorLoginMessageUtil = '';
                      });
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: DimensAuthUi.paddingTextField),
                  child: CustomTextField(
                    controller: passwordEditingController,
                    inputType: InputType.text,
                    labelText: 'password'.i18n(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        hidePassword
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        color: theme.colorScheme.tertiaryContainer,
                      ),
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                    ),
                    obscureText: hidePassword,
                    onChanged: (value) {
                      setState(() {
                        errorLoginMessageUtil = '';
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: DimensAuthUi.paddingErrorTextField),
                  child:
                      ErrorMessageWidget(errorMessage: errorLoginMessageUtil),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CustomCheckbox(
                          parentValue: persistData,
                          onChange: (value) {
                            setState(() {
                              persistData = value;
                            });
                          },
                        ),
                        Text("remember-user".i18n()),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("forgot-password".i18n()),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: DimensAuthUi.fontSizeButtonSignUp),
                          child: CustomTextButton(
                            message: 'forgot-password-event'.i18n(),
                            onPressed: () {
                              Navigator.pushNamed(context, "/reset-password");
                            },
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: DimensAuthUi.paddingTextField),
                  child: widget.validatingCredentials!
                      ? Center(
                          child: CircularProgressIndicator(
                              color: theme.colorScheme.primary))
                      : CustomButton(
                          onPressed: () {
                            widget.logInAction(
                              emailEditingController.text.toString(),
                              passwordEditingController.text.toString(),
                              codeEditingController.text.toString(),
                              persistData,
                            );
                          },
                          buttonText: 'login-title'.i18n().toUpperCase(),
                        ),
                ),
                if (widget.activeForgotPassword!)
                  ForgotPasswordFeature(theme: theme),
                if (widget.activateCodeFeature!)
                  LoginWithCodeFeature(theme: theme),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  right: DimensAuthUi.paddingErrorTextField),
              child: Text("login-dont-have-account".i18n()),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: DimensAuthUi.paddingErrorTextField),
              child: CustomTextButton(
                message: 'register-title'.i18n(),
                onPressed: () {
                  Navigator.pushNamed(context, "/signup");
                },
              ),
            )
          ],
        )
      ],
    );
  }
}
