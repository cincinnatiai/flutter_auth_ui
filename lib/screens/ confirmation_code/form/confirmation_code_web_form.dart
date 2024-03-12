import 'package:auth_common/constants/dimens.dart';
import 'package:auth_ui/screens/%20confirmation_code/form/confirmation_code_form.dart';
import 'package:common/widget/images/image_banner.dart';
import 'package:flutter/widgets.dart';

class ConfirmationCodeWebForm extends StatelessWidget {
  final String email;
  final String logoImagePath;
  final String confirmationCodeImagePath;
  final bool isLoading;
  final String errorMessage;
  final Function(String confirmationCode) confirmCodeAction;
  final Function() requestConfirmationCode;

  const ConfirmationCodeWebForm({
    super.key,
    required this.email,
    required this.logoImagePath,
    required this.confirmationCodeImagePath,
    required this.isLoading,
    required this.errorMessage,
    required this.confirmCodeAction,
    required this.requestConfirmationCode,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const double imageScreenPercentage = 0.43;
    const backgroundColor = Color.fromRGBO(236, 254, 246, 1);
    return Row(
      children: [
        ImageBanner(
          width: size.width * imageScreenPercentage,
          height: size.height,
          backgroundColor: backgroundColor,
          path: confirmationCodeImagePath,
        ),
        Expanded(
            child: Center(
          child: Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: DimensAuthUi.padding),
            constraints: const BoxConstraints(maxWidth: DimensAuthUi.maxWidth),
            child: SingleChildScrollView(
              child: ConfirmationCodeForm(
                email: email,
                logoImagePath: logoImagePath,
                isLoading: isLoading,
                errorMessage: errorMessage,
                confirmationCodeAction: (confirmationCode) =>
                    confirmCodeAction(confirmationCode),
                requestConfirmationCode: () => requestConfirmationCode(),
              ),
            ),
          ),
        ))
      ],
    );
  }
}
