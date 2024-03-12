import 'package:auth_common/constants/dimens.dart';
import 'package:auth_ui/screens/login/widgets/error_login_message.dart';
import 'package:auth_ui/utils/logo_dimensions.dart';
import 'package:common/widget/buttons/custom_button.dart';
import 'package:common/widget/images/image_banner.dart';
import 'package:common/widget/textfield.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class ConfirmationCodeForm extends StatefulWidget {
  final String email;
  final String logoImagePath;
  final bool isLoading;
  final String errorMessage;
  final Function(String confirmationCode) confirmationCodeAction;
  final Function() requestConfirmationCode;

  const ConfirmationCodeForm({
    super.key,
    required this.email,
    required this.logoImagePath,
    required this.isLoading,
    required this.errorMessage,
    required this.confirmationCodeAction,
    required this.requestConfirmationCode,
  });

  @override
  State<ConfirmationCodeForm> createState() => _ConfirmationCodeFormState();
}

class _ConfirmationCodeFormState extends State<ConfirmationCodeForm> {
  late final TextEditingController confirmationCodeController;
  bool isThereConfirmationCode = false;

  @override
  void initState() {
    super.initState();
    confirmationCodeController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final logoDimensions = LogoDimensions(context);
    final logoWidth = logoDimensions.calculateLogoWidth();
    final logoHeight = logoDimensions.calculateLogoHeight();
    ThemeData theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: DimensAuthUi.paddingFormCard),
          child: ImageBanner(
            path: widget.logoImagePath,
            width: logoWidth,
            height: logoHeight,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
              vertical: DimensAuthUi.paddingTextField),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "verification-code-title".i18n(),
                style: theme.textTheme.headlineSmall,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: DimensAuthUi.paddingTitleConfirmationCode),
                child: Text(
                  widget.email,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(bottom: DimensAuthUi.paddingTitle),
                child: Text(
                  "verification-code-description".i18n(),
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(bottom: DimensAuthUi.paddingTitle),
                child: CustomTextField(
                  controller: confirmationCodeController,
                  inputType: InputType.number,
                  labelText: "confirmation-code".i18n(),
                  onChanged: (text) {
                    if (text.length >= 6) {
                      setState(() {
                        isThereConfirmationCode = true;
                      });
                    } else {
                      setState(() {
                        isThereConfirmationCode = false;
                      });
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: DimensAuthUi.paddingErrorTextField),
                child: ErrorMessageWidget(errorMessage: widget.errorMessage),
              ),
              isThereConfirmationCode
                  ? CustomButton(
                      onPressed: () {
                        isThereConfirmationCode = false;
                        widget.confirmationCodeAction(
                            confirmationCodeController.text.toString());
                      },
                      buttonText:
                          'confirmation-code-action'.i18n().toUpperCase(),
                    )
                  : const SizedBox(),
              widget.isLoading
                  ? const CircularProgressIndicator()
                  : const SizedBox(),
              Padding(
                padding: const EdgeInsets.only(top: DimensAuthUi.paddingTitle),
                child: CustomButton(
                  onPressed: () => widget.requestConfirmationCode(),
                  buttonText: 'resend-confirmation-code'.i18n().toUpperCase(),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
