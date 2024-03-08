import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class ForgotPasswordFeature extends StatelessWidget {
  const ForgotPasswordFeature({
    super.key,
    required this.theme,
  });

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
          onTap: () {}, //!callback
          child: Text(
            'forgot-password'.i18n(),
            style: TextStyle(
                color: theme.colorScheme.primary,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          )),
    );
  }
}
