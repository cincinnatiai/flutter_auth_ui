import 'package:auth_common/constants/dimens.dart';
import 'package:flutter/material.dart';

class ErrorMessageWidget extends StatelessWidget {
  const ErrorMessageWidget({
    super.key,
    required this.errorMessage,
  });

  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return (errorMessage != null && errorMessage! != '')
        ? Text(
            errorMessage!,
            style: const TextStyle(
              fontSize: DimensAuthUi.fontSizeError,
              color: Colors.red,
            ),
          )
        : const SizedBox(height: DimensAuthUi.fontSizeError);
  }
}
