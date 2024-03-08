import 'package:auth_common/contracts/auth_formatter_contract.dart';
import 'package:auth_common/contracts/auth_repository_contract.dart';
import 'package:auth_common/enums/auth_enums.dart';
import 'package:auth_ui/cubit/sign_in/sign_in_cubit.dart';
import 'package:auth_ui/cubit/sign_in/sign_in_screen_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepositoryContract extends Mock
    implements AuthRepositoryContract {}

class MockAuthFormatterContract extends Mock implements AuthFormatterContract {}

void main() {
  late MockAuthRepositoryContract mockAuthRepository;
  late MockAuthFormatterContract mockAuthFormatter;
  late LoginCubit cubit;

  setUp(() {
    mockAuthRepository = MockAuthRepositoryContract();
    mockAuthFormatter = MockAuthFormatterContract();

    cubit = LoginCubit(
      authRepo: mockAuthRepository,
      formValidator: mockAuthFormatter,
    );
  });

  group('LoginCubit tests', () {
    blocTest(
      'emits [RegistrationError] when _registerUser has incorrect email',
      setUp: () {
        when(() => mockAuthFormatter.validateEmail("test"))
            .thenAnswer((realInvocation) => false);
      },
      build: () => cubit,
      act: (cubit) =>
          cubit.onEvent(LoginButtonWithCodeTapped("test", "test", null)),
      expect: () => [LoginScreenState.emailError],
    );

    blocTest(
      'emits [RegistrationError] when _registerUser has incorrect password',
      setUp: () {
        when(() => mockAuthFormatter.validateEmail("test"))
            .thenAnswer((realInvocation) => true);
        when(() => mockAuthFormatter.validatePassword("test"))
            .thenAnswer((realInvocation) => false);
      },
      build: () => cubit,
      act: (cubit) =>
          cubit.onEvent(LoginButtonWithCodeTapped("test", "test", null)),
      expect: () => [LoginScreenState.passwordError],
    );

    blocTest(
      'emits [RegistrationLoading, RegistrationLoaded] when _registerUser is called',
      setUp: () {
        when(() => mockAuthFormatter.validateEmail("test"))
            .thenAnswer((realInvocation) => true);
        when(() => mockAuthFormatter.validatePassword("test"))
            .thenAnswer((realInvocation) => true);
        when(() => mockAuthRepository.signIn("test", "test"))
            .thenAnswer((realInvocation) async => SignInResult.signedIn);
      },
      build: () => cubit,
      act: (cubit) =>
          cubit.onEvent(LoginButtonWithCodeTapped("test", "test", null)),
      expect: () => [
        LoginScreenState.loading,
        LoginScreenState.loggedIn,
      ],
    );
  });
}
