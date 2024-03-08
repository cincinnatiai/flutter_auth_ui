import 'package:auth_common/contracts/auth_formatter_contract.dart';
import 'package:auth_common/contracts/auth_repository_contract.dart';
import 'package:auth_common/enums/auth_enums.dart';
import 'package:auth_ui/cubit/sign_in_w_code/sign_in_w_code_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:common/reusable_classes/reusable_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepositoryContract extends Mock
    implements AuthRepositoryContract {}

class MockAuthFormatterContract extends Mock implements AuthFormatterContract {}

void main() {
  late MockAuthRepositoryContract mockAuthRepository;
  late MockAuthFormatterContract mockAuthFormatter;
  late EmailCodeCubit cubit;

  setUp(() {
    mockAuthRepository = MockAuthRepositoryContract();
    mockAuthFormatter = MockAuthFormatterContract();

    cubit = EmailCodeCubit(
      authRepo: mockAuthRepository,
      formValidator: mockAuthFormatter,
    );
  });

  group('EmailCodeCubit tests', () {
    blocTest(
      'emits [ReusableLoadingState, ReusableLoadedState] when confirmEmail is called',
      setUp: () {
        when(() => mockAuthRepository.signInWithCode("test", "test", "12345"))
            .thenAnswer((realInvocation) async => SignInResult.signedIn);
      },
      build: () => cubit,
      act: (cubit) => cubit.confirmEmail("test", "test", "12345"),
      expect: () => [
        ReusableLoadingState(),
        const ReusableLoadedState(),
      ],
    );

    blocTest(
      'emits [ReusableLoadingState, ReusableErrorState] when confirmEmail is called and an issue occurs',
      setUp: () {
        when(() => mockAuthRepository.signInWithCode("test", "test", "12345"))
            .thenThrow(throwsException);
      },
      build: () => cubit,
      act: (cubit) => cubit.confirmEmail("test", "test", "12345"),
      expect: () => [
        ReusableLoadingState(),
        isA<ReusableErrorState>(),
      ],
    );
  });
}
