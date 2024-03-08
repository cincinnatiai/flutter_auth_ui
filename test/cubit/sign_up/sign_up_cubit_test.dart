import 'package:auth_common/contracts/auth_formatter_contract.dart';
import 'package:auth_common/contracts/auth_repository_contract.dart';
import 'package:auth_common/enums/auth_enums.dart';
import 'package:auth_ui/cubit/sign_up/sign_up_cubit.dart';
import 'package:auth_ui/cubit/sign_up/sign_up_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepositoryContract extends Mock
    implements AuthRepositoryContract {}

class MockAuthFormatterContract extends Mock implements AuthFormatterContract {}

void main() {
  late MockAuthRepositoryContract mockAuthRepository;
  late MockAuthFormatterContract mockAuthFormatter;
  late RegistrationCubit cubit;

  setUp(() {
    mockAuthRepository = MockAuthRepositoryContract();
    mockAuthFormatter = MockAuthFormatterContract();

    cubit = RegistrationCubit(
      authRepo: mockAuthRepository,
      formValidator: mockAuthFormatter,
    );
  });

  group('RegistrationCubit tests', () {
    blocTest(
      'emits [RegistrationError] when _registerUser has incorrect email',
      setUp: () {
        when(() => mockAuthFormatter.validateEmail("test"))
            .thenAnswer((realInvocation) => false);
      },
      build: () => cubit,
      act: (cubit) => cubit.onEvent(RegistrationTapped("test", "test")),
      expect: () => [
        isA<RegistrationError>(),
      ],
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
      act: (cubit) => cubit.onEvent(RegistrationTapped("test", "test")),
      expect: () => [
        isA<RegistrationError>(),
      ],
    );

    blocTest(
      'emits [RegistrationLoading, RegistrationLoaded] when _registerUser is called',
      setUp: () {
        when(() => mockAuthFormatter.validateEmail("test"))
            .thenAnswer((realInvocation) => true);
        when(() => mockAuthFormatter.validatePassword("test"))
            .thenAnswer((realInvocation) => true);
        when(() => mockAuthRepository.signUp("test", "test"))
            .thenAnswer((realInvocation) async => RegistrationResult.success);
      },
      build: () => cubit,
      act: (cubit) => cubit.onEvent(RegistrationTapped("test", "test")),
      expect: () => [
        RegistrationLoading(),
        isA<RegistrationLoaded>(),
      ],
    );
  });
}
