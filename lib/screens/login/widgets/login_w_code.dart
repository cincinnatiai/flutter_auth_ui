import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class LoginWithCodeFeature extends StatelessWidget {
  const LoginWithCodeFeature({
    super.key,
    required this.theme,
  });

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: InkWell(
                onTap: () {
                  // showLoginCode = !showLoginCode;
                }, //!callback
                child: Text(
                  'sign-w-code'.i18n(),
                  style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                )),
          ),
          if (true) //!Change for conditional
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: InkWell(
                  onTap: () {}, //!callback
                  child: Text(
                    'resend-code'.i18n(),
                    style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  )),
            ),
        ],
      ),
    );
  }
}
