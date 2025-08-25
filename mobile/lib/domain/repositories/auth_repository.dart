abstract class AuthRepository {
  Future<void> login({required String email, required String password});

  Future<void> register({
    required String email,
    required String password,
    required String confirmationPassword,
    required String fullName,
  });

  Future<void> signOut();
}
