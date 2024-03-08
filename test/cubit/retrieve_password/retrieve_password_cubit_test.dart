import 'package:auth_common/contracts/auth_formatter_contract.dart';
import 'package:auth_common/contracts/auth_repository_contract.dart';
import 'package:auth_common/enums/auth_enums.dart';
import 'package:auth_ui/cubit/retrieve_password/retrieve_password_state.dart';
import 'package:auth_ui/cubit/retrieve_password/retrive_password_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepositoryContract extends Mock
    implements AuthRepositoryContract {}

class MockAuthFormatterContract extends Mock implements AuthFormatterContract {}

void main() {
  late MockAuthRepositoryContract mockAuthRepository;
  late MockAuthFormatterContract mockAuthFormatter;
  late RetrievePasswordCubit cubit;

  setUp(() {
    mockAuthRepository = MockAuthRepositoryContract();
    mockAuthFormatter = MockAuthFormatterContract();

    cubit = RetrievePasswordCubit(
      authRepo: mockAuthRepository,
      formValidator: mockAuthFormatter,
    );
  });

  group('RetrievePasswordCubit tests', () {
    blocTest(
      'emits [RegistrationError] when _registerUser has incorrect email',
      setUp: () {
        when(() => mockAuthFormatter.validateEmail("test"))
            .thenAnswer((realInvocation) => false);
      },
      build: () => cubit,
      act: (cubit) => cubit.onEvent(
          RetrivePasswordButtonWithCodeTapped("test", "test", "12345")),
      expect: () => [PasswordState.emailError],
    );

    blocTest(
      'emits [PasswordState.loading, PasswordState.passwordError] when _registerUser has incorrect password',
      setUp: () {
        when(() => mockAuthFormatter.validateEmail("test"))
            .thenAnswer((realInvocation) => true);
        when(() => mockAuthFormatter.validatePassword("test"))
            .thenAnswer((realInvocation) => false);
      },
      build: () => cubit,
      act: (cubit) => cubit.onEvent(
          RetrivePasswordButtonWithCodeTapped("test", "test", "12345")),
      expect: () => [PasswordState.loading, PasswordState.passwordError],
    );

    blocTest(
      'emits [PasswordState.loading, PasswordState.passwordChanged] when _changePassword with empty code',
      setUp: () {
        when(() => mockAuthFormatter.validateEmail("test"))
            .thenAnswer((realInvocation) => true);
        when(() => mockAuthRepository.passwordRecoveryRequest("test"))
            .thenAnswer((realInvocation) async => PasswordResult.success);
      },
      build: () => cubit,
      act: (cubit) => cubit
          .onEvent(RetrivePasswordButtonWithCodeTapped("test", "test", null)),
      expect: () => [PasswordState.loading, PasswordState.passwordChanged],
    );

    blocTest(
      'emits [PasswordState.loading, PasswordState.passwordChanged] when _registerUser with any code',
      setUp: () {
        when(() => mockAuthFormatter.validateEmail("test"))
            .thenAnswer((realInvocation) => true);
        when(() => mockAuthFormatter.validatePassword("test"))
            .thenAnswer((realInvocation) => true);
        when(() => mockAuthRepository.passwordConfirmation(
                "test", "test", "12345"))
            .thenAnswer((realInvocation) async => PasswordResult.success);
      },
      build: () => cubit,
      act: (cubit) => cubit.onEvent(
          RetrivePasswordButtonWithCodeTapped("test", "test", "12345")),
      expect: () => [PasswordState.loading, PasswordState.passwordChanged],
    );
  });
}
