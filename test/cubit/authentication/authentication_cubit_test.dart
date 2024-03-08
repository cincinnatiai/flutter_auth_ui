import 'package:auth_common/contracts/auth_repository_contract.dart';
import 'package:auth_common/contracts/user_auth_repo_contract.dart';
import 'package:auth_common/enums/auth_enums.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:auth_ui/cubit/authentication/authentication_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuth extends Mock implements AuthRepositoryContract {}

class MockUser extends Mock implements UserAuthRepoContract {}

void main() {
  late final AuthRepositoryContract mockAuthRepository;
  late final UserAuthRepoContract mockUserAuthRepo;
  late final AuthenticationCubit cubit;

  setUp(() {
    mockAuthRepository = MockAuth();
    mockUserAuthRepo = MockUser();
    cubit = AuthenticationCubit(
        authRepository: mockAuthRepository, userRepository: mockUserAuthRepo);
  });

  group('AuthenticationCubit', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      'emits [AuthenticationLoading, SuccesLogin] when it calls logIn',
      setUp: () {
        when(() => mockAuthRepository.signIn('test@test.com', 'password'))
            .thenAnswer((_) async => SignInResult.signedIn);
      },
      build: () => cubit,
      act: (cubit) => cubit.logIn('test@test.com', 'password', null, true),
      expect: () => [
        AuthenticationLoading(),
        isA<SuccesLogin>(),
      ],
    );

    blocTest<AuthenticationCubit, AuthenticationState>(
      'emits [AuthenticationLoading, LoginError] when it calls logIn',
      setUp: () {
        when(() => mockAuthRepository.signIn('test@test.com', 'password'))
            .thenAnswer((_) async => SignInResult.incorrectCredentials);
      },
      build: () => cubit,
      act: (cubit) => cubit.logIn('test@test.com', 'password', null, true),
      expect: () => [
        AuthenticationLoading(),
        isA<LoginError>(),
      ],
    );
  });

  group('AuthenticationCubit signOut', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      'emits [AuthenticationLoading, SuccesLogin] when it calls signOut',
      setUp: () {
        when(() => mockAuthRepository.signOut())
            .thenAnswer((_) async => RegistrationResult.generalException);
      },
      build: () => cubit,
      act: (cubit) => cubit.signOut(),
      expect: () => [
        SignOutLoading(),
        isA<SignOutLoaded>(),
      ],
    );

    blocTest<AuthenticationCubit, AuthenticationState>(
      'emits [AuthenticationLoading, LoginError] when it calls signOut',
      setUp: () {
        when(() => mockAuthRepository.signOut())
            .thenThrow(Exception("Something went wrong"));
      },
      build: () => cubit,
      act: (cubit) => cubit.signOut(),
      expect: () => [
        SignOutLoading(),
        isA<SignOutError>(),
      ],
    );
  });
}
