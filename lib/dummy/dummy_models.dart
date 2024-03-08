import 'package:auth_common/contracts/user_auth__model_contract.dart';

class DummyUserAuthModel implements UserAuthModelContract {
  @override
  final String clientId;

  @override
  final String email;

  @override
  final String firstName;

  @override
  final String lastName;

  @override
  final String rangeKey;

  const DummyUserAuthModel({
    required this.clientId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.rangeKey,
  });
}
