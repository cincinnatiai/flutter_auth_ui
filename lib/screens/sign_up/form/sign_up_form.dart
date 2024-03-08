import 'package:auth_common/constants/dimens.dart';
import 'package:auth_ui/screens/login/widgets/error_login_message.dart';
import 'package:auth_ui/utils/logo_dimensions.dart';
import 'package:common/widget/buttons/custom_button.dart';
import 'package:common/widget/checkboxes/custom_checkbox.dart';
import 'package:common/widget/images/svg_banner.dart';
import 'package:common/widget/textfield.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class SignUpForm extends StatefulWidget {
  final bool? showCompanyLogo;
  final BuildContext? parentContext;
  final String logoImagePath;
  final Function(
    String email,
    String password,
    String confirmPassword,
  ) signUpAction;
  final bool availableConfirmationCodeScreen;
  final bool isSignUpLoading;
  final String errorMessage;
  final Function(String errorMessage) updateErrorMessage;

  const SignUpForm({
    super.key,
    this.parentContext,
    this.showCompanyLogo = false,
    required this.logoImagePath,
    required this.signUpAction,
    required this.availableConfirmationCodeScreen,
    required this.isSignUpLoading,
    required this.errorMessage,
    required this.updateErrorMessage,
  });

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  late final TextEditingController emailEditingController;
  late final TextEditingController passwordEditingController;
  late final TextEditingController confirmPasswordController;

  bool hidePassword = true;
  bool hideConfirmPassword = true;
  bool doIAcceptTerms = false;

  @override
  void initState() {
    super.initState();
    emailEditingController = TextEditingController();
    passwordEditingController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final logoDimensions = LogoDimensions(context);
    final logoWidth = logoDimensions.calculateLogoWidth();
    final logoHeight = logoDimensions.calculateLogoHeight();
    ThemeData theme = widget.parentContext != null
        ? Theme.of(widget.parentContext!)
        : Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showCompanyLogo == true)
          SVGBanner(
            path: widget.logoImagePath,
            width: logoWidth,
            height: logoHeight,
          ),
        SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "register-title".i18n(),
                style: theme.textTheme.headlineSmall,
              ),
              Padding(
                padding:
                    const EdgeInsets.only(bottom: DimensAuthUi.paddingTitle),
                child: Text(
                  "register-subtitle".i18n(),
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
                  onChanged: (value) => widget.updateErrorMessage(''),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: DimensAuthUi.paddingTextField),
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
                  onChanged: (value) => widget.updateErrorMessage(''),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: DimensAuthUi.paddingTextField),
                child: CustomTextField(
                  controller: confirmPasswordController,
                  inputType: InputType.text,
                  labelText: 'confirm-password'.i18n(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      hidePassword
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: theme.colorScheme.tertiaryContainer,
                    ),
                    onPressed: () {
                      setState(() {
                        hideConfirmPassword = !hideConfirmPassword;
                      });
                    },
                  ),
                  obscureText: hideConfirmPassword,
                  onChanged: (value) => widget.updateErrorMessage(''),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: DimensAuthUi.paddingErrorTextField),
                child: ErrorMessageWidget(errorMessage: widget.errorMessage),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CustomCheckbox(
                        parentValue: doIAcceptTerms,
                        onChange: (value) {
                          setState(() {
                            doIAcceptTerms = value;
                            widget.updateErrorMessage('');
                          });
                        },
                      ),
                      Text(
                        "register-trams-privacy-policy".i18n(),
                        style: const TextStyle(
                            fontSize: DimensAuthUi.fontSizeError),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: DimensAuthUi.paddingTextField),
                child: widget.isSignUpLoading
                    ? Center(
                        child: CircularProgressIndicator(
                            color: theme.colorScheme.primary))
                    : CustomButton(
                        onPressed: () {
                          if (doIAcceptTerms) {
                            widget.signUpAction(
                              emailEditingController.text.toString(),
                              passwordEditingController.text.toString(),
                              confirmPasswordController.text.toString(),
                            );
                          } else {
                            widget.updateErrorMessage(
                                "register-error-privacy-policy".i18n());
                          }
                        },
                        buttonText: 'register-button'.i18n().toUpperCase(),
                      ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  right: DimensAuthUi.paddingErrorTextField),
              child: Text("sign-up-have-account".i18n()),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'login'.i18n(),
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontSize: DimensAuthUi.fontSizeButtonSignUp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
