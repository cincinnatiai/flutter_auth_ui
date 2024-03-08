import 'package:auth_common/enums/auth_enums.dart';
import 'package:auth_ui/cubit/retrieve_password/retrieve_password_mapper.dart';
import 'package:auth_ui/cubit/retrieve_password/retrieve_password_state.dart';
import 'package:auth_ui/cubit/retrieve_password/retrive_password_cubit.dart';
import 'package:common/constants/dimens.dart';
import 'package:common/widget/buttons/custom_button.dart';
import 'package:common/widget/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late final RetrievePasswordCubit cubit;
  late final TextEditingController emailEditingController;
  late final TextEditingController passwordEditingController;
  late final TextEditingController codeEditingController;
  bool showPasswordAndCode = false;
  bool hidePassword = true;
  bool hideCode = true;
  int count = 0;

  @override
  void initState() {
    super.initState();
    cubit = context.read<RetrievePasswordCubit>();
    emailEditingController = TextEditingController();
    passwordEditingController = TextEditingController();
    codeEditingController = TextEditingController();
    showPasswordAndCode = false;
    count = 0;
  }

  @override
  void dispose() {
    emailEditingController.dispose();
    passwordEditingController.dispose();
    codeEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<RetrievePasswordCubit, PasswordState>(
        builder: (context, state) {
          final PasswordScreenArguments args = createFromState(state);
          final themeData = Theme.of(context);

          if (args.success) {
            showPasswordAndCode = true;
            if (count == 1) {
              Future.delayed(const Duration(milliseconds: 300), () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (route) => false);
              });
              count = 0;
            }
            count++;
          }

          return SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  constraints:
                      const BoxConstraints(maxWidth: DimensCommon.maxWidth),
                  child: Padding(
                    padding: const EdgeInsets.all(DimensCommon.eight),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: DimensCommon.oneHundredFourty,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // SizedBox(
                              //   child: SVGBanner(
                              //     path: wellcomeNamePath,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: DimensCommon.fiftyTwo,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'reset-password'.i18n(),
                                style: themeData.textTheme.titleMedium,
                              ),
                              const Icon(
                                Icons.person,
                                color: Colors.blue,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          showPasswordAndCode
                              ? 'confirm-new-password'.i18n()
                              : 'recover-account-access'.i18n(),
                          style: themeData.textTheme.bodyMedium,
                        ),
                        SizedBox(
                          height: showPasswordAndCode
                              ? DimensCommon.twoHundred
                              : DimensCommon.oneHundredFourty,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomTextField(
                                controller: emailEditingController,
                                inputType: InputType.text,
                                labelText: 'email'.i18n(),
                                onChanged: (val) {
                                  cubit.onEvent(EmailEditingBegun());
                                },
                                errorText: args.isEmailInError
                                    ? 'email-error'.i18n()
                                    : null,
                              ),
                              if (showPasswordAndCode)
                                CustomTextField(
                                  controller: passwordEditingController,
                                  inputType: InputType.text,
                                  labelText: 'password'.i18n(),
                                  suffixIcon: IconButton(
                                    icon: Icon(hidePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined),
                                    onPressed: () {
                                      setState(() {
                                        hidePassword = !hidePassword;
                                      });
                                    },
                                  ),
                                  errorText: args.isPasswordInError
                                      ? 'password-error'.i18n()
                                      : null,
                                  onChanged: (val) {
                                    cubit.onEvent(PasswordEditingBegun());
                                  },
                                  obscureText: hidePassword,
                                ),
                              if (showPasswordAndCode)
                                CustomTextField(
                                  controller: codeEditingController,
                                  inputType: InputType.text,
                                  labelText: 'code'.i18n(),
                                  onChanged: (val) {
                                    cubit.onEvent(CodeEditingBegun());
                                  },
                                  obscureText: hideCode,
                                  suffixIcon: IconButton(
                                    icon: Icon(hideCode
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined),
                                    onPressed: () {
                                      setState(() {
                                        hideCode = !hideCode;
                                      });
                                    },
                                  ),
                                  enableCapitalization: false,
                                ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(
                              maxWidth: DimensCommon.maxWidth),
                          child: args.errorMessage != null
                              ? Text(
                                  args.errorMessage!,
                                  style: const TextStyle(
                                    fontSize: DimensCommon.sixteen,
                                    color: Colors.red,
                                  ),
                                )
                              : const SizedBox(height: DimensCommon.four),
                        ),
                        args.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : CustomButton(
                                onPressed: () {
                                  cubit.onEvent(
                                    RetrivePasswordButtonWithCodeTapped(
                                      emailEditingController.text.toString(),
                                      passwordEditingController.text.toString(),
                                      codeEditingController.text.toString(),
                                    ),
                                  );
                                },
                                buttonText: showPasswordAndCode
                                    ? 'reset-password'.i18n()
                                    : 'password-code'.i18n(),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
